package com.thedeveloper.gnext.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.thedeveloper.gnext.controller.models.PropertiesModel;
import com.thedeveloper.gnext.entity.AddressEntity;
import com.thedeveloper.gnext.entity.OrderEntity;
import com.thedeveloper.gnext.entity.TransportationEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.TransportationCategory;
import com.thedeveloper.gnext.service.AddressService;
import com.thedeveloper.gnext.service.TransportationService;
import com.thedeveloper.gnext.service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@AllArgsConstructor
@RequestMapping("api/v1/transportings")
public class TransportationController {
    TransportationService transportationService;
    UserService userService;
    AddressService addressService;
    @PostMapping(value = "/create", consumes = {MediaType.ALL_VALUE})
    public ResponseEntity<?> createTransportation(@RequestParam String uid, @RequestParam double price, @RequestParam String description, @RequestParam boolean outcity,@RequestParam TransportationCategory category, @DateTimeFormat(pattern = "yyyy-MM-dd") Date date,@ModelAttribute(name = "properties") String propertiesModel) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        PropertiesModel properties = objectMapper.readValue(propertiesModel, PropertiesModel.class);
        UserEntity user = userService.findUserByUid(uid);
        TransportationEntity transportation = new TransportationEntity();
        transportation.setCategory(category);
        transportation.setCreator(user);
        transportation.setCity(user.getCity());
        transportation.setDescription(description);
        transportation.setPrice(price);
        transportation.setOutCity(outcity);
        transportation.setCreateDate(new Date());
        transportation.setDate(date);
        AddressEntity addressTo = properties.getAddressTo().toAddressEntity();
        addressService.save(addressTo);
        AddressEntity addressFrom = properties.getAddressFrom().toAddressEntity();
        addressService.save(addressFrom);

        transportation.setAddressTo(addressTo);
        transportation.setAddressFrom(addressFrom);

        transportationService.save(transportation);

        return new ResponseEntity<>(HttpStatus.CREATED);
    }
    @PostMapping("/stop")
    public ResponseEntity<?> stopOrder(@RequestParam Long id){
        TransportationEntity transportation = transportationService.findById(id);
        transportation.setActive(false);
        transportationService.save(transportation);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/active")
    public ResponseEntity<?> activeOrders(@RequestParam String uid, @RequestParam boolean outcity, @RequestParam TransportationCategory category){
        UserEntity user = userService.findUserByUid(uid);
        return new ResponseEntity<>(transportationService.findActive(user, outcity, category), HttpStatus.OK);
    }
    @GetMapping("/my")
    public ResponseEntity<?> userTransportation(@RequestParam String uid, @RequestParam boolean outcity, @RequestParam TransportationCategory category) {
        UserEntity user = userService.findUserByUid(uid);
        return new ResponseEntity<>(transportationService.findByCreatorAndCityAndOutcity(user, outcity, category), HttpStatus.OK);
    }

}

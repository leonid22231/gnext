package com.thedeveloper.gnext.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.thedeveloper.gnext.controller.models.PropertiesModel;
import com.thedeveloper.gnext.entity.AddressEntity;
import com.thedeveloper.gnext.entity.OrderEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.service.AddressService;
import com.thedeveloper.gnext.service.FileService;
import com.thedeveloper.gnext.service.OrderService;
import com.thedeveloper.gnext.service.UserService;
import com.thedeveloper.gnext.utils.Globals;
import lombok.AllArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;

@RestController
@RequestMapping("api/v1/orders")
@AllArgsConstructor
public class OrdersController {
    OrderService orderService;
    UserService userService;
    AddressService addressService;
    FileService fileService;
    @PostMapping(value = "/create", consumes = {MediaType.ALL_VALUE})
    public ResponseEntity<?> createOrder(@RequestParam boolean customPrice, @RequestParam String uid, @RequestParam double price, @RequestParam String description, @RequestParam boolean outcity, @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate, @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate, @ModelAttribute(name = "properties") String propertiesModel, @RequestPart(value = "file",required = false) MultipartFile file) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        PropertiesModel properties = objectMapper.readValue(propertiesModel, PropertiesModel.class);
        UserEntity user = userService.findUserByUid(uid);
        OrderEntity orderEntity = new OrderEntity();
        orderEntity.setCreator(user);
        orderEntity.setCity(user.getCity());
        orderEntity.setCreateDate(new Date());
        orderEntity.setPrice(price);
        orderEntity.setDescription(description);
        orderEntity.setOutCity(outcity);
        orderEntity.setStartDate(startDate);
        orderEntity.setEndDate(endDate);
        if(file!=null){
            fileService.store(file);
            orderEntity.setFile(Globals.renameDoc(file.getOriginalFilename(), fileService));
        }
        AddressEntity addressTo = properties.getAddressTo().toAddressEntity();
        addressService.save(addressTo);
        AddressEntity addressFrom = properties.getAddressFrom().toAddressEntity();
        addressService.save(addressFrom);

        orderEntity.setAddressTo(addressTo);
        orderEntity.setAddressFrom(addressFrom);

        orderEntity.setCustomPrice(customPrice);
        orderService.save(orderEntity);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
    @PostMapping("/stop")
    public ResponseEntity<?> stopOrder(@RequestParam Long id){
        OrderEntity orderEntity = orderService.findById(id);
        orderEntity.setActive(false);
        orderService.save(orderEntity);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/active")
    public ResponseEntity<?> activeOrders(@RequestParam String uid, @RequestParam boolean outcity){
        UserEntity user = userService.findUserByUid(uid);
        return new ResponseEntity<>(orderService.findActive(outcity, user.getCity()), HttpStatus.OK);
    }
    @GetMapping("/my")
    public ResponseEntity<?> userOrders(@RequestParam String uid, @RequestParam boolean outcity){
        UserEntity user = userService.findUserByUid(uid);
        return new ResponseEntity<>(orderService.findByCreator(user, outcity, user.getCity()), HttpStatus.OK);
    }
}

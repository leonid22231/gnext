package com.thedeveloper.gnext.controller;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.CountryEntity;
import com.thedeveloper.gnext.entity.LocationEntity;
import com.thedeveloper.gnext.service.ChatService;
import com.thedeveloper.gnext.service.CityService;
import com.thedeveloper.gnext.service.CountryService;
import com.thedeveloper.gnext.service.LocationService;
import com.thedeveloper.gnext.utils.Globals;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/v1/location")
@AllArgsConstructor
@Slf4j
public class LocationController {
    LocationService locationService;
    CountryService countryService;
    ChatService chatService;
    CityService cityService;
    @GetMapping("/countries")
    public ResponseEntity<List<CountryEntity>> findAllCity(){
        return new ResponseEntity<>(countryService.findAll(), HttpStatus.OK);
    }
    @PostMapping("/country/create")
    public ResponseEntity<?> createCountry(@RequestParam String name){
        CountryEntity temp_country = countryService.findByName(name);
        if(temp_country!=null)return new ResponseEntity<>("Страна уже существует", HttpStatus.BAD_REQUEST);

        CountryEntity country = new CountryEntity();
        country.setName(name);
        countryService.save(country);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
    @PostMapping("/city/create")
    public ResponseEntity<?> createCity(@RequestParam Long countryId,@RequestParam String name){
        CountryEntity country = countryService.findById(countryId);
        if(country==null) return new ResponseEntity<>("Страны не существует",  HttpStatus.BAD_REQUEST);
        CityEntity temp_city = cityService.findByName(name);
        if(temp_city!=null) return new ResponseEntity<>("Город в этой стране уже существует", HttpStatus.BAD_REQUEST);
        CityEntity city = new CityEntity();
        city.setName(name);
        cityService.save(city);
        country.getCities().add(city);
        countryService.save(country);
        LocationEntity location = new LocationEntity();
        location.setCountry(country);
        location.setCity(city);
        locationService.save(location);
        Globals.initChats(locationService, chatService, log);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
    @DeleteMapping("/city/delete")
    public ResponseEntity<?> deleteCity(@RequestParam Long id){
        CityEntity city = cityService.findById(id);
        if(city==null) return new ResponseEntity<>("Город не найден", HttpStatus.BAD_REQUEST);
        CountryEntity country = countryService.findCountryByCity(city);
        if(country==null) return new ResponseEntity<>("Ошибка сервера", HttpStatus.BAD_REQUEST);
        for(int i = 0; i < country.getCities().size(); i++){
            if(country.getCities().get(i).getName().equals(city.getName())){
                country.getCities().remove(i);
                break;
            }
        }
        countryService.save(country);
        cityService.delete(city);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}

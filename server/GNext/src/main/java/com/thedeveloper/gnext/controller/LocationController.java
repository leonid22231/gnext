package com.thedeveloper.gnext.controller;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.CountryEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.entity.WalletEventEntity;
import com.thedeveloper.gnext.enums.WalletEventType;
import com.thedeveloper.gnext.models.CityModel;
import com.thedeveloper.gnext.models.CountryModel;
import com.thedeveloper.gnext.service.*;
import com.thedeveloper.gnext.utils.Globals;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.catalina.User;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("api/v1/location")
@AllArgsConstructor
@Slf4j
public class LocationController {
    WalletEventService walletEventService;
    UserService userService;
    CountryService countryService;
    ChatService chatService;
    CityService cityService;
    @GetMapping("/countries")
    public ResponseEntity<List<CountryEntity>> findAllCity(){
        return new ResponseEntity<>(countryService.findAll(), HttpStatus.OK);
    }
    @GetMapping("/AdminCountries")
    public ResponseEntity<?> findAllCityAdmin(){
        List<CountryModel> countryModels = new ArrayList<>();
        for(CountryEntity country : countryService.findAll()){
            CountryModel countryModel = new CountryModel();
            countryModel.setId(country.getId());
            countryModel.setName(country.getName());
            for(CityEntity city : country.getCities()){
                CityModel cityModel = new CityModel();
                cityModel.setName(city.getName());
                cityModel.setId(city.getId());
                cityModel.setValue(0);
                List<UserEntity> users = userService.findByCity(city);
                for(UserEntity user : users){
                    for(WalletEventEntity event : walletEventService.findByUser(user)){
                        if(event.getType()== WalletEventType.ADD){
                            cityModel.setValue(cityModel.getValue() + event.getSum());
                        }
                    }
                }
                countryModel.getCities().add(cityModel);
            }
            countryModels.add(countryModel);
        }
        return new ResponseEntity<>(countryModels, HttpStatus.OK);
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
        Globals.initChats(cityService, chatService, log);
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
    @GetMapping("/country/byCity")
    public ResponseEntity<?> findCountryByCity(@RequestParam("id")Long id){
        CityEntity city = cityService.findById(id);
        return new ResponseEntity<>(countryService.findCountryByCity(city), HttpStatus.OK);
    }
}

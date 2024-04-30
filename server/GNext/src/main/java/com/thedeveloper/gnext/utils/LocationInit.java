package com.thedeveloper.gnext.utils;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.CountryEntity;
import com.thedeveloper.gnext.entity.LocationEntity;
import com.thedeveloper.gnext.service.CountryService;
import com.thedeveloper.gnext.service.LocationService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@AllArgsConstructor
@Slf4j
@Order(1)
public class LocationInit implements CommandLineRunner {
    CountryService countryService;
    LocationService locationService;
    @Override
    public void run(String... args) throws Exception {
        log.info("Init location...");
        List<CountryEntity> countryEntityList = countryService.findAll();
        log.info("Countries count {}", countryEntityList.size());
        int cities = 0;
        for(CountryEntity country : countryEntityList){
            cities+= country.getCities().size();
            for(CityEntity city : country.getCities()){
                LocationEntity temp_location = locationService.findByCountryAndCity(country, city);
                if(temp_location==null){
                    LocationEntity location = new LocationEntity();
                    location.setCountry(country);
                    location.setCity(city);
                    locationService.save(location);
                }
            }
        }
        log.info("Locations count {}", cities);
    }
}

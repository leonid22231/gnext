package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.CountryEntity;
import com.thedeveloper.gnext.entity.LocationEntity;
import com.thedeveloper.gnext.repository.LocationRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class LocationService {
    LocationRepository repository;
    public void save(LocationEntity location){
        repository.save(location);
    }
    public List<LocationEntity> findAll(){
        return repository.findAll();
    }
    public LocationEntity findByCountryAndCity(CountryEntity country, CityEntity city){
        return repository.findLocationEntityByCountryAndCity(country,city);
    }
    public LocationEntity findById(Long id){
        return repository.findLocationEntityById(id);
    }
}

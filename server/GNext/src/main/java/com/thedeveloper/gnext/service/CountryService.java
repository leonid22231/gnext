package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.CountryEntity;
import com.thedeveloper.gnext.repository.CountryRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class CountryService {
    CountryRepository repository;
    public List<CountryEntity> findAll(){
        return repository.findAll();
    }
    public void save(CountryEntity country){
        repository.save(country);
    }
    public CountryEntity findById(Long id){
        return repository.findCountryEntityById(id);
    }
    public CountryEntity findByName(String name){
        return repository.findCountryEntityByName(name);
    }
    public CountryEntity findCountryByCity(CityEntity city){
        return repository.findCountryEntityByCitiesContaining(city);
    }
}

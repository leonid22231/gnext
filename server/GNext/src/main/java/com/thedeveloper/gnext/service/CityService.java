package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.repository.CityRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class CityService {
    CityRepository repository;
    public List<CityEntity> findAll(){
        return repository.findAll();
    }
    public void save(CityEntity city){
        repository.save(city);
    }
    public CityEntity findByName(String name){
        return repository.findCityEntityByName(name);
    }
    public CityEntity findById(Long id){
        return repository.findCityEntityById(id);
    }
    public void delete(CityEntity city){
        repository.delete(city);
    }
}

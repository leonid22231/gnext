package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.AddressEntity;
import com.thedeveloper.gnext.repository.AddressRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class AddressService {
    AddressRepository repository;
    public void save(AddressEntity address){
        repository.save(address);
    }
}

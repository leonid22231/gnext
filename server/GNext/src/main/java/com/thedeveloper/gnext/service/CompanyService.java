package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.CompanyEntity;
import com.thedeveloper.gnext.entity.LocationEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.Categories;
import com.thedeveloper.gnext.repository.CompanyRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class CompanyService {
    CompanyRepository repository;
    public List<CompanyEntity> findByCategory(Categories category, LocationEntity location){
        return repository.findCompanyEntityByCategoryAndLocation(category, location);
    }
    public CompanyEntity findById(Long id){
        return repository.findCompanyEntityById(id);
    }
    public CompanyEntity findByManager(UserEntity user){
        return repository.findCompanyEntityByManager(user);
    }
    public void save(CompanyEntity company){
        repository.save(company);
    }
    public void delete(CompanyEntity company){
        repository.delete(company);
    }
}

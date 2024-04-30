package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.CountryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CountryRepository extends JpaRepository<CountryEntity, Long> {
    CountryEntity findCountryEntityByName(String name);
    CountryEntity findCountryEntityById(Long id);
    CountryEntity findCountryEntityByCitiesContaining(CityEntity city);
}

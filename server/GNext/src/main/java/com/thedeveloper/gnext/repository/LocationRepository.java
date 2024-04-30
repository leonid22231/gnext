package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.CountryEntity;
import com.thedeveloper.gnext.entity.LocationEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LocationRepository extends JpaRepository<LocationEntity, Long> {
    LocationEntity findLocationEntityByCountryAndCity(CountryEntity country, CityEntity city);
    LocationEntity findLocationEntityById(Long id);
}

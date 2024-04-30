package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.CityEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CityRepository extends JpaRepository<CityEntity, Long> {
    CityEntity findCityEntityByName(String name);
    CityEntity findCityEntityById(Long id);
}

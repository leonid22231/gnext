package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.TransportationEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TransportationRepository extends JpaRepository<TransportationEntity, Long> {
    List<TransportationEntity> findTransportationEntitiesByCreatorAndOutCityAndCity(UserEntity creator, boolean outcity, CityEntity city);
    List<TransportationEntity> findTransportationEntitiesByActiveAndCityAndOutCity(boolean active, CityEntity city, boolean outcity);
    TransportationEntity findTransportationEntityById(Long id);
}

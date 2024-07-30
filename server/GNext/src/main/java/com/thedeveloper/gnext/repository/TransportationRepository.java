package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.OrderEntity;
import com.thedeveloper.gnext.entity.TransportationEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.TransportationCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TransportationRepository extends JpaRepository<TransportationEntity, Long> {
    List<TransportationEntity> findTransportationEntitiesByCreatorAndOutCityAndCityAndCategoryAndActive(UserEntity creator, boolean outcity, CityEntity city, TransportationCategory category, boolean active);
    List<TransportationEntity> findTransportationEntitiesByActiveAndCityAndOutCityAndCategory(boolean active, CityEntity city, boolean outcity, TransportationCategory category);
    TransportationEntity findTransportationEntityById(Long id);
    List<TransportationEntity> findTransportationEntitiesByCreator(UserEntity creator);
    @Query(
            value = "SELECT * FROM transportings WHERE DATE_ADD(transportings.create_date, interval 2 day ) < NOW();",
            nativeQuery = true)
    List<TransportationEntity> findAllAfter48Hourse();
}

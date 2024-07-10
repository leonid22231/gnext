package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.OrderEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.OrderMode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<OrderEntity, Long> {
    List<OrderEntity> findOrderEntitiesByCreatorAndOutCityAndCityAndActiveAndMode(UserEntity creator, boolean outcity, CityEntity city, boolean active, OrderMode mode);
    List<OrderEntity> findOrderEntitiesByOutCityAndCityAndActiveAndMode(boolean outcity, CityEntity city, boolean active,OrderMode mode);
    List<OrderEntity> findOrderEntitiesByActiveAndMode(boolean active,OrderMode mode);
    List<OrderEntity> findOrderEntitiesByActiveAndModeAndAddressTo_CityAndAddressFrom_City(boolean active, OrderMode mode, String cityTo, String cityFrom);
    OrderEntity findOrderEntityById(Long id);
    List<OrderEntity> findOrderEntitiesByCreator(UserEntity creator);
}

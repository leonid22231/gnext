package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.OrderEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<OrderEntity, Long> {
    List<OrderEntity> findOrderEntitiesByCreatorAndOutCityAndCityAndActive(UserEntity creator, boolean outcity, CityEntity city, boolean active);
    List<OrderEntity> findOrderEntitiesByOutCityAndCityAndActive(boolean outcity, CityEntity city, boolean active);
    List<OrderEntity> findOrderEntitiesByActive(boolean active);
    OrderEntity findOrderEntityById(Long id);
}

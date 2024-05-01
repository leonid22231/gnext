package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.OrderEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.repository.OrderRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class OrderService {
    OrderRepository repository;
    public void save(OrderEntity orderEntity){
        repository.save(orderEntity);
    }
    public List<OrderEntity> findAll(){
        return repository.findAll();
    }
    public List<OrderEntity> findActive(boolean outcity, CityEntity city){
        return repository.findOrderEntitiesByOutCityAndCityAndActive(outcity, city, true);
    }
    public List<OrderEntity> findByCreator(UserEntity user, boolean outcity, CityEntity city){
        return repository.findOrderEntitiesByCreatorAndOutCityAndCityAndActive(user, outcity, city, true);
    }
    public List<OrderEntity> findActive(){
        return repository.findOrderEntitiesByActive(true);
    }
    public OrderEntity findById(Long id){
        return repository.findOrderEntityById(id);
    }

}

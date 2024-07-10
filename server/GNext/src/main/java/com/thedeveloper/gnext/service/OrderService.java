package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.OrderEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.OrderMode;
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
    public void delete(OrderEntity orderEntity){
        repository.delete(orderEntity);
    }
    public List<OrderEntity> findAll(){
        return repository.findAll();
    }
    public List<OrderEntity> findAllByUser(UserEntity user){
        return repository.findOrderEntitiesByCreator(user);
    }
    public List<OrderEntity> findActive(boolean outcity, CityEntity city){
        return repository.findOrderEntitiesByOutCityAndCityAndActiveAndMode(outcity, city, true, OrderMode.CLASSIC);
    }
    public List<OrderEntity> findByCreator(UserEntity user, boolean outcity, CityEntity city, OrderMode mode){
        return repository.findOrderEntitiesByCreatorAndOutCityAndCityAndActiveAndMode(user, outcity, city, true, mode);
    }
    public List<OrderEntity> findActive(){
        return repository.findOrderEntitiesByActiveAndMode(true, OrderMode.CLASSIC);
    }
    public List<OrderEntity> searchOrders(boolean active, OrderMode mode, String addressFrom, String addressTo){
        return repository.findOrderEntitiesByActiveAndModeAndAddressTo_CityAndAddressFrom_City(active, mode, addressTo, addressFrom);
    }
    public OrderEntity findById(Long id){
        return repository.findOrderEntityById(id);
    }

}

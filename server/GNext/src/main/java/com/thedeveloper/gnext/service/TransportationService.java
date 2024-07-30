package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.OrderEntity;
import com.thedeveloper.gnext.entity.TransportationEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.TransportationCategory;
import com.thedeveloper.gnext.repository.TransportationRepository;
import com.thedeveloper.gnext.utils.NotificationService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class TransportationService {
    TransportationRepository repository;
    UserService userService;
    NotificationService notificationService;
    public void delete(TransportationEntity entity){
        repository.delete(entity);
    }
    public List<TransportationEntity> findAllByUser(UserEntity user){
        return repository.findTransportationEntitiesByCreator(user);
    }
    public List<TransportationEntity> findByCreatorAndCityAndOutcity(UserEntity creator, boolean outcity, TransportationCategory category){
        return repository.findTransportationEntitiesByCreatorAndOutCityAndCityAndCategoryAndActive(creator, outcity, creator.getCity(), category, true);
    }
    public List<TransportationEntity> findActive(UserEntity user, boolean outcity, TransportationCategory category){
        return repository.findTransportationEntitiesByActiveAndCityAndOutCityAndCategory(true, user.getCity(), outcity, category);
    }
    public TransportationEntity findById(Long id){
        return repository.findTransportationEntityById(id);
    }
    public void save(TransportationEntity transportationEntity){
        repository.save(transportationEntity);
        for(UserEntity user: userService.findByCity(transportationEntity.getCity())){
            if(!user.getId().equals(transportationEntity.getCreator().getId())){
                notificationService.sendNotification(user);
            }
        }
    }
    public List<TransportationEntity> findAllAfter48Hours(){
        return repository.findAllAfter48Hourse();
    }
}

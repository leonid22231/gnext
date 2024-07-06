package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.TransportationEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.TransportationCategory;
import com.thedeveloper.gnext.repository.TransportationRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class TransportationService {
    TransportationRepository repository;

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
    }
}

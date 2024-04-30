package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.entity.WalletEventEntity;
import com.thedeveloper.gnext.repository.WalletEventRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class WalletEventService {
    WalletEventRepository repository;

    public void save(WalletEventEntity event){
        repository.save(event);
    }
    public List<WalletEventEntity> findByUser(UserEntity user){
        return repository.findWalletEventEntitiesByUser(user);
    }
}

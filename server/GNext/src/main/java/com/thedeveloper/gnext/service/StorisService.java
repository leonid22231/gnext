package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.ChatEntity;
import com.thedeveloper.gnext.entity.StorisEntity;
import com.thedeveloper.gnext.repository.StorisRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class StorisService {
    StorisRepository storisRepository;
    public void save(StorisEntity storisEntity){
        storisRepository.save(storisEntity);
    }
    public List<StorisEntity> getStorisByChat(ChatEntity chat){
        return storisRepository.findStorisEntitiesByChatOrderByCreateDateAsc(chat);
    }
    public List<StorisEntity> findAll(){
        return  storisRepository.findAll();
    }
    public void delete(StorisEntity storis){
        storisRepository.delete(storis);
    }
}

package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
@AllArgsConstructor
@Slf4j
public class UserService {
    UserRepository userRepository;
    public UserEntity findUserByPhone(String phone){
       return userRepository.findUserEntityByPhone(phone);
    }
    public UserEntity findUserByUid(String uid){
        return  userRepository.findUserEntityByUid(uid);
    }
    public void save(UserEntity user){
        userRepository.save(user);
    }
    public List<UserEntity> findAll(){
        return userRepository.findAll();
    }
    public List<UserEntity> searchByQuery(String query){
        List<UserEntity> list = new ArrayList<>();
        addAll(list,userRepository.searchUserEntitiesByNameContaining(query));
        addAll(list, userRepository.searchUserEntitiesBySurnameContaining(query));
        try{
            Long num = Long.parseLong(query);
            if(query.startsWith("8")){
                num = Long.parseLong(query.replaceFirst("8","7"));
            }
            addAll(list, userRepository.searchUserEntitiesByPhoneContainingIgnoreCase(num.toString()));
        }catch (Exception e){
            log.info("{} not number", query);
        }
        return  list;
    }
    private void addAll(List<UserEntity> list,List<UserEntity> users){
        us:for(UserEntity user : users){
            for(UserEntity userEntity : list){
                if(Objects.equals(userEntity.getId(), user.getId())){
                    continue us;
                }
            }
            list.add(user);
        }
    }
}

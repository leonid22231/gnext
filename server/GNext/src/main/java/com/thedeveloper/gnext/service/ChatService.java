package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.ChatEntity;
import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.CompanyEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.ChatMode;
import com.thedeveloper.gnext.repository.ChatRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@AllArgsConstructor
public class ChatService {
    ChatRepository repository;
    public ChatEntity findByName(String name){
        return repository.findChatEntityByName(name);
    }
    public ChatEntity findByCityAndName(CityEntity city, String name){
        return repository.findChatEntityByCityAndName(city, name);
    }
    public void delete(ChatEntity chatEntity){
        repository.delete(chatEntity);
    }
    public ChatEntity findById(String id){
        return repository.findChatEntityById(id);
    }
    public void save(ChatEntity chat){
        repository.save(chat);
    }
    public List<ChatEntity> findByUser(UserEntity user){
        List<ChatEntity> chats_1 = repository.findChatEntityByCityAndMember1(user.getCity(), user);
        List<ChatEntity> chats_2 = repository.findChatEntitiesByCityAndMember2(user.getCity(), user);
        List<ChatEntity> all = new ArrayList<>();
        all.addAll(chats_1);
        all.addAll(chats_2);
        return all;
    }
    public List<ChatEntity> findAll(){
        return repository.findAll();
    }
    public List<ChatEntity> findGlobals(CityEntity city){
        return repository.findChatEntitiesByCityAndMode(city, ChatMode.GENERAL);
    }
    public ChatEntity findByMembers(CityEntity city, UserEntity member1, UserEntity member2){
        ChatEntity chat = repository.findChatEntityByCityAndMember1AndMember2(city,member1,member2);
        if(chat==null){
            chat = repository.findChatEntityByCityAndMember1AndMember2(city, member2, member1);
            return  chat;
        }else{
            return chat;
        }
    }
    public ChatEntity findByMembersAndCompany(CityEntity city, UserEntity member1, UserEntity member2, CompanyEntity company){
        ChatEntity chat = repository.findChatEntityByCityAndMember1AndMember2AndCompany(city,member1,member2, company);
        if(chat==null){
            chat = repository.findChatEntityByCityAndMember1AndMember2AndCompany(city, member2, member1, company);
            return  chat;
        }else{
            return chat;
        }
    }
}

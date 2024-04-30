package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.ChatEntity;
import com.thedeveloper.gnext.entity.CompanyEntity;
import com.thedeveloper.gnext.entity.LocationEntity;
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
    public ChatEntity findChatByName(String name){
        return repository.findChatEntityByName(name);
    }
    public ChatEntity findChatByLocationAndName(LocationEntity location, String name){
        return repository.findChatEntityByLocationAndName(location, name);
    }
    public ChatEntity findById(String id){
        return repository.findChatEntityById(id);
    }
    public void save(ChatEntity chat){
        repository.save(chat);
    }
    public List<ChatEntity> findByUser(UserEntity user){
        List<ChatEntity> chats_1 = repository.findChatEntityByLocationAndMember1(user.getLocation(), user);
        List<ChatEntity> chats_2 = repository.findChatEntitiesByLocationAndMember2(user.getLocation(), user);
        List<ChatEntity> all = new ArrayList<>();
        all.addAll(chats_1);
        all.addAll(chats_2);
        return all;
    }
    public List<ChatEntity> findAll(){
        return repository.findAll();
    }
    public List<ChatEntity> findGlobals(LocationEntity location){
        return repository.findChatEntitiesByLocationAndMode(location, ChatMode.GENERAL);
    }
    public ChatEntity findByMembers(LocationEntity location, UserEntity member1, UserEntity member2){
        ChatEntity chat = repository.findChatEntityByLocationAndMember1AndMember2(location,member1,member2);
        if(chat==null){
            chat = repository.findChatEntityByLocationAndMember1AndMember2(location, member2, member1);
            return  chat;
        }else{
            return chat;
        }
    }
    public ChatEntity findByMembersAndCompany(LocationEntity location, UserEntity member1, UserEntity member2, CompanyEntity company){
        ChatEntity chat = repository.findChatEntityByLocationAndMember1AndMember2AndCompany(location,member1,member2, company);
        if(chat==null){
            chat = repository.findChatEntityByLocationAndMember1AndMember2AndCompany(location, member2, member1, company);
            return  chat;
        }else{
            return chat;
        }
    }
}

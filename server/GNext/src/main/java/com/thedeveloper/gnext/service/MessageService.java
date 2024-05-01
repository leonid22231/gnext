package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.ChatEntity;
import com.thedeveloper.gnext.entity.MessageEntity;
import com.thedeveloper.gnext.repository.MessageRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class MessageService {
    MessageRepository repository;
    public List<MessageEntity> findMessagesByChat(ChatEntity chat){
        return repository.findTop30MessageEntitiesByChatOrderByTimeDesc(chat);
    }
    public void save(MessageEntity message){
        repository.save(message);
    }
    public List<MessageEntity> findAll(){
        return repository.findAll();
    }
    public void delete(MessageEntity message){
        repository.delete(message);
    }
}

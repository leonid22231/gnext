package com.thedeveloper.gnext.controller;

import com.fasterxml.jackson.annotation.JsonView;
import com.thedeveloper.gnext.entity.ChatEntity;
import com.thedeveloper.gnext.entity.MessageEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.MessageType;
import com.thedeveloper.gnext.service.*;
import com.thedeveloper.gnext.utils.Globals;
import com.thedeveloper.gnext.views.UserViews;

import lombok.AllArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("api/v1/chat")
@AllArgsConstructor
public class ChatController {
    ChatService chatService;
    MessageService messageService;
    LocationService locationService;
    UserService userService;
    AudioService audioService;
    ImageService imageService;
    @GetMapping("/findId")
    public ResponseEntity<?> findChat(@RequestParam String uid, @RequestParam String name){
        ChatEntity chat = chatService.findChatByLocationAndName(userService.findUserByUid(uid).getLocation(), name);
        if(chat==null) return new ResponseEntity<>("Чат не найден", HttpStatus.BAD_REQUEST);
        return new ResponseEntity<>(chat.getId(), HttpStatus.OK);
    }
    @GetMapping(value = "/audio/{name}", produces = {MediaType.APPLICATION_OCTET_STREAM_VALUE})
    public Resource getAudio(@PathVariable String name){
        return audioService.loadAsResource(name);
    }
    @PostMapping("/file")
    public ResponseEntity<?> file(@RequestParam String uid, @RequestParam MessageType type,@RequestParam MultipartFile file,@RequestParam String name){
        UserEntity user = userService.findUserByUid(uid);
        MessageEntity message = new MessageEntity();
        message.setChat(chatService.findChatByLocationAndName(user.getLocation(),name));
        message.setUser(user);
        message.setTime(new Date());
        message.setType(type);
        if(type==MessageType.AUDIO){
            audioService.store(file);
            message.setContent(Globals.renameAudio(file.getOriginalFilename(), audioService));
        }else{
            imageService.store(file);
            message.setContent(Globals.renameFile(file.getOriginalFilename(), imageService));
        }
        messageService.save(message);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/{id}")
    @JsonView(UserViews.MiniView.class)
    public ResponseEntity<List<MessageEntity>> messages(@RequestParam String uid,@PathVariable String id){
        UserEntity user = userService.findUserByUid(uid);
        List<MessageEntity> messages = messageService.findMessagesByChat(chatService.findById(id));
        List<MessageEntity> unread = new ArrayList<>();
        for(MessageEntity message : messages){
            boolean reading = false;
            for(UserEntity userReader : message.getReaders()){
                if(userReader.getId().equals(user.getId())){
                    reading = true;
                    break;
                }
            }
            if(!reading){
                unread.add(message);
            }
        }
        for(MessageEntity message : unread){
            message.getReaders().add(user);
            messageService.save(message);
        }
        return new ResponseEntity<>(messageService.findMessagesByChat(chatService.findById(id)), HttpStatus.OK);
    }
}

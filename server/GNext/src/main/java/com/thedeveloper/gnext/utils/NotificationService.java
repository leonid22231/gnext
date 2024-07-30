package com.thedeveloper.gnext.utils;

import com.google.firebase.messaging.*;
import com.thedeveloper.gnext.entity.ChatEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.service.UserService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;


@Slf4j
@Service
@AllArgsConstructor
public class NotificationService {
    UserService userService;
    public void sendNotification(UserEntity user){
        Message.Builder message = Message.builder()
                .putData("title", "Новый заказ")
        .putData("body", "Появился новый заказ!")
                .setToken(user.getNotifyToken());

        FirebaseMessaging firebaseMessaging = FirebaseMessaging.getInstance();
        try {
            firebaseMessaging.send(message.build());
        } catch (FirebaseMessagingException e) {
            log.info("Error {} send message {}",e.getMessagingErrorCode() ,e.getMessage());
        }
    }

}


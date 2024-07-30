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
    public void sendNotification(UserEntity user, ChatEntity chat){
        Notification.Builder notification = Notification.builder()
                .setTitle("Новое сообщение")
                .setBody(String.format("В чате '%s' новое сообщение", getChatName(chat)));
        Message.Builder message = Message.builder()
                .putData("chat", chat.getName())
                .putData("title", "Новое сообщение")
        .putData("body", String.format("В чате '%s' новое сообщение", getChatName(chat)))
                .setToken(user.getNotifyToken());



        FirebaseMessaging firebaseMessaging = FirebaseMessaging.getInstance();
        try {
            firebaseMessaging.send(message.build());
        } catch (FirebaseMessagingException e) {
            log.info("Error {} send message {}",e.getMessagingErrorCode() ,e.getMessage());
        }
    }
    String getChatName(ChatEntity chat){
        switch (chat.getName()){
            case "svar" : return "Сварщики";
            case "bet" : return "Бетонщики";
            case "bul" : return "Бульдозерист";
            case "meb" : return "Мебельщики";
            case "razn" : return "Разнорабочий";
            case "sles" : return "Слесарь";
            case "proect" : return "Проектировщик";
            case "gaz" : return "Газовщик";
            case "stec" : return "Стекольщик";
            case "park" : return "Паркетчик";
            case "el" : return "Электрики";
            case "vent" : return "Вентиляционщики";
            case "trash" : return "Вывоз строительного мусора";
            case "tok" : return "Токарь";
            case "frez" : return "Фрезеровщики";
            case "mal" : return "Маляр штукатур";
            case "zem" : return "Землекоп";
            case "obl" : return "Облицовщики";
            case "stol" : return "Столяры";
            case "geo" : return "Геодезист";
            case "plot" : return "Плотники";
            case "san" : return "Сантехники";
            case "strop" : return "Стропальщики";
            case "kran" : return "Крановщики";
            case "cum" : return "Каменщики";
            case "pech" : return "Печники";
            case "mon" : return "Монтажники";
            case "krov" : return "Кровельщики";
            case "otd" : return "Отделочники";
            case "moto" : return "Моторист";
            case "other" : return "Другое";
            case "global" : return  "Общий";
        }

        return  "Null";
    }
}


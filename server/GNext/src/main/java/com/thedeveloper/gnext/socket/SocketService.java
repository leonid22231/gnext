package com.thedeveloper.gnext.socket;

import com.corundumstudio.socketio.SocketIOClient;
import com.thedeveloper.gnext.entity.ChatEntity;
import com.thedeveloper.gnext.entity.MessageEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.ChatMode;
import com.thedeveloper.gnext.enums.MessageType;
import com.thedeveloper.gnext.service.ChatService;
import com.thedeveloper.gnext.service.FilterService;
import com.thedeveloper.gnext.service.MessageService;
import com.thedeveloper.gnext.service.UserService;
import com.thedeveloper.gnext.socket.models.MessageModel;
import com.thedeveloper.gnext.utils.Globals;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
@Slf4j
public class SocketService {
    ChatService chatService;
    UserService userService;
    MessageService messageService;
    FilterService filterService;
    public void sendSocketMessage(SocketIOClient senderClient, MessageEntity message, String room, String uid) {
        for (SocketIOClient client : senderClient.getNamespace().getRoomOperations(room).getClients()) {
            if (!client.getSessionId().equals(senderClient.getSessionId())) {
                client.sendEvent("read_message", message);

            }
        }
        if(uid!=null){
            for(SocketIOClient client : senderClient.getNamespace().getRoomOperations("chats-"+uid).getClients()){
                log.info("Client update! {}",client.getSessionId());
                if (!client.getSessionId().equals(senderClient.getSessionId())) {
                    client.sendEvent("update", message);

                }
            }
        }
    }
    public void saveMessage(SocketIOClient senderClient, MessageModel message) {
        var params = senderClient.getHandshakeData().getUrlParams();
        String room = params.get("room").stream().collect(Collectors.joining());
        String uid = params.get("uid").stream().collect(Collectors.joining());
        if(Globals.allowWord(message.getContent(), filterService)){
            UserEntity user = userService.findUserByUid(uid);
            ChatEntity chat = chatService.findByCityAndName(user.getCity(),room);
            MessageEntity message_ = new MessageEntity();
            message_.setContent(message.getContent());
            message_.setChat(chat);
            message_.setType(MessageType.USER);
            message_.setTime(new Date());
            message_.setUser(user);
            message_.getReaders().add(user);
            messageService.save(message_);

            room = user.getCity().getId()+"_"+room;
            String temp_uid = "";
            if(chat.getMode().equals(ChatMode.PRIVATE)){
                if(!Objects.equals(chat.getMember1().getUid(), uid)){
                    temp_uid = chat.getMember1().getUid();
                }
                if(!Objects.equals(chat.getMember2().getUid(), uid)){
                    temp_uid = chat.getMember2().getUid();
                }
            }
            if(temp_uid.isEmpty()){
               temp_uid = null;
            }
            sendSocketMessage(senderClient, message_, room, temp_uid);
        }
    }
}

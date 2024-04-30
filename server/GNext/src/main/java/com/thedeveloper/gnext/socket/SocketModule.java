package com.thedeveloper.gnext.socket;

import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.ConnectListener;
import com.corundumstudio.socketio.listener.DataListener;
import com.corundumstudio.socketio.listener.DisconnectListener;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.service.UserService;
import com.thedeveloper.gnext.socket.models.MessageModel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.util.stream.Collectors;

@Component
@Slf4j
public class SocketModule {
    private final SocketService socketService;
    private final SocketIOServer server;

    @Autowired
    UserService userService;

    public SocketModule(SocketService socketService, SocketIOServer server) {
        this.socketService = socketService;
        this.server = server;

        server.addConnectListener(onConnected());
        server.addDisconnectListener(onDisconnected());
        server.addEventListener("send_message", MessageModel.class, onChatReceived());
    }
    private DataListener<MessageModel> onChatReceived() {
        return (senderClient, data, ackSender) -> {
            log.info(data.toString());
            socketService.saveMessage(senderClient, data);
        };
    }
    private ConnectListener onConnected() {
        return (client) -> {
            var params = client.getHandshakeData().getUrlParams();
            String room = params.get("room").stream().collect(Collectors.joining());
            String uid = params.get("uid").stream().collect(Collectors.joining());
            UserEntity user;
            if(!uid.equals("0")){
                user  = userService.findUserByUid(uid);
            }else{
                user = new UserEntity();
                user.setName("Manager");
            }
            room= user.getLocation().getCity().getId()+"_"+room;
            client.joinRoom(room);
            if(room.contains("global")){
                client.joinRoom("chats-"+uid);
                log.info("Socket ID[{}] - room[chats-{}] - username [{} {} : {}]  Connected to chat module through", client.getSessionId().toString(), uid, user.getName(), user.getSurname(), user.getPhone());
            }
            log.info("Socket ID[{}] - room[{}] - username [{} {} : {}]  Connected to chat module through", client.getSessionId().toString(), room, user.getName(), user.getSurname(), user.getPhone());
        };
    }
    private DisconnectListener onDisconnected() {
        return client -> {
            var params = client.getHandshakeData().getUrlParams();
            String room = params.get("room").stream().collect(Collectors.joining());
            String uid = params.get("uid").stream().collect(Collectors.joining());
            UserEntity user;
            if(!uid.equals("0")){
                user  = userService.findUserByUid(uid);
            }else{
                user = new UserEntity();
                user.setName("Manager");
            }
            room= user.getLocation().getCity().getId()+"_"+room;
            client.leaveRoom(room);
            if(room.contains("global")){
                client.leaveRoom("chats-"+uid);
                log.info("Socket ID[{}] - room[chats-{}] - username [{} {} : {}]  discnnected to chat module through", client.getSessionId().toString(), uid, user.getName(), user.getSurname(), user.getPhone());
            }
            log.info("Socket ID[{}] - room[{}] - username [{} {} : {}]  discnnected to chat module through", client.getSessionId().toString(), room, user.getName(), user.getSurname(), user.getPhone());
        };
    }
}

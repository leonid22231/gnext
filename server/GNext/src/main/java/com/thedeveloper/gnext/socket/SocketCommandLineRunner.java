package com.thedeveloper.gnext.socket;

import com.corundumstudio.socketio.SocketIOServer;
import com.thedeveloper.gnext.service.ChatService;
import com.thedeveloper.gnext.service.CityService;
import com.thedeveloper.gnext.utils.Globals;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;


@Component
@AllArgsConstructor
@Slf4j
public class SocketCommandLineRunner implements CommandLineRunner {
    ChatService chatService;
    CityService cityService;
    private final SocketIOServer server;
    @Override
    public void run(String... args) throws Exception {
        Globals.initChats(cityService, chatService, log);
        server.start();
    }
}

package com.thedeveloper.gnext.utils;

import com.thedeveloper.gnext.entity.StorisEntity;
import com.thedeveloper.gnext.service.StorisService;
import jakarta.annotation.PostConstruct;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Date;
import java.util.concurrent.TimeUnit;

@Component
@Slf4j
public class StorisUtils {
    @Autowired
    StorisService storisService;

    @PostConstruct
    public void init() throws InterruptedException {
        storiesService();

        log.info("Storis util start");
    }
    void substractionService(){

    }
    void storiesService() throws InterruptedException {
        new Thread(new Runnable() {
            @Override
            public void run() {
                while (true){
                    for(StorisEntity storis : storisService.findAll()){
                        Duration duration = Duration.between(storis.getCreateDate().toInstant(), new Date().toInstant());
                        if(duration.toHours()>=24){
                            storisService.delete(storis);
                        }else{
                            //log.info("Storis {} time in {}:{}", storis.getId(), duration.toHours(), duration.toMinutes());
                        }
                    }
                    try {
                        TimeUnit.SECONDS.sleep(1);
                    } catch (InterruptedException e) {
                        throw new RuntimeException(e);
                    }
                }
            }
        }).start();
    }
}

package com.thedeveloper.gnext.utils;

import com.thedeveloper.gnext.entity.ChatEntity;
import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.FilterEntity;
import com.thedeveloper.gnext.entity.MessageEntity;
import com.thedeveloper.gnext.enums.ChatMode;
import com.thedeveloper.gnext.enums.HistoryContent;
import com.thedeveloper.gnext.service.*;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;

import java.io.File;
import java.nio.file.Path;
import java.time.Duration;
import java.util.*;


@Slf4j
public class Globals {
    public static String codeGenerator(){
        Random random = new Random();
        return  String.format("%04d", random.nextInt(10000));
    }
    public static String renameFile(String filename, ImageService service){
        Path path = service.load(filename);
        File file = new File(String.valueOf(path.toAbsolutePath()));
        if(file.exists()){
            String name = UUID.randomUUID().toString().replace("-", "");
            String name_ = "img_"+name+"."+filename.split("\\.")[1];
            File file_cope = new File(file.getParentFile().getAbsolutePath(), name_);
            System.out.println("File copy to "+file_cope.getAbsolutePath());
            file.renameTo(file_cope);
            return name_;
        }else{
            return null;
        }
    }
    public static String renameDoc(String filename, FileService service){
        Path path = service.load(filename);
        File file = new File(String.valueOf(path.toAbsolutePath()));
        if(file.exists()){
            String name = UUID.randomUUID().toString().replace("-", "");
            String name_ = "file_"+name+"."+filename.split("\\.")[1];
            File file_cope = new File(file.getParentFile().getAbsolutePath(), name_);
            log.info("File copy to "+file_cope.getAbsolutePath());
            file.renameTo(file_cope);
            return name_;
        }else{
            return null;
        }
    }
    public static String renameAudio(String filename, AudioService service){
        Path path = service.load(filename);
        File file = new File(String.valueOf(path.toAbsolutePath()));
        if(file.exists()){
            String name = UUID.randomUUID().toString().replace("-", "");
            String name_ = "audio_"+name+"."+filename.split("\\.")[1];
            File file_cope = new File(file.getParentFile().getAbsolutePath(), name_);
            log.info("File copy to "+file_cope.getAbsolutePath());
            file.renameTo(file_cope);
            return name_;
        }else{
            return null;
        }
    }
    public static String renameFileHistory(String filename,HistoryContent type,StoriesService service){
        Path path = service.load(filename);
        File file = new File(String.valueOf(path.toAbsolutePath()));
        String temp_type = "";
        switch (type){
            case PHOTO -> temp_type="img";
            case VIDEO -> temp_type="video";
        }
        if(file.exists()){
            String name = UUID.randomUUID().toString().replace("-", "");
            String name_ = temp_type+"_"+name+"."+filename.split("\\.")[1];
            File file_cope = new File(file.getParentFile().getAbsolutePath(), name_);
            System.out.println("File copy to "+file_cope.getAbsolutePath());
            file.renameTo(file_cope);
            return name_;
        }else{
            return null;
        }
    }
    public static void filterMessages(MessageService messageService, FilterService filterService){
        List<MessageEntity> messageEntities = messageService.findAll();
        for(MessageEntity message : messageEntities){
            String[] values = message.getContent().replaceAll("^[.,\\s]+", "").split("[.,\\s]+");
            log.info("Words all {}", Arrays.toString(values));
            for(String word: values){
                if(!allowWord(word, filterService)){
                    messageService.delete(message);
                    break;
                }
            }
        }
    }
    public static boolean allowWord(String content, FilterService filterService){
        String[] values = content.replaceAll("^[.,\\s]+", "").split("[.,\\s]+");
        log.info("Words all {}", Arrays.toString(values));
        for(String word : values){
            for(FilterEntity filter : filterService.findAll()){
                if(word.toLowerCase().contains(filter.getWord()) || filter.getWord().contentEquals(word.toLowerCase())){
                    log.info("{} = {}", word, filter.getWord());
                    return false;
                }
            }
        }
        return true;
    }
    public static void initChats(CityService cityService, ChatService chatService, Logger log){
        log.info("Start init chats");
        Date date = new Date();
        String[] globalsChats = {
                "evacuator",
                "razbor",
                "market",
                "global",
                "city",
                "gruz",
                "outcity",
                "spr",
                "sto",
                "gaz",
                "swap",
                "salon"
        };
        for(CityEntity city : cityService.findAll()){
            for(String name : globalsChats){
                if(chatService.findByCityAndName(city,name)==null){
                    ChatEntity chat = new ChatEntity();
                    chat.setMode(ChatMode.GENERAL);
                    chat.setName(name);
                    chat.setCity(city);
                    chatService.save(chat);
                    //log.info("{} {} создан", location.getCity().getName(),name);
                }
//                else{
//                    //log.info("{} {} существует", location.getCity().getName(),name);
//                }
            }
        }
        log.info("End init chats is {} minute", Duration.between(date.toInstant(), new Date().toInstant()).toMinutes());
    }

}

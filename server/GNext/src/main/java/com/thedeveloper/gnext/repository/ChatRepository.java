package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.ChatEntity;
import com.thedeveloper.gnext.entity.LocationEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.ChatMode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatRepository extends JpaRepository<ChatEntity, String> {
    ChatEntity findChatEntityByName(String name);
    ChatEntity findChatEntityByLocationAndName(LocationEntity location, String name);
    ChatEntity findChatEntityById(String id);
    List<ChatEntity> findChatEntitiesByLocationAndMode(LocationEntity location, ChatMode mode);
    ChatEntity findChatEntityByLocationAndMember1AndMember2(LocationEntity location, UserEntity member1, UserEntity member2);
    List<ChatEntity> findChatEntityByLocationAndMember1(LocationEntity location, UserEntity user);
    List<ChatEntity> findChatEntitiesByLocationAndMember2(LocationEntity location, UserEntity user);
}

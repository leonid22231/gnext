package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.ChatEntity;
import com.thedeveloper.gnext.entity.MessageEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MessageRepository extends JpaRepository<MessageEntity, Long> {
    List<MessageEntity> findMessageEntitiesByChatOrderByTimeAsc(ChatEntity chat);
}

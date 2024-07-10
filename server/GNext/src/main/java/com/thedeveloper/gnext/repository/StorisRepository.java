package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.ChatEntity;
import com.thedeveloper.gnext.entity.StorisEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StorisRepository extends JpaRepository<StorisEntity, Long> {
    List<StorisEntity> findStorisEntitiesByChatOrderByCreateDateAsc(ChatEntity chat);
    List<StorisEntity> findStorisEntitiesByUser(UserEntity user);
}

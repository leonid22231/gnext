package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.ChatEntity;
import com.thedeveloper.gnext.entity.CityEntity;
import com.thedeveloper.gnext.entity.CompanyEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.ChatMode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatRepository extends JpaRepository<ChatEntity, String> {
    ChatEntity findChatEntityByName(String name);
    ChatEntity findChatEntityByCityAndName(CityEntity city, String name);
    ChatEntity findChatEntityById(String id);
    List<ChatEntity> findChatEntitiesByCityAndMode(CityEntity city, ChatMode mode);
    ChatEntity findChatEntityByCityAndMember1AndMember2(CityEntity city, UserEntity member1, UserEntity member2);
    ChatEntity findChatEntityByCityAndMember1AndMember2AndCompany(CityEntity city, UserEntity member1, UserEntity member2, CompanyEntity company);
    List<ChatEntity> findChatEntityByCityAndMember1(CityEntity city, UserEntity user);
    List<ChatEntity> findChatEntitiesByCityAndMember2(CityEntity city, UserEntity user);
}

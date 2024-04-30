package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.MessageEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long> {
    UserEntity findUserEntityByPhone(String phone);
    UserEntity findUserEntityByUid(String uid);
    List<UserEntity> searchUserEntitiesByNameContaining(String name);
    List<UserEntity> searchUserEntitiesBySurnameContaining(String surname);
    List<UserEntity> searchUserEntitiesByPhoneContainingIgnoreCase(String phone);
    @Query(
            value = "SELECT * FROM users WHERE DATE_ADD(users.create_date,interval 1 week) < NOW();",
            nativeQuery = true)
    List<UserEntity> findAfterSevenDays();
}

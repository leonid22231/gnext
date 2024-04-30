package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.CodeEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.CodeStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CodeRepository extends JpaRepository<CodeEntity, Long> {
    List<CodeEntity> findCodeEntitiesByUser(UserEntity user);
    List<CodeEntity> findCodeEntitiesByUserAndStatus(UserEntity user, CodeStatus status);
}

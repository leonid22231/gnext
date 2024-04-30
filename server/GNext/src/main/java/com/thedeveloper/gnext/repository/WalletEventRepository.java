package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.entity.WalletEventEntity;
import com.thedeveloper.gnext.enums.WalletEventType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WalletEventRepository extends JpaRepository<WalletEventEntity, Long> {
    List<WalletEventEntity> findWalletEventEntitiesByUser(UserEntity user);
}

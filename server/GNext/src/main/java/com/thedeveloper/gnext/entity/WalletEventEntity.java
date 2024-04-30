package com.thedeveloper.gnext.entity;

import com.thedeveloper.gnext.enums.EventResult;
import com.thedeveloper.gnext.enums.WalletEventType;
import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

@Entity
@Table(name = "wallet_events")
@Data
public class WalletEventEntity {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    Long id;
    @Enumerated(EnumType.STRING)
    WalletEventType type;
    @Enumerated(EnumType.STRING)
    EventResult result;
    @ManyToOne
    @JoinColumn(name = "user", nullable = true, referencedColumnName = "phone")
    UserEntity user;
    double old_sum;
    double sum;
    Date date;

}

package com.thedeveloper.gnext.entity;

import com.thedeveloper.gnext.enums.HistoryContent;
import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

@Entity
@Data
@Table(name = "stories")
public class StorisEntity {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    Long id;
    @Enumerated(EnumType.STRING)
    HistoryContent type;
    String content;
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "chat", nullable = true,referencedColumnName = "id")
    ChatEntity chat;
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user", nullable = true,referencedColumnName = "phone")
    UserEntity user;
    Date createDate;
}

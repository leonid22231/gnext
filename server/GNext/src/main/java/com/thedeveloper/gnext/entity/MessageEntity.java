package com.thedeveloper.gnext.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonView;
import com.thedeveloper.gnext.enums.MessageType;
import com.thedeveloper.gnext.views.UserViews;

import jakarta.persistence.*;
import lombok.Data;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "messages")
@Data
public class MessageEntity {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    Long id;
    String content;
    @Enumerated(EnumType.STRING)
    MessageType type;
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "chat",referencedColumnName = "id")
    @JsonBackReference
    ChatEntity chat;
    @JsonManagedReference
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user",referencedColumnName = "phone")
    UserEntity user;
    Date time;
    @ManyToMany
    List<UserEntity> readers = new ArrayList<>();

}

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
    @JsonView(UserViews.MiniView.class)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    Long id;
    @JsonView(UserViews.MiniView.class)
    String content;
    @JsonView(UserViews.MiniView.class)
    @Enumerated(EnumType.STRING)
    MessageType type;
    @JsonView(UserViews.MiniView.class)
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "chat",referencedColumnName = "id")
    @JsonBackReference
    ChatEntity chat;
    @JsonView(UserViews.MiniView.class)
    @JsonManagedReference
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user",referencedColumnName = "phone")
    UserEntity user;
    @JsonView(UserViews.MiniView.class)
    Date time;
    @JsonView(UserViews.MiniView.class)
    @ManyToMany
    List<UserEntity> readers = new ArrayList<>();

}

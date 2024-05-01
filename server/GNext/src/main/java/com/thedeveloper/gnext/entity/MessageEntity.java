package com.thedeveloper.gnext.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonView;
import com.thedeveloper.gnext.enums.MessageType;
import com.thedeveloper.gnext.utils.Views;

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
    @JsonView(Views.Compact.class)
    Long id;
    @JsonView(Views.Compact.class)
    String content;
    @JsonView(Views.Compact.class)
    @Enumerated(EnumType.STRING)
    MessageType type;
    @JsonView(Views.Large.class)
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "chat",referencedColumnName = "id")
    @JsonBackReference
    ChatEntity chat;
    @JsonView(Views.Compact.class)
    @JsonManagedReference
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user",referencedColumnName = "phone")
    UserEntity user;
    @JsonView(Views.Compact.class)
    Date time;
    @JsonIgnore
    @ManyToMany
    List<UserEntity> readers = new ArrayList<>();
}

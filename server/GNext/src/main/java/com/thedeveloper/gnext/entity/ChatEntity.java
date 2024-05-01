package com.thedeveloper.gnext.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.thedeveloper.gnext.enums.ChatMode;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "chats")
@Data
public class ChatEntity {
    @GeneratedValue(strategy = GenerationType.UUID)
    @Id
    String id;
    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "city", nullable = true,referencedColumnName = "name")
    CityEntity city;
    @Enumerated(EnumType.STRING)
    ChatMode mode;

    String name;
    @ManyToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "member1", nullable = true, referencedColumnName = "phone")
    UserEntity member1;
    @ManyToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "member2", nullable = true, referencedColumnName = "phone")
    UserEntity member2;
    @ManyToOne(fetch = FetchType.EAGER, optional = true)
    CompanyEntity company;
    @Transient
    int unread;
    @JsonManagedReference
    @Transient
    MessageEntity lastMessage;
}

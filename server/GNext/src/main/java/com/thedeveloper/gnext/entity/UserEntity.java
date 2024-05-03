package com.thedeveloper.gnext.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonView;
import com.thedeveloper.gnext.enums.UserRole;
import com.thedeveloper.gnext.utils.Views;

import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

import java.util.Date;

@Entity
@Table(name = "users")
@Data
@ToString
public class UserEntity {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;
    @Enumerated(EnumType.STRING)
    UserRole role;
    @ManyToOne()
    @JoinColumn(name = "city", nullable = true,referencedColumnName = "name")
    CityEntity city;
    String uid;
    @JsonIgnore
    String notifyToken;
    @Column(unique = true)
    String phone;
    @JsonIgnore
    String password;
    String name;
    String number;
    String surname;
    String photo;
    boolean subscription = false;
    double wallet = 0;
    Date createDate;
    Date subStart;
    String telegram;
    String whatsapp;
}

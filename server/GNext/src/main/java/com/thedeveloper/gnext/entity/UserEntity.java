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
    @JsonView(Views.Compact.class)
    private Long id;
    @JsonView(Views.Compact.class)
    @Enumerated(EnumType.STRING)
    UserRole role;
    @ManyToOne()
    @JoinColumn(name = "city", nullable = true,referencedColumnName = "name")
    CityEntity city;
    @JsonView(Views.Compact.class)
    String uid;
    @JsonIgnore
    String notifyToken;
    @JsonView(Views.Large.class)
    @Column(unique = true)
    String phone;
    @JsonIgnore
    String password;
    @JsonView(Views.Compact.class)
    String name;
    @JsonView(Views.Large.class)
    String number;
    @JsonView(Views.Compact.class)
    String surname;
    @JsonView(Views.Compact.class)
    String photo;
    @JsonView(Views.Large.class)
    boolean subscription = false;
    @JsonView(Views.Large.class)
    double wallet = 0;
    @JsonView(Views.Large.class)
    Date createDate;
    @JsonView(Views.Large.class)
    Date subStart;
}

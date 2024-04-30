package com.thedeveloper.gnext.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonView;
import com.thedeveloper.gnext.enums.UserRole;
import com.thedeveloper.gnext.views.UserViews;

import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

import java.util.Date;

@Entity
@Table(name = "users")
@Data
@ToString
public class UserEntity {
    @JsonView(UserViews.MiniView.class)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;
    @Enumerated(EnumType.STRING)
    UserRole role;
    @JsonView(UserViews.FullView.class)
    @ManyToOne()
    @JoinColumn(name = "location", nullable = true,referencedColumnName = "city")
    LocationEntity location;
    @JsonView(UserViews.MiniView.class)
    String uid;
    @JsonIgnore
    String notifyToken;
    @JsonView(UserViews.MiniView.class)
    @Column(unique = true)
    String phone;
    @JsonIgnore
    String password;
    @JsonView(UserViews.MiniView.class)
    String name;
    @JsonView(UserViews.MiniView.class)
    String number;
    @JsonView(UserViews.MiniView.class)
    String surname;
    @JsonView(UserViews.MiniView.class)
    String photo;
    @JsonView(UserViews.MiniView.class)
    boolean subscription = false;
    @JsonView(UserViews.MiniView.class)
    double wallet = 0;
    @JsonView(UserViews.MiniView.class)
    Date createDate;
    @JsonView(UserViews.MiniView.class)
    Date subStart;
}

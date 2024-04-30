package com.thedeveloper.gnext.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.thedeveloper.gnext.enums.UserRole;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.ToString;

import java.util.List;

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
    @JoinColumn(name = "location", nullable = true,referencedColumnName = "city")
    LocationEntity location;

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
}

package com.thedeveloper.gnext.entity;

import com.thedeveloper.gnext.enums.CodeStatus;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Entity
@Table(name = "codes")
@Getter
@Setter
public class CodeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user", referencedColumnName = "phone")
    private UserEntity user;

    @CollectionTable(name = "code", joinColumns = @JoinColumn(name = "id"))
    @Enumerated(EnumType.STRING)
    private CodeStatus status;

    private String code;
    private Date sendDate;
    private Date endDate;
}


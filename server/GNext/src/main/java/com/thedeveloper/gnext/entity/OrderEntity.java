package com.thedeveloper.gnext.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

@Entity
@Table(name = "orders")
@Data
public class OrderEntity {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    Long id;
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "creator", nullable = true, referencedColumnName = "phone")
    UserEntity creator;

    @ManyToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "specialist", nullable = true, referencedColumnName = "phone")
    UserEntity specialist;
    @ManyToOne
    @JoinColumn(name = "city", nullable = true,referencedColumnName = "name")
    CityEntity city;
    @ManyToOne
    @JoinColumn(name = "addressTo", nullable = true,referencedColumnName = "id")
    AddressEntity addressTo;
    @ManyToOne
    @JoinColumn(name = "addressFrom", nullable = true,referencedColumnName = "id")
    AddressEntity addressFrom;
    boolean active = true;
    double price;
    String description;
    boolean customPrice;
    boolean outCity;
    Date startDate;
    Date endDate;
    Date createDate;
    String file;

}

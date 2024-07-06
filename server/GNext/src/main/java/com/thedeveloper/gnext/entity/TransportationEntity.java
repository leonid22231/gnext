package com.thedeveloper.gnext.entity;

import com.thedeveloper.gnext.enums.TransportationCategory;
import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

@Entity
@Data
@Table(name = "transportings")
public class TransportationEntity {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    Long id;
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "creator", nullable = true, referencedColumnName = "phone")
    UserEntity creator;
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
    boolean outCity;
    @Enumerated(EnumType.STRING)
    TransportationCategory category = TransportationCategory.ev;
    double price;
    String description;
    Date date;
    Date createDate;
}

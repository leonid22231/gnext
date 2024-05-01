package com.thedeveloper.gnext.entity;

import com.thedeveloper.gnext.enums.Categories;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "companies")
@Data
public class CompanyEntity {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    Long id;
    String name;
    String phone;
    @ManyToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "manager",referencedColumnName = "phone")
    UserEntity manager;
    @ManyToOne
    AddressEntity address;
    @Enumerated(EnumType.STRING)
    Categories category;
    @ManyToOne
    @JoinColumn(name = "city", nullable = true,referencedColumnName = "name")
    CityEntity city;
    String image;
}

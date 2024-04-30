package com.thedeveloper.gnext.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Table(name = "countries")
@Data
public class CountryEntity {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    Long id;
    @Column(unique = true)
    String name;

    @OneToMany(fetch = FetchType.EAGER)
    List<CityEntity> cities;
}

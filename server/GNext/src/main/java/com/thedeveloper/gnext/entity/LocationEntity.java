package com.thedeveloper.gnext.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "locations")
@Data
public class LocationEntity {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    Long id;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "country", nullable = true,referencedColumnName = "name")
    CountryEntity country;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "city", nullable = true,referencedColumnName = "name")
    CityEntity city;
}

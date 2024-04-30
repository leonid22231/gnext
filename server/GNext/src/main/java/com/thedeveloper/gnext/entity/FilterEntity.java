package com.thedeveloper.gnext.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "filter_word")
@Data
public class FilterEntity {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    Long id;
    String word;
}

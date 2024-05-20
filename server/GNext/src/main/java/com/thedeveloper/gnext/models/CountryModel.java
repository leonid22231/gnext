package com.thedeveloper.gnext.models;

import com.thedeveloper.gnext.entity.CityEntity;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class CountryModel {
    Long id;
    String name;
    List<CityModel> cities = new ArrayList<>();
}

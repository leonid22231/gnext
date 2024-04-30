package com.thedeveloper.gnext.controller.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.thedeveloper.gnext.entity.AddressEntity;
import lombok.Data;

import java.io.Serializable;

@Data
@JsonSerialize
public class AddressModel implements Serializable {
    @JsonProperty("street")
    String street;
    @JsonProperty("house")
    String house;
    @JsonProperty("city")
    String city;

    public AddressModel() {
    }

    public AddressModel(String street, String house, String city) {
        this.street = street;
        this.house = house;
        this.city = city;
    }
    @JsonIgnore
    public AddressEntity toAddressEntity(){
        AddressEntity addressEntity = new AddressEntity();
        addressEntity.setCity(city);
        addressEntity.setHouse(house);
        addressEntity.setStreet(street);
        return addressEntity;
    }
}

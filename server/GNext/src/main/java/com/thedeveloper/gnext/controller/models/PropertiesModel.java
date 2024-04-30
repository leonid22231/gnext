package com.thedeveloper.gnext.controller.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Data;
import org.antlr.v4.runtime.misc.NotNull;

import java.io.Serializable;

@Data
@JsonSerialize
public class PropertiesModel implements  Serializable{
    @JsonProperty("addressTo")
    AddressModel addressTo;
    @JsonProperty("addressFrom")
    AddressModel addressFrom;

    public AddressModel getAddressTo() {
        return addressTo;
    }

    public void setAddressTo(AddressModel addressTo) {
        this.addressTo = addressTo;
    }

    public AddressModel getAddressFrom() {
        return addressFrom;
    }

    public void setAddressFrom(AddressModel addressFrom) {
        this.addressFrom = addressFrom;
    }

    public PropertiesModel(AddressModel addressTo, AddressModel addressFrom) {
        this.addressTo = addressTo;
        this.addressFrom = addressFrom;
    }

    public PropertiesModel() {
    }
}

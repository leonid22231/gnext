package com.thedeveloper.gnext.controller.models;

import lombok.Data;

@Data
public class StatisticModel {
    int userCount;
    int chatCount;
    int messagesCount;
    int countryCount;
    int cityCount;
    int allOrders;
    int activeOrders;
}

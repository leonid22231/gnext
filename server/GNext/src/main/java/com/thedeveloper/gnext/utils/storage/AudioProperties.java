package com.thedeveloper.gnext.utils.storage;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
@Getter
@Setter
@ConfigurationProperties("audio")
public class AudioProperties {
    private String location = "storage";
}
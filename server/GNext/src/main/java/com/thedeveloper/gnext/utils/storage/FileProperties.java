package com.thedeveloper.gnext.utils.storage;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Getter
@Setter
@ConfigurationProperties("files")
public class FileProperties {
    private String location = "storage";

}

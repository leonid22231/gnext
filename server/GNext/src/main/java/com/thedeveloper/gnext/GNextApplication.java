package com.thedeveloper.gnext;

import com.thedeveloper.gnext.config.SocketConfig;
import com.thedeveloper.gnext.utils.storage.*;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
@EnableConfigurationProperties({SocketConfig.class, ImageProperties.class, AudioProperties.class, StoriesProperties.class, FileProperties.class})
public class GNextApplication {

	public static void main(String[] args) {
		SpringApplication.run(GNextApplication.class, args);
	}
	@Bean
	CommandLineRunner init(@Qualifier("imageService") StorageService storageService) {
		return (args) -> {
			storageService.init();
		};}
	@Bean
	CommandLineRunner init1(@Qualifier("storiesService") StorageService storageService) {
		return (args) -> {
			storageService.init();
		};}
	@Bean
	CommandLineRunner init2(@Qualifier("fileService") StorageService storageService) {
		return (args) -> {
			storageService.init();
		};}
	@Bean
	CommandLineRunner init3(@Qualifier("audioService") StorageService storageService) {
		return (args) -> {
			storageService.init();
		};}
}

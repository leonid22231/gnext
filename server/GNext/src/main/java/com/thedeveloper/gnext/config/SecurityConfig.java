package com.thedeveloper.gnext.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity httpSecurity) throws Exception {
        httpSecurity.csrf().disable().authorizeHttpRequests((auth) ->
                auth.requestMatchers(HttpMethod.POST, "api/v1/***").permitAll()
                        .requestMatchers(HttpMethod.GET, "api/v1/***").permitAll().anyRequest().permitAll());

        return httpSecurity.build();
    }
}

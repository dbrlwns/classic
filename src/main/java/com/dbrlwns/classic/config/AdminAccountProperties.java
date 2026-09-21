package com.dbrlwns.classic.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.admin")
public record AdminAccountProperties(String username, String password) {
}

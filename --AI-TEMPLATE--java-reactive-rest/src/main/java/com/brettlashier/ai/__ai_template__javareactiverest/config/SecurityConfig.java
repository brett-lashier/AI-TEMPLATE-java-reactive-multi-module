package com.brettlashier.ai.__ai_template__javareactiverest.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.core.userdetails.MapReactiveUserDetailsService;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.server.SecurityWebFilterChain;

@Configuration
@EnableWebFluxSecurity
public class SecurityConfig {

    private static final String[] ACTUATOR_PATH_MATCHERS = new String[] {
            "/actuator/**",
            "/actuator/health/**",
            "/actuator/info",
            "/swagger-ui/**",
            "/api-docs/**",
            "/"
    };

    private static final String USER_ROLE = "USER";
    private static final String ADMIN_ROLE = "ADMIN";

    //These should not be here like this in production, this is just for demo purposes
    private static final String USERNAME = "admin";
    private static final String PASSWORD = "password";

    @Bean
    public SecurityWebFilterChain springSecurityFilterChain(ServerHttpSecurity http) {
        return http
                .csrf(ServerHttpSecurity.CsrfSpec::disable)
                .authorizeExchange(exchanges -> exchanges
                        .pathMatchers(ACTUATOR_PATH_MATCHERS).permitAll()
                        .anyExchange().authenticated()
                )
                .httpBasic(Customizer.withDefaults())
                .formLogin(ServerHttpSecurity.FormLoginSpec::disable)
                .build();
    }

    @Bean
    public MapReactiveUserDetailsService userDetailsService() {
        UserDetails user = User.builder()
                .username(USERNAME)
                .password(PASSWORD) // {noop} means no password encoding
                .roles(USER_ROLE, ADMIN_ROLE)
                .build();
        return new MapReactiveUserDetailsService(user);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}

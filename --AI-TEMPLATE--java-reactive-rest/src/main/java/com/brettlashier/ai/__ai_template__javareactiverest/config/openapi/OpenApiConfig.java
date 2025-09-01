package com.brettlashier.ai.__ai_template__javareactiverest.config.openapi;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.security.SecurityScheme;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Value("${server.port}")
    private static String SERVER_PORT;

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("AI Template Java API")
                        .version("1.0.0")
                        .description("Template to be used by AI Agents")
                        .contact(new Contact()
                                .name("AI Template")
                                .email("brettlashier@gmail.com"))
                        .license(new License()
                                .name("Example License")
                                .url("https://examplewebsitenotreal/license")))
                .servers(List.of(
                        new Server().url(StringUtils.replace("http://localhost:PORT","PORT",SERVER_PORT)).description("Local Development")
                        //new Server().url("https://api.examplewebsitenotreal.com").description("Production")
                ))
                .components(new Components()
                        .addSecuritySchemes("bearer-jwt", new SecurityScheme()
                                .type(SecurityScheme.Type.HTTP)
                                .scheme("bearer")
                                .bearerFormat("JWT")));
    }
}

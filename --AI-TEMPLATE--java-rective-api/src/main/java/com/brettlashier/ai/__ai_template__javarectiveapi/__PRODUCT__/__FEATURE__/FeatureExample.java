package com.brettlashier.ai.__ai_template__javarectiveapi.__PRODUCT__.__FEATURE__;

import com.brettlashier.ai.__ai_template__javarectivemodel.__PRODUCT__.__FEATURE__.__TRANSPORTTYPE__.FeatureExampleResponse;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import reactor.core.publisher.Mono;

@RequestMapping({"/PRODUCT", "/api/v1/PRODUCT"})
public interface FeatureExample {

    @PostMapping("/FEATURE/SUBFEATURE")
    Mono<FeatureExampleResponse> test(@RequestBody String test);
}

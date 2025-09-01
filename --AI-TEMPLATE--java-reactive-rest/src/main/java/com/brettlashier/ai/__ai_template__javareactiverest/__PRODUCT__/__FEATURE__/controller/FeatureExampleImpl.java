package com.brettlashier.ai.__ai_template__javareactiverest.__PRODUCT__.__FEATURE__.controller;

import com.brettlashier.ai.__ai_template__javareactiverest.__PRODUCT__.__FEATURE__.service.FeatureExampleService;
import com.brettlashier.ai.__ai_template__javarectiveapi.__PRODUCT__.__FEATURE__.FeatureExample;
import com.brettlashier.ai.__ai_template__javarectivemodel.__PRODUCT__.__FEATURE__.__TRANSPORTTYPE__.FeatureExampleResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequiredArgsConstructor
public class FeatureExampleImpl implements FeatureExample {

    private final FeatureExampleService featureExampleService;

    @Override
    public Mono<FeatureExampleResponse> test(String test) {
        return featureExampleService.testServiceCall(test);
    }
}

package com.brettlashier.ai.__ai_template__javareactiverest.__PRODUCT__.__FEATURE__.service;

import com.brettlashier.ai.__ai_template__javareactiverest.__PRODUCT__.__FEATURE__.repository.FeatureExampleRepository;
import com.brettlashier.ai.__ai_template__javarectivemodel.__PRODUCT__.__FEATURE__.__TRANSPORTTYPE__.FeatureExampleResponse;
import com.brettlashier.ai.__ai_template__javarectivemodel.__PRODUCT__.__FEATURE__.jpa.FeatureExampleObj;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
public class FeatureExampleService {

    private FeatureExampleRepository featureExampleRepository;

    public Mono<FeatureExampleResponse> testServiceCall(String test) {
        return featureExampleRepository.save(
                FeatureExampleObj.builder()
                        .build())
                .map(dbResponse -> FeatureExampleResponse
                        .builder()
                        .feature(dbResponse.getFeatureString())
                        .build());
    }
}

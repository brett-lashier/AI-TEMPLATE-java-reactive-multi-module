package com.brettlashier.ai.__ai_template__javareactiverest.__PRODUCT__.__FEATURE__.repository;

import com.brettlashier.ai.__ai_template__javarectivemodel.__PRODUCT__.__FEATURE__.jpa.FeatureExampleObj;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FeatureExampleRepository extends ReactiveCrudRepository<FeatureExampleObj, FeatureExampleObj> {
}

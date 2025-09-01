package com.brettlashier.ai.__ai_template__javarectivemodel.__PRODUCT__.__FEATURE__.jpa;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Getter
@Setter
@Builder
@Table
public class FeatureExampleObj {

    @Id
    @Column("feature_pk")
    private String id;

    @Column("feature_string")
    private String featureString;
}

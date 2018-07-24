package com.dslexample

import groovy.transform.builder.SimpleStrategy
import groovy.transform.builder.Builder
import javaposse.jobdsl.dsl.DslFactory
import javaposse.jobdsl.dsl.Job
import javaposse.jobdsl.dsl.Job
import javaposse.jobdsl.dsl.JobParent


@Builder(builderStrategy = SimpleStrategy, prefix = '')
class TestableCiJobBuilder {
    String environment

    Job build(DslFactory dslFactory) {
        dslFactory.job("test") {
            if (environment == "production") {
                publishers {
                    releaseJiraVersion {
                        projectKey("testKey")
                    }
                }
            }
        }
    }
}

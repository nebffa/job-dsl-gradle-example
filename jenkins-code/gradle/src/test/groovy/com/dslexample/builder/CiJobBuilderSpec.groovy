package com.dslexample.builder

import com.dslexample.TestableCiJobBuilder
import com.dslexample.support.MockJobParent
import javaposse.jobdsl.dsl.Job
import javaposse.jobdsl.dsl.JobParent
import spock.lang.Specification

class CiJobBuilderSpec extends Specification {

    JobParent jobParent = new MockJobParent()
    TestableCiJobBuilder builder

    def setup() {
        builder = new TestableCiJobBuilder()
    }

    void 'test non-production environment environment'() {
        given:
        builder.environment('dev')

        when:
        Job job = builder.build(jobParent)

        then:
        with(job.node) {
            name() == 'project'
            !publishers.'hudson.plugins.jira.JiraReleaseVersionUpdater'
        }
    }

    void 'test production environment'() {
        given:
        builder.environment('production')

        when:
        Job job = builder.build(jobParent)

        then:
        with(job.node) {
            name() == 'project'
            publishers.'hudson.plugins.jira.JiraReleaseVersionUpdater'.jiraProjectKey.text() == 'testKey'
        }
    }
}

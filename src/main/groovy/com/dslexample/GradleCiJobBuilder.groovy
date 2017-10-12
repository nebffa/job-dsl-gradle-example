package com.dslexample

import javaposse.jobdsl.dsl.DslFactory
import javaposse.jobdsl.dsl.Job
import org.kohsuke.github.GitHub

/**
 * Example Class for creating a Gradle build
 */
class GradleCiJobBuilder {

    void build(DslFactory dslFactory) {

        def gh = GitHub.connect(
                'nebffa',
                'f2bd01ea99c14a4726640d43931474164f198106')
        gh.getOrganization('vibrato').listRepositories().each { repo ->
            dslFactory.job(repo.name) {
                scm {
                    gitHub(repo.fullName)
                }
                steps {
                    // ...
                }
            }
        }
    }
}

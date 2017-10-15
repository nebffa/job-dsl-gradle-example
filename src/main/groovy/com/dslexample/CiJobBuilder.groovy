package com.dslexample

import javaposse.jobdsl.dsl.DslFactory
import org.kohsuke.github.GitHub

/**
 * Example Class for creating a Gradle build
 */
class CiJobBuilder {

    void build(DslFactory dslFactory, out) {

        def gh = GitHub.connect(
                'nebffa',
                System.getenv('GITHUB_OAUTH_KEY'))

        dslFactory.folder('vibrato')
        def x = gh.getOrganization('vibrato').listRepositories(100).each { repo ->
            dslFactory.job( "vibrato/${repo.name}") {
                scm {

                }
                steps {
                    // ...
                }
            }
        }
    }
}

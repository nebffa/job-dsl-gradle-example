package com.dslexample

import javaposse.jobdsl.dsl.DslFactory
import org.kohsuke.github.GitHub

class VibratoCiJobBuilder {

    void build(DslFactory dslFactory) {
        def gitHub = GitHub.connect(
                'nebffa',
                System.getenv('GITHUB_OAUTH_KEY'))

        Helpers.out.println('Creating the GitHub jobs...')
        dslFactory.folder('vibrato')
        gitHub.getOrganization('vibrato')
                .listRepositories(100).each { repo ->
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

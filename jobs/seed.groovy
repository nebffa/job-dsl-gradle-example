// If you want, you can define your seed job in the DSL and create it via the REST API.
// See https://github.com/sheehan/job-dsl-gradle-example#rest-api-runner

job('seed') {
    scm {
        git('file:////Users/ben/work/talks/job-dsl-gradle-example', 'master')
    }
    steps {
        gradle 'clean test'
        dsl {
            external 'jobs/**/*Jobs.groovy'
            additionalClasspath 'src/main/groovy'
            removeAction'DELETE'
            removeViewAction 'DELETE'
        }
    }
    publishers {
        archiveJunit('build/test-results/**/*.xml') {
            allowEmptyResults()
        }
    }
}
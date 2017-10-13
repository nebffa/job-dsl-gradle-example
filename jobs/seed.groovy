import com.dslexample.CiJobBuilder
import javaposse.jobdsl.dsl.DslFactory

// If you want, you can define your seed job in the DSL and create it via the REST API.
// See https://github.com/sheehan/job-dsl-gradle-example#rest-api-runner

job('seed') {
    scm {
        git('file:////Users/ben/work/talks/job-dsl-gradle-example', 'master')
    }
    steps {
        gradle 'clean libs test'
        dsl {
            external 'jobs/**/*.groovy'
            additionalClasspath('''src/main/groovy
lib/*.jar''')
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


def jobBuilder = new CiJobBuilder()
jobBuilder.build((DslFactory) this, out)

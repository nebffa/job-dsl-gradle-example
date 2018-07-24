package com.dslexample

import javaposse.jobdsl.dsl.DslFactory

class PipelineJobBuilder {
    void build(DslFactory dslFactory) {
        Helpers.out.println('Creating the pipeline jobs...')

        dslFactory.folder('pipelines')
        [1, 2, 3].each { index ->
            dslFactory.pipelineJob("pipelines/pipeline-${index}") {
                definition {
                    /*
                    * We're going to read a pipeline definition from the workspace
                    * but you can also read a pipeline definition from some other
                    * Git repository using the cpsScm closure
                     */

                    cps {
                        script(Helpers.readFileFromWorkspace('pipeline_definitions/test.groovy'))
                    }
                }
            }
        }
    }
}

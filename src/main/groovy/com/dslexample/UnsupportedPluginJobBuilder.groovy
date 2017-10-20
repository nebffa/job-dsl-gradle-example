package com.dslexample

import javaposse.jobdsl.dsl.DslFactory

class UnsupportedPluginJobBuilder {
    void build(DslFactory dslFactory) {
        dslFactory.with {
            folder('unsupported_plugin_job')

            /*
            * Let's use the
            * https://wiki.jenkins.io/display/JENKINS/Bitbucket+pullrequest+builder+plugin plugin.
            *
            * It's got no entries at https://jenkinsci.github.io/job-dsl-plugin/
            * which means it's not fully supported by the Job DSL plugin.
            */

            job('unsupported_plugin_job/bitbucket') {
                configure { project ->
                    project / 'triggers' / 'bitbucketpullrequestbuilder.bitbucketpullrequestbuilder.BitbucketBuildTrigger' {
                        spec('H * * * *')
                        cron('H * * * *')
                        credentialsId()
                        username(beniscool)
                        password(imfuckingamazing)
                        repositoryOwner()
                        repositoryName()
                        branchesFilter()
                        branchesFilterBySCMIncludes(false)
                        ciKey(jenkins)
                        ciName(Jenkins)
                        ciSkipPhrases()
                        checkDestinationCommit(false)
                        approveIfSuccess(false)
                        cancelOutdatedJobs(false)
                        commentTrigger('test this please')
                    }
                }
            }
        }
    }
}

$cliJarPath = '~/Downloads/jenkins-cli.jar'
Invoke-WebRequest `
    -Uri 'http://localhost:8080/jnlpJars/jenkins-cli.jar' `
    -OutFile $cliJarPath `
    -Verbose


$jobDefinition = @"
<?xml version='1.1' encoding='UTF-8'?>
<project>
    <actions/>
    <description></description>
    <keepDependencies>false</keepDependencies>
    <properties/>
    <scm class="hudson.plugins.git.GitSCM" plugin="git@3.9.1">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
        <url>file:////Users/ben/work/vibrato/job-dsl-gradle-example</url>
        </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
        <hudson.plugins.git.BranchSpec>
        <name>*/master</name>
        </hudson.plugins.git.BranchSpec>
    </branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
    <extensions/>
    </scm>
    <canRoam>true</canRoam>
    <disabled>false</disabled>
    <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
    <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
    <triggers/>
    <concurrentBuild>false</concurrentBuild>
    <builders>
    <hudson.plugins.gradle.Gradle plugin="gradle@1.29">
        <switches></switches>
        <tasks>libs</tasks>
        <rootBuildScriptDir></rootBuildScriptDir>
        <buildFile></buildFile>
        <gradleName>(Default)</gradleName>
        <useWrapper>true</useWrapper>
        <makeExecutable>false</makeExecutable>
        <useWorkspaceAsHome>false</useWorkspaceAsHome>
        <wrapperLocation></wrapperLocation>
        <passAllAsSystemProperties>false</passAllAsSystemProperties>
        <projectProperties></projectProperties>
        <passAllAsProjectProperties>false</passAllAsProjectProperties>
    </hudson.plugins.gradle.Gradle>
    <javaposse.jobdsl.plugin.ExecuteDslScripts plugin="job-dsl@1.70">
        <targets>jobs/*.groovy</targets>
        <usingScriptText>false</usingScriptText>
        <sandbox>false</sandbox>
        <ignoreExisting>false</ignoreExisting>
        <ignoreMissingFiles>false</ignoreMissingFiles>
        <failOnMissingPlugin>true</failOnMissingPlugin>
        <unstableOnDeprecation>false</unstableOnDeprecation>
        <removedJobAction>DELETE</removedJobAction>
        <removedViewAction>DELETE</removedViewAction>
        <removedConfigFilesAction>DELETE</removedConfigFilesAction>
        <lookupStrategy>JENKINS_ROOT</lookupStrategy>
        <additionalClasspath>src/main/groovy
lib/*.jar</additionalClasspath>
    </javaposse.jobdsl.plugin.ExecuteDslScripts>
    </builders>
    <publishers/>
    <buildWrappers/>
</project>
"@

$jobDefinition | java -jar $cliJarPath `
    -s 'http://localhost:8080' `
    -auth 'admin:admin' `
    create-job 'seed_job'
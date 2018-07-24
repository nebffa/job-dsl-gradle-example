$ErrorActionPreference = 'Stop'


$jenkinsPath = "~/.jenkins"
Remove-Item -Recurse -Force $jenkinsPath -ErrorAction SilentlyContinue

$initScript = @"
#!groovy

import jenkins.model.*
import hudson.security.*
import jenkins.install.*
import java.util.logging.Logger

def instance = Jenkins.getInstance()

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

println "--> creating local user 'admin'"

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin','admin')
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)

def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()
def initialized = false
def logger = Logger.getLogger("")
def pluginParameter="job-dsl git github gradle cloudbees-folder workflow-aggregator"
def plugins = pluginParameter.split()
logger.info("" + plugins)
plugins.each {
  logger.info("Checking " + it)
  if (!pm.getPlugin(it)) {
    logger.info("Looking UpdateCenter for " + it)
    if (!initialized) {
      uc.updateAllSites()
      initialized = true
    }
    def plugin = uc.getPlugin(it)
    if (plugin) {
      logger.info("Installing " + it)
    	def installFuture = plugin.deploy()
      while(!installFuture.isDone()) {
        logger.info("Waiting for plugin install: " + it)
        sleep(3000)
      }
      installed = true
    }
  }
}

logger.info("Plugins installed, initializing a restart!")
instance.save()
instance.restart()
"@

$securityScript = @"
import javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration
import jenkins.model.GlobalConfiguration
GlobalConfiguration.all().get(GlobalJobDslSecurityConfiguration.class).useScriptSecurity=false
"@



New-Item -ItemType Directory -Path "~/.jenkins/init.groovy.d" -ErrorAction SilentlyContinue

$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False

$filePath = Join-Path (Resolve-Path "~/.jenkins/init.groovy.d") "init.groovy"
[System.IO.File]::WriteAllLines($filePath, $initScript, $Utf8NoBomEncoding)

$filePath = Join-Path (Resolve-Path "~/.jenkins/init.groovy.d") "security.groovy"
[System.IO.File]::WriteAllLines($filePath, $securityScript, $Utf8NoBomEncoding)

$env:JAVA_OPTS = '-Djenkins.install.runSetupWizard=false'

# TODO make this portable
#!/bin/bash
$env:JAVA_HOME = (/usr/libexec/java_home --version 1.8)
$jenkinsWarPath = '/usr/local/Cellar/jenkins/2.130/libexec/jenkins.war'

java '-Djenkins.install.runSetupWizard=false' -jar $jenkinsWarPath

# open "/Applications/Google Chrome.app" 'http://localhost:8080'


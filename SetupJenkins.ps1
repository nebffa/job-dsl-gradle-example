$ErrorActionPreference = 'Stop'


$jenkinsPath = "~/.jenkins"
Remove-Item -Recurse -Force $jenkinsPath -ErrorAction SilentlyContinue

$initScript = @"
#!groovy

import jenkins.model.*
import hudson.security.*
import jenkins.install.*;

def instance = Jenkins.getInstance()

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

println "--> creating local user 'admin'"

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin','admin')
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
"@


New-Item -ItemType Directory -Path "~/.jenkins/init.groovy.d" -ErrorAction SilentlyContinue

$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
$filePath = Join-Path (Resolve-Path "~/.jenkins/init.groovy.d") "admin.groovy"
[System.IO.File]::WriteAllLines($filePath, $initScript, $Utf8NoBomEncoding)

$env:JAVA_OPTS = '-Djenkins.install.runSetupWizard=false'

# TODO make this portable
#!/bin/bash
$env:JAVA_HOME = (/usr/libexec/java_home --version 1.8)
$jenkinsWarPath = '/usr/local/Cellar/jenkins/2.130/libexec/jenkins.war'

java '-Djenkins.install.runSetupWizard=false' -jar $jenkinsWarPath

# open "/Applications/Google Chrome.app" 'http://localhost:8080'

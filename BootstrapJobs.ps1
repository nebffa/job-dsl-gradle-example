$cliJarPath = '~/Downloads/jenkins-cli.jar'
Invoke-WebRequest `
    -Uri 'http://localhost:8080/jnlpJars/jenkins-cli.jar' `
    -OutFile $cliJarPath `
    -Verbose

java -jar $cliJarPath `
    -s 'http://localhost:8080' `
    -auth 'admin:admin' `
    -create-job
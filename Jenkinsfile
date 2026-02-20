pipeline {
    agent any
    
    options {
        timestamps() // Muestra la hora para detectar cuellos de botella
    }
    
    tools {
        // Asegúrate de que en 'Manage Jenkins -> Tools' tu Maven se llame 'maven'
        maven 'maven' 
    }

    stages {
        stage('Checkout project') {
            steps {
                sh "git config --global http.sslVerify false"
                // Usando tu repositorio personal
                git branch: "master", url: "https://github.com/djbubble/maven-simple-prueba.git"
            }
        }

        stage('Build & Test') {
            steps {
                // Compila y ejecuta tests unitarios
                sh "mvn clean install"
                // Recoge los resultados de los tests
                junit '**/target/surefire-reports/*.xml'
            }
        }

        stage('Mutation Test') {
            steps {
                // Ejecuta Pitest para verificar la calidad de tus tests
                sh "mvn org.pitest:pitest-maven:mutationCoverage"
            }
        }

        stage('SonarQube analysis') {
            steps {
                withSonarQubeEnv('SonarQube USAL') {
                    sh "mvn sonar:sonar -Dsonar.sourceEncoding=UTF-8"
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Deploy to Nexus') {
            steps {
                // Usamos el ID del settings.xml que creaste en 'Managed Files'
                // Cambia 'my-settings-id' por el ID real que te dio Jenkins
                configFileProvider([configFile(fileId: 'tu-id-settings', variable: 'MAVEN_SETTINGS')]) {
                    sh """
                    mvn deploy:deploy-file -s $MAVEN_SETTINGS \
                    -Dfile=target/maven-simple-1.0-SNAPSHOT.jar \
                    -DrepositoryId=mi-repo-binarios \
                    -Durl=http://host.docker.internal:8081/repository/mi-repo-binarios/ \
                    -DgroupId=com.mi.prueba \
                    -DartifactId=maven-simple-prueba \
                    -Dversion=1.0.0 \
                    -Dpackaging=jar
                    """
                }
            }
        }
    }
}

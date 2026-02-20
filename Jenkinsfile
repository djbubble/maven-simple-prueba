pipeline {
    agent any
    
    options {
        timestamps() 
    }
    
    tools {
        // Asegúrate de que en Manage Jenkins -> Tools el nombre sea 'maven'
        maven 'maven' 
    }

    stages {
        stage('Checkout project') {
            steps {
                sh "git config --global http.sslVerify false"
                git branch: "master", url: "https://github.com/djbubble/maven-simple-prueba.git"
            }
        }

        stage('Build & Test') {
            steps {
                sh "mvn clean install"
                // Recopila informes de test unitarios
                junit '**/target/surefire-reports/*.xml'
            }
        }

        stage('Mutation Test') {
            steps {
                // Ejecutamos Pitest. returnStatus evita que el job falle si no matamos a todos los mutantes
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
                // AQUÍ USAMOS TU ID DE LA IMAGEN
                configFileProvider([configFile(fileId: 'b3385001-6523-43f3-bc63-8c75e791af1c', variable: 'MAVEN_SETTINGS')]) {
                    sh """
                    mvn deploy:deploy-file -s $MAVEN_SETTINGS \
                    -Dfile=target/maven-simple-0.0.1-SNAPSHOT.jar \
                    -DrepositoryId=mi-repo-binarios \
                    -Durl=http://host.docker.internal:8081/repository/mi-repo-binarios/ \
                    -DgroupId=com.djbubble \
                    -DartifactId=maven-simple-prueba \
                    -Dversion=1.0.0 \
                    -Dpackaging=jar
                    """
                }
            }
        }
    }
}

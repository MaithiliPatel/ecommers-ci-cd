pipeline {
    agent { label 'Slave1' }

    tools {
        maven "MAVEN"
    }

    stages{

        /* ------------------------------------------------------
           1. CHECKOUT SOURCE CODE
        ------------------------------------------------------ */
        stage('SCM Checkout') {
            steps {
                git 'https://github.com/MaithiliPatel/ecommers-ci-cd.git'
            }
        }

        /* ------------------------------------------------------
           2. BUILD JAR USING MAVEN
        ------------------------------------------------------ */
        stage('Maven Build') {
            steps {
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }
        }
    }
}

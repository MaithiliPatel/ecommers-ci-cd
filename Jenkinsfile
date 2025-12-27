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
                      git url: 'https://github.com/MaithiliPatel/ecommers-ci-cd.git',
                      branch: 'main',
                      credentialsId: 'ecommerce-token'
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
        /* ------------------------------------------------------
           3. SONARCLOUD SCAN
        ------------------------------------------------------ */
		stage('SonarCloud Scan') {
			steps {
				withSonarQubeEnv('sonarcloud') {
				  sh 'mvn sonar:sonar'
				}
			}
		}
		
    }
}

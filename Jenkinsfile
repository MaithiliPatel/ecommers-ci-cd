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

		/* ------------------------------------------------------
           4. COPY JAR TO DOCKER & CREATE DOCKER IMAGE
        ------------------------------------------------------ */
        stage('Docker Image Build') {
            steps {
               sh 'docker version'
				sh "docker build -t maithili28/ecommerce:${BUILD_NUMBER} ."
				sh 'docker image list'
            }
        }
		
        /* ------------------------------------------------------
           5. LOGIN TO DOCKERHUB
        ------------------------------------------------------ */
        stage('Login to DockerHub') {
             steps {
              withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
   			 sh '''
     			 echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
   			 '''
				}
            }
		}
        
		/* ------------------------------------------------------
           6. APPROVED - PUSH DOCKER IMAGE TO DOCKER HUB
        ------------------------------------------------------ */
        stage('Approve - Push Image to Docker Hub'){
            steps{
                
                //----------------send an approval prompt-------------
                script {
                   env.APPROVED_DEPLOY = input message: 'User input required Choose "yes" | "Abort"'
                       }
                //-----------------end approval prompt------------
            }
        }

        /* ------------------------------------------------------
           7. PUSH DOCKER IMAGE TO DOCKER HUB
        ------------------------------------------------------ */
        stage('Push Docker Image to Docker Hub') {
            steps {
               sh "docker push maithili28/ecommerce:${BUILD_NUMBER}"
            }
        }

		/* ------------------------------------------------------
           8. APPROVED DEPLOYMENT TO KUBERNETE CLUSTER
        ------------------------------------------------------ */
        stage('Approve - Deployment to Kubernete Cluster') {
            steps {
                
				//----------------send an approval prompt-------------
                script {
                   env.APPROVED_DEPLOY = input message: 'User input required Choose "yes" | "Abort"'
                       }
                //-----------------end approval prompt------------
            }
        }

       /* ------------------------------------------------------
           9. DEPLOY TO KUBERNETS CLUSTER
        ------------------------------------------------------ */
		stage('Deploy to Kubernetes Cluster') {
    		steps {
       			 sshPublisher(publishers: [
            		sshPublisherDesc(
                		configName: 'kube-master',
               				 transfers: [
                    			sshTransfer(
				                        execCommand: """
                        				# 1️⃣ Ensure deployment & service exist (safe to run)
                        				echo "🏗 Applying Kubernetes Deployment & Service"
										kubectl apply -f k8sdeploy.yaml

                       				    # 2️⃣ Update image with latest build
										echo "🔄 Updating image to latest build"
                        				kubectl set image deployment/ecom-deploy \
                        				ecom-mvn-container=maithili28/ecommerce:${BUILD_NUMBER}
									    
										echo "🐳 Current Pods:"
              							kubectl get pods

                        				# 3️⃣ Wait for rollout to complete
										echo "Wait for rollout to complete"
                        				kubectl rollout status deployment/ecom-deploy
				                        """

										 echo "✅ Deployment Successful"
                    					)
                				]	
            				)
        			]
				)
    		}
		}
			
        /* ------------------------------------------------------
           10. DEPLOY TO KUBERNETS CLUSTER
        ------------------------------------------------------ */
		stage('Docker Cleanup (Keep Latest Build)') {
			steps {
				sh '''
					echo "Keeping image: maithili28/ecommerce:${BUILD_NUMBER}"
					docker images maithili28/ecommerce --format "{{.Tag}}" \
					| grep -v "^${BUILD_NUMBER}$" \
					| xargs -r -I {} docker rmi maithili28/ecommerce:{}
				'''
			}
		}
    }
}




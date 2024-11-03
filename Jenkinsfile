pipeline {
    agent any

    parameters {
        string(name: 'IMAGE_TAG', description: 'Enter the image tag')
        string(name: 'APP_NAME', description: 'Enter the APP_NAME')
    }
    environment {
        GIT_REPO = "https://github.com/aakkiiff/um_config.git" 
        GIT_CREDENTIAL_ID = "github"
    }

    stages{

        stage('CLEANUP WORKSPACE'){
            steps{
                script{
                    cleanWs()
                }
            }
        }

        stage("CHECKOUT GIT REPO"){
            steps{
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage("UPDATE K8S DEPLOYMENT FILES AND PUSH TO THE GIT REPO"){
            steps{

                sh 'cat ./k8s-manifests/deployment.yaml'
                sh "sed -i 's/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g' ./k8s-manifests/deployment.yaml"
                sh 'cat ./k8s-manifests/deployment.yaml'

                sh 'git config --global user.email jackakif@gmail.com'
                sh 'git config --global user.name aakkiiff'
                sh 'git add ./k8s-manifests/deployment.yaml'
                sh "git commit -m 'Updated deployment files to ${IMAGE_TAG}'"

                withCredentials([usernamePassword(credentialsId: env.GIT_CREDENTIAL_ID, passwordVariable: 'pass', usernameVariable: 'uname')]) {
                    sh 'git push https://$uname:$pass@github.com/aakkiiff/demo_config.git main'
                }
            }
        }
    }
}
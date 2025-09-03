pipeline {
	agent any
	tools {
		maven 	"firstmaven"
		jdk	"firstjdk" 
	}
	environment{
		registry='kgpk/tomcat'
		registryCreds='docker'

	}
	stages {
		stage('build the fucking maven'){
			steps{
				sh 'mvn install -DskipTests'
			} 
			post {
				success {
					echo "Now archiving the fucking build"
					archiveArtifacts artifacts: '**/target/*.war'
				}
			}
		}
		stage('test the fucking build'){
			steps{
				sh 'mvn test'
			}
		}
		stage('checkstyle analysis'){
			steps{
				sh 'mvn checkstyle:checkstyle'
			}
		}
		stage('sonarqube scanner analysis'){
			environment {
				scannerHome = tool 'firstsonar'
			}
			steps{
				withSonarQubeEnv('firstsonarconfig'){
				sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
				-Dsonar.projectName=vprofile \
				-Dsonar.projectVersion=1.0 \
				-Dsonar.sources=src/ \
				-Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
				-Dsonar.junit.reportsPath=target/surefire-reports/ \
				-Dsonar.jacoco.reportsPath=target/jacoco.exec \
				-Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
				}
			}
		}
		stage('get data from sonarqube for quality-gates'){
			steps {
				timeout(time:1,unit: 'HOURS'){
					waitForQualityGate abortPipeline: true
				}
			}
		}
		stage('Build Docker images'){
			steps{
				script{
					dockerImage=docker.build registry + ":V$BUILD_NUMBER"
				}
			}
		}
		stage('upload to dockerhub'){
			steps{
				script{
					docker.withRegistry('',registryCreds){
						dockerImage.push("V$BUILD_NUMBER")
						dockerImage.push("latest")
					}
				}
			}
		}
		stage('remove the images from jenkins'){
			steps{
				sh "docker rmi $registry:V$BUILD_NUMBER"
			}
		}
		stage('kubernetes deploy'){
			agent { label: 'KOPS'}
			steps{
				sh "helm upgrade --install --force vprofile-stack helm/vprocharts --set appimage=${registry}:V${BUILD_NUMBER} -n production"
			}
		}
	}
}

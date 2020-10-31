// Variables
def git_app_source = 'git@github.com:MNT-Lab/build-t00ls.git'
def git_credentials = 'github-ssh-key'
def maven = 'maven3.6.3'
def sonar_scanner = 'sq_scanner4.5'
def sonarqubeenv = 'sonarqube-devops-lab'
def nexus_url = 'nexus.k8s.imelnik.playpit.by'
def nexus_credentials = 'nexus'
def nexus_repository = 'jenkins_artifacts'
def docker = 'docker-tool'
def docker_registry = 'nexus-registry.k8s.imelnik.playpit.by'
def maven_global_settings = 'maven-settings'
def git_kubernetes_resources = 'git@github.com:obstaclex/helloworld-app.git'
def kubernetes_namespace = 'namespace.yml'
def kubernetes_app = 'helloworld-imelnik.yml'
env.student = 'imelnik'
env.workdir = 'helloworld-project/helloworld-ws'

// Try catch stage block
def mystage(String stageName, Closure body) {
    stage (stageName) {
        try {
            body()
        }
        catch (err) {
            def now = new Date()
            env.TIMESTAMP = now.format('HH:mm:ss  dd.MM.yy', TimeZone.getTimeZone('UTC')).toString()
            env.GLOBAL_STAGE_NAME = stageName
            wrap([$class: 'BuildUser']) {
                jobUserEmail = "${BUILD_USER_EMAIL}"
            }
            emailext (
                subject: "FAILED: Job:${env.JOB_NAME}, BUILD_NUMBER:${env.BUILD_NUMBER}",
                body: """<p>FAILED: Job:${env.JOB_NAME}, BUILD_NUMBER:${env.BUILD_NUMBER}</p>
                    <p>Check console output at ${env.BUILD_URL}</p>
                    <p>Failed stage: ${GLOBAL_STAGE_NAME}</p>
                    <p>Reason: ${err}</p>
                    <p>Timestamp (UTC): ${TIMESTAMP}</p>""",
                to: "${jobUserEmail}",
                mimeType: 'text/html')
            throw err
        }
    }
}

// Upload to nexus
def nexus3upload(String artifactname, String nexus, String credentials, String repository) {
    sh "tar -zcvf ${artifactname} ${workdir}/target/helloworld-ws.war Jenkinsfile output.txt"
    nexusArtifactUploader artifacts: [[
            artifactId: pom.artifactId,
            classifier: '',
            file: "${artifactname}",
            type: 'tar.gz']],
            credentialsId: "${credentials}",
            groupId: pom.parent.groupId,
            nexusUrl: "${nexus}",
            nexusVersion: 'nexus3',
            protocol: 'https',
            repository: "${repository}",
            version: "$pom.parent.version-${BUILD_NUMBER}"
}

// Main
node('k8s-jenkins-slave') {
        mystage('''Preparation
        (Checking out)
        ''') {
        def scmVars = checkout([
            $class: 'GitSCM',
            branches: [[name: student]],
            userRemoteConfigs: [[credentialsId: git_credentials, url: git_app_source]]
        ])
        env.GIT_COMMIT = scmVars.GIT_COMMIT
        env.GIT_BRANCH = scmVars.GIT_BRANCH
            wrap([$class: 'BuildUser']) {
                sh '''sed -i "/Build/ s/$/ ${BUILD_NUMBER}/" ${workdir}/src/main/webapp/index.html
                sed -i "/SHA/ s/$/ ${GIT_COMMIT}/" ${workdir}/src/main/webapp/index.html
                sed -i "/Username/ s/$/ ${BUILD_USER}/" ${workdir}/src/main/webapp/index.html
                envsubst '${GIT_COMMIT}' < ${workdir}/script.tpl > ${workdir}/check.sh
                chmod +x ${workdir}/check.sh'''
            }
        }
        mystage('Build') {
            withMaven(globalMavenSettingsConfig: maven_global_settings, maven: maven, options: [
            artifactsPublisher(disabled: true)]) {
                sh "mvn clean package -f ${workdir}/pom.xml -DskipTests"
            }
        }
        mystage('Sonar scan') {
            def scannerHome = tool sonar_scanner
            withSonarQubeEnv(sonarqubeenv) {
                sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=module10 \
                -Dsonar.projectName=module10 \
                -Dsonar.sources=${workdir} \
                -Dsonar.java.binaries=${workdir}/target"
            }
        }
        def tests = ['pre-integration-test', 'integration-test', 'post-integration-test']
        mystage('Testing') {
            def stages = [:]
            for (i in tests) {
            def test_name = "$i"
            stages[i] = {
                stage(i) {
                        withMaven(globalMavenSettingsConfig: maven_global_settings, maven: maven) {
                            sh "echo mvn clean -f ${workdir}/pom.xml ${test_name}"
                        }
                }
            }
            }
            parallel stages
        }
        mystage('Triggering job and fetching artefact after finishing') {
            build job: "MNTLAB-${student}-child1-build-job",
            parameters: [[$class: 'StringParameterValue', name: 'BRANCH_NAME', value: student]]
            copyArtifacts(
            filter: '*',
            projectName: "MNTLAB-${student}-child1-build-job")
        }
        mystage('Packaging and Publishing results') {
            // Read POM xml file using 'readMavenPom' step , this step 'readMavenPom' is included in: https://plugins.jenkins.io/pipeline-utility-steps
            pom = readMavenPom file: "${workdir}/pom.xml"
            nexus3upload( "pipeline-${student}-${BUILD_NUMBER}.tar.gz", nexus_url, nexus_credentials, nexus_repository)
            withDockerRegistry(credentialsId: nexus_credentials, toolName: docker, url: "https://${docker_registry}") {
                sh """docker build -t ${docker_registry}/helloworld-${student}:${BUILD_NUMBER} ./${workdir}
                docker push ${docker_registry}/helloworld-${student}:${BUILD_NUMBER}
                docker rmi ${docker_registry}/helloworld-${student}:${BUILD_NUMBER}"""
            }
        }
        mystage('Asking for manual approval') {
            timeout(time: 10, unit: 'MINUTES')  {
                input 'Keep going?'
            }
        }
        mystage('Deployment') {
            checkout([
            $class: 'GitSCM',
            branches: [[name: '*/main']],
            userRemoteConfigs: [[credentialsId: git_credentials, url: git_kubernetes_resources]]
        ])
            withCredentials([usernamePassword(credentialsId: nexus_credentials,
            passwordVariable: 'docker_registry_password',
            usernameVariable: 'docker_registry_username')
            ]) {
                sh "cat ${kubernetes_namespace} | envsubst | kubectl apply -f -"
                sh """set +e
                    kubectl delete secret regcred -n ${student};
                    kubectl create secret docker-registry regcred --docker-server=${docker_registry} --docker-username=${docker_registry_username} \
                    --docker-password=${docker_registry_password} -n ${student}"""
                sh "cat ${kubernetes_app} | envsubst | kubectl apply -f -"
            }
        }
        mystage('Sending status') {
            def now = new Date()
            env.TIMESTAMP = now.format('HH:mm:ss  dd.MM.yy', TimeZone.getTimeZone('UTC')).toString()
            wrap([$class: 'BuildUser']) {
                jobUserEmail = "${BUILD_USER_EMAIL}"
            }
            emailext (
                subject: "SUCCESS: Job:${env.JOB_NAME}, BUILD_NUMBER:${env.BUILD_NUMBER}",
                body: """ <p>SUCCESS: Job:${env.JOB_NAME}, BUILD_NUMBER:${env.BUILD_NUMBER} </p>
                    <p>Check console output at ${env.BUILD_URL}</p>
                    <p>Timestamp (UTC): ${TIMESTAMP}</p>""",
                to: "${jobUserEmail}",
                mimeType: 'text/html')
        }
}

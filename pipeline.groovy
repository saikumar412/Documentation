node{
  stage('Scm checkout'){
    git credentialsId:'a4334-akdf2323-kjdsfj224875', url:'ssh://test.git', branch:'master'
  }
  stage('Build docker Image') {
    dir('server') {
      sh'docker build . -t  test'
    }
  }
  stage('Tagging and Pushing') {
    withCredentials([string(credentialsId:'n_ip', variable:'n_ip'), string(credentialsId:'n_un', variable:'n_un'), string(credentialsId:'n_pw', variable:'n_pw')]) {
      GIT_SHORT_COMMIT=sh(returnStdout:true, script:"git log -n 1 --pretty=format:'%h'").trim()
      HELM_LIST_REVISION=sh(returnStdout:true, script:"helm history  test-helm | awk '{ REVISION =\$1 }; END { print REVISION }'").trim()

      def TAG=HELM_LIST_REVISION+'-'+GIT_SHORT_COMMIT+'-'+BUILD_NUMBER;
      sh '''echo TAG:'''+TAG+''' '''
      sh '''docker tag test nexus.docker.repo:8081/test:'''+TAG+''' '''
      sh 'docker tag test nexus.docker.repo:8081/test:stable'
      sh 'docker push nexus.docker.repo:8081/test:stable'
      sh '''docker push nexus.docker.repo:8081/test:'''+TAG+''' '''
    }
  }
   stage('Deploy') {
    //sh 'echo ${BUILD_NUMBER}'
    def TAG=HELM_LIST_REVISION+'-'+GIT_SHORT_COMMIT+'-'+BUILD_NUMBER;
    sh '''helm upgrade --set image.tag='''+TAG+''' test-helm ./test-helm'''
  }
  stage('Clean Up') {
    def TAG=HELM_LIST_REVISION+'-'+GIT_SHORT_COMMIT+'-'+BUILD_NUMBER;
    sh '''docker rmi -f nexus.docker.repo:8081/test:'''+TAG+''' '''
    sh 'docker rmi -f nexus.docker.repo:8081/test:stable'
    sh 'docker rmi -f test'
  }
} 

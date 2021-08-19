FROM jenkins/jenkins:lts-alpine

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
 
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY jenkins-user /run/secrets/jenkins-user
COPY jenkins-pass /run/secrets/jenkins-pass

RUN   /usr/local/bin/install-plugins.sh workflow-job &&\
      /usr/local/bin/install-plugins.sh workflow-aggregator &&\
      /usr/local/bin/install-plugins.sh credentials-binding &&\
      /usr/local/bin/install-plugins.sh configuration-as-code &&\
      /usr/local/bin/install-plugins.sh amazon-ecs &&\
      /usr/local/bin/install-plugins.sh pipeline-aws &&\
      /usr/local/bin/install-plugins.sh git





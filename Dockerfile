# from 17.06
# ARG BASE_VERSION
# FROM cspd01.csp.comlineag.cl.local:5000/csp/jenkins-slave-base:${BASE_VERSION}
FROM cspd01.csp.comlineag.cl.local:5000/csp/jenkins-slave-base:1.3.0

USER ${JENKINS_USER}

ARG JAVA_CANDIDATE="^8\\..*-oracle"

RUN sdk list java

RUN echo "export JAVA_VERSION=$(sdk list java | tr ' ' '\n' | grep "$JAVA_CANDIDATE")" >> ~/.profile

RUN cat ~/.profile | grep JAVA_VERSION

# install java
RUN echo y | sdk install java $JAVA_VERSION && \
	sdk flush broadcast && sdk flush archives && sdk flush temp

# install latest maven
RUN sdk install maven && \
	sdk flush broadcast && sdk flush archives && sdk flush temp

# install latest gradle
ENV GRADLE_USER_HOME="$HOME/.gradle"

RUN sdk install gradle && \
	sdk flush broadcast && sdk flush archives && sdk flush temp

# restore default user for sshd
USER root
# add jenkins user to docker group
RUN usermod -aG docker ${JENKINS_USER}


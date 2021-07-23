FROM openjdk:16

RUN microdnf install wget unzip 

## gradle
### install gradle
RUN wget https://services.gradle.org/distributions/gradle-7.1-bin.zip -P /tmp
RUN cd /tmp && unzip gradle-7.1-bin.zip
RUN mkdir -p /opt/gradle /home/springweb
RUN mv /tmp/gradle-7.1 /opt/gradle/

ENV GRADLE_HOME /opt/gradle/gradle-7.1
ENV PATH ${GRADLE_HOME}/bin:${PATH}

#COPY gradle.sh /etc/profile.d/gradle.sh
#RUN source /etc/profile.d/gradle.sh

#VOLUME /springweb
#VOLUME ["/springweb", "springweb"]

COPY docker/start-springweb.sh /home/
RUN chmod 700 /home/start-springweb.sh

#CMD ["/bin/bash"]
CMD ["/home/start-springweb.sh"]

FROM openjdk:16

RUN mkdir -p /home/springweb

COPY docker/start-springweb.sh /home/
RUN chmod 700 /home/start-springweb.sh

COPY springweb/build/libs/*.war /home/springweb/

EXPOSE 8080

CMD ["/home/start-springweb.sh"]

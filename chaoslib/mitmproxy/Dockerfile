FROM mitmproxy/mitmproxy:latest

RUN mkdir test
WORKDIR /home/$USER/test
COPY ./script.py .


EXPOSE 80:80
EXPOSE 8080:8080

ENTRYPOINT ["/usr/bin/mitmdump", "-s", "./script.py"]

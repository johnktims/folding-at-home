FROM debian:stable-slim
LABEL maintainer="john.k.tims@gmail.com"

ENV FAH_VERSION_MINOR=7.5.1
ENV FAH_VERSION_MAJOR=7.5

ENV DEBIAN_FRONTEND=noninteractive

RUN groupadd -g 9999 folder && \
    useradd -r -b /home -u 9999 -g folder folder

RUN mkdir /home/folder && chown folder:folder /home/folder && chmod 700 /home/folder

RUN apt-get update && apt-get install --no-install-recommends -y \
        curl adduser bzip2 ca-certificates &&\
        curl -o /tmp/fah.deb https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v${FAH_VERSION_MAJOR}/fahclient_${FAH_VERSION_MINOR}_amd64.deb &&\
        mkdir -p /etc/fahclient/ &&\
        touch /etc/fahclient/config.xml &&\
        dpkg --install /tmp/fah.deb &&\
        apt-get remove -y curl &&\
        apt-get autoremove -y &&\
        rm --recursive --verbose --force /tmp/* /var/log/* /var/lib/apt/

# Web viewer
EXPOSE 7396

USER folder

WORKDIR /home/folder

ENTRYPOINT ["FAHClient", "--web-allow=0/0:7396", "--allow=0/0:7396"]
CMD ["--user=Anonymous", "--team=0", "--gpu=false", "--smp=true", "--power=full"]

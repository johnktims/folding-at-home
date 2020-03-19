FROM nvidia/cuda:9.2-base
LABEL maintainer="john.k.tims@gmail.com"

ENV FAH_VERSION_MINOR=7.5.1
ENV FAH_VERSION_MAJOR=7.5

ENV DEBIAN_FRONTEND=noninteractive

RUN groupadd -g 9999 folder && \
    useradd -r -b /home -u 9999 -g folder folder

RUN mkdir /home/folder && chown folder:folder /home/folder && chmod 700 /home/folder

RUN apt-get update && apt-get install --no-install-recommends -y \
        curl adduser bzip2 ca-certificates clinfo ocl-icd-libopencl1 &&\
        curl -o /tmp/fah.deb https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v${FAH_VERSION_MAJOR}/fahclient_${FAH_VERSION_MINOR}_amd64.deb &&\
        mkdir -p /etc/OpenCL/vendors && \
            ln -s /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /usr/lib/x86_64-linux-gnu/libOpenCL.so &&\
            echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd &&\
        mkdir -p /etc/fahclient/ &&\
        touch /etc/fahclient/config.xml &&\
        dpkg --install /tmp/fah.deb &&\
        apt-get remove -y curl &&\
        apt-get autoremove -y &&\
        rm --recursive --verbose --force /tmp/* /var/log/* /var/lib/apt/

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Web viewer
EXPOSE 7396

USER folder

WORKDIR /home/folder

ENTRYPOINT ["FAHClient", "--web-allow=0/0:7396", "--allow=0/0:7396"]
CMD ["--user=Anonymous", "--team=0", "--power=full"]

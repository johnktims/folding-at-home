Docker container for running [Folding@Home](http://folding.stanford.edu/)

### Example usage
```bash
docker run --rm -it -p7396:7396 johnktims/folding-at-home:latest \
    --user=John_Tims --team=11675 --power=full
```

The web console is available on port `7396`.

GPU support
===========
If you have Docker 19.03+, Nvidia drivers, and `nvidia-docker-toolkit` installed
on the host, you can start folding by adding `--gpus all`.
```
docker run --gpus all --rm -it -p7396:7396 johnktims/folding-at-home:latest \
    --user=John_Tims --team=11675 --power=full
```

# Ubuntu setup guide
### Install docker
```
sudo apt-get update && sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y ubuntu-drivers-common docker-ce docker-ce-cli containerd.io
```
### Install Nvidia drivers and toolkit
```
sudo ubuntu-drivers devices
# Install the recommended drivers or pick one from the list and install (e.g. sudo apt install nvidia-driver-435)
sudo ubuntu-drivers autoinstall

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```
### Start folding
```
docker run --rm -it --gpus=all -p7396:7396 johnktims/folding-at-home:latest \
                    --user=John_Tims --team=11675 --power=full
```
# Instalation-setup: on linux debian distribution


# Installation for the non-production environments::
```
curl -fsSL https://get.docker.com -o docker-install_script.sh  => script to install docker engine
sh ./docker-install_script.sh --dry-run  => chekcing the steps the script is installing
or 
curl https://get.docker.com/ | bash

docker version
```
# Installation for the production environments::

Run the following command to uninstall all conflicting packages:

```
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc;
do
sudo apt-get remove $pkg;
done
```

Also remove everything in the /var/lib/docker/ folder for clean installation..
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
if want to uinstall
sudo apt-get purge docker-ce docker-ce-cli containerd.io

```
1) 
# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

2) 
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

checking::
cat /etc/apt/sources.list/docker.list
Response: deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable

sudo apt-get update -y

3) 
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

4) 
systemctl status docker
docker --version or docker version
docker info
sudo docker run hello-world
docker info -f '{{.DockerRootDir}}'
```


After Installing docker...
**********************************
# To maintain persistent data of docker containers,doker volumes,images.
1) create the EBS volume (tetsing 10 to 20 GB)
2) attach to the docker running instance
3) lsblk  or fdisk -l => will see the storage wihtout the filesystem and mount point..
4) fdisk <name-of-block-device> for-ex: /dev/xvdf or dev/<nvme1n1>
5) press n =>p => enter(default) => enter(default) => enter(default) => w
6) check lsblk   for-ex: nvme1n1p1
7) sudo mkfs -t ext4 /dev/nvme1n1p1  => create the file system for writing and retriving the data
    usually we have two file systems - "ext4" and "xfs" 
    copy the Filesystem UUID =8273c9d8-d895-44d6-9d63-7d6e71aca91e
8) create the mount point in some dir and mount the formated filesysytem to that dir
    sudo mkdir /tmp/docker-data-ebs
    mount /dev/nvme1n1p1 /tmp/docker-data-ebs
9) To ensure the volume is mounted automatically on instance reboot
    nano /etc/fstab
    ** add the below line (use the tab space after entry in editor)
    UUID=<uuid> /dev/nvme1n1p1 ext4 discard,errors=remount-ro       0 1
    mount -a (mounts all file-systems listed in /etc/fstab)
    df -h
10) change the default directory for the docker files storage
    sudo systemctl stop docker.service  
    nano /lib/systemd/system/docker.service
    Under service---add the following like below"--data-root /tmp/docker-data-ebs" 
    "ExecStart=/usr/bin/dockerd --data-root /tmp/docker-data-ebs -H fd:// --containerd=/run/containerd/containerd.sock"
    rsync -aqxP /var/lib/docker/ /tmp/docker-data-ebs
    sudo systemctl daemon-reload
    sudo systemctl restart docker



```
sudo su -
apt update -y && apt install net-tools -y && apt install iputils-ping -y
```

Try-1::
ifconfig => interface config   usually on some ditributions it is deprecated..use "ip addr show "
-> eth0 => a network interface of host-machine  which talks to internet
        => it has its own subnet mask 


Note::
read about the CGroups and Namespaces clearly from google/chatgpt.
Here docker uses systemd as a Cgroup for management of the resources of aws instance launched



Try-2::
ifconfig => we will see the docker0 and eth0/ens5 
    =>docker0 =>a bridge network interface which communicates between the conainter and host-machine
    we can also create the custom bridge networks

usually when any container started ....we will see the eth0 ,docker0,vethpairs(veth0 and veth1)
Veth pairs(virtual ethernet pairs) => veth0 will be inside the container and veth1 will be door step of the a specific container ,so all veth1's will have the bridge connection with the docker0 and docker0 with the eth0 and eth0 to the internet....

        veth0 <-> veth1 <-> docker0 <-> eth0 or ens5 <->internet


docker system prune -a (deletes the containers,images cache)
docker inspect <container-id>
port mapping(-p or --publish)
docker container run -p 8080:80 <container-id>  => if container already running
 docker run  -d --restart always --name nginx1 -p 8080:80 nginx:latest
 To check the restart-policy::
 docker inspect --format='{{.HostConfig.RestartPolicy.Name}}' <container_id_or_name>

Connecting to the Docker host remotely is crucial for DevOps engineers in various scenarios..
Monitoring and Logging, Security and Compliance ,Infrastructure Automation , Container Orchestration.....
Continuous Integration/Continuous Deployment (CI/CD): Docker containers play a central role in CI/CD pipelines, where applications are built, tested, and deployed automatically. DevOps engineers need remote access to the Docker host to trigger CI/CD workflows, deploy containerized applications, and monitor pipeline execution.

# By through modifying the docker.service file in the host
nano /lib/systemd/system/docker.service
    Under service---add the following like below" -H tcp://0.0.0.0:2375" 
    "ExecStart=/usr/bin/dockerd --data-root /tmp/docker-data-ebs -H=fd:// -H=tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock"

    sudo systemctl daemon-reload
    sudo systemctl restart docker
    curl http://ipinfo.io/ip  gets the public-ip 
    Next
    Install the docker in the remote machine where everyday i.e devops guy do the multiple task on servers...
    use the docker commands to talk to docker host...
    docker -H tcp://<public-ip-addr>:2375 <docker-sub-commands-here>
    docker -H tcp://12.23.25.230:2375 ps
    docker -H tcp://12.23.25.230:2375 images
    docker -H tcp://12.23.25.230:2375 inspect <container-id>   
    etc....


#  Installing docker on remote  and connecting remote host using the "docker context"
    **Install docker remotely
    **docker context create nginx-server \
        >--description "connection to nginx server" \
        >--docker "host-tcp://18.61.48.230:2375"
    docker context show
    docker context use <new-context-name>
    Now we can use the docker commands on the host-docker remotely


# Enabling the TLS encryption and authentication between the docker client and docker daemon


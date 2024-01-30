docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
a237fd54258b   bridge    bridge    local  - docker0  -webAPP
3fed3ca6804c   host      host      local  - uses the host IP address  -node_exporter
1767112ccb83   none      null      local  - no allocation of ip-address

docker run --rm -dit --net="host" --name <container-name> <image-name>:tag
docker run --rm -dit --net="none" -v /var/run/docker.sock:/var/run/docker.sock --name <container-name> <image-name>:tag

Note::
=>if your container need to be accessed from the outside then use the bridge..
=>if your container needs to share HOST IP like for ex:node_exporter then use the host network
=>if there is no need any network where you need to run commands on the docker socket then use none net..

**Concern of Service discovery:**
By default, Docker assigns IP addresses dynamically to containers using its internal networking system. When a container is started, Docker assigns an available IP address from the subnet configured for the Docker bridge network.
So we will do the name resolution for the two conatiners and try to establish the communicate between the services/conatiners...

docker network create <network-name>  => creates the cutsom bridge network
Create the two containers sample using below command...
docker run --rm -dit --net="<network-name>" -v /var/run/docker.sock:/var/run/docker.sock --name <container-name-1> <service-image-1>:tag
docker run --rm -dit --net="<network-name>" -v /var/run/docker.sock:/var/run/docker.sock --name <container-name-2> <service-image-2>:tag
try to ping from one container to another conatiner...

Note::
 Docker manages network traffic between containers and the external network by using NAT and routing rules on the Docker host. This allows containers to communicate with services outside the Docker host while maintaining network isolation and security.

if we want connect to more networks

docker network connect <network-name> <network to be connected>
docker network connect frontend web_server
docker network inspect frontend | jq
docker network disconnect frontend web_server


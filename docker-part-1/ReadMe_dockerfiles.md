Containers
***********************
"The container lifecycle refers to the sequence of states and actions that a Docker container goes through from creation to termination.

1. Create a Container:
docker run -d --name my_container nginx
2. Start a Container:
docker start my_container
3. Pause a Container:
docker pause my_container
4. Unpause a Container:
docker unpause my_container
5. Stop a Container:
docker stop my_container
6. Kill a Container:container does not respond to the SIGTERM signal or needs to be stopped forcefully
docker kill my_container
7. Restart a Container:command stops and then starts the container again.
docker restart my_container
8. Remove a Container:
docker rm my_container

How a devops enginner answers about the container-Lifecycle in interview ?

Scenario : Continuous Integration/Continuous Deployment (CI/CD) Pipeline
Scenario: Consider a CI/CD pipeline where containers are used for testing and deployment.

1.Creation:
The CI/CD pipeline triggers a job to create Docker containers for building and testing the application code.

2.Running Tests:
The containers execute automated tests on the application code to ensure its quality and functionality.

3.Deployment:
After successful testing, the pipeline deploys the application to staging or production environments by starting 
new containers with the latest image.

4.rollback:
If issues are detected in the deployed application, the pipeline can roll back to a previous version by starting containers with the last known good image.

5.Monitoring:
Throughout the lifecycle, monitoring tools track container performance, resource utilization, and application health metrics.

6.Auto-Scaling:
In response to increased demand, auto-scaling policies may trigger the creation of additional containers to handle the load dynamically.

7.Maintenance:
During maintenance windows, containers may be stopped, updated, and restarted to apply security patches or configuration changes.


********************************************************************************************************************

# DockerFile

***Dockerfile Instructions are as below....***

**During the BUild process-image creation**
**FROM** 
**WORKDIR**
**RUN** 
**COPY** (for copying the appilication from source to destination locally or host)
**ADD** (Similar to COPY but has additional features like URL support and automatic extraction of compressed files)
**ARG**
**ENV**

EX:1
*******
RUN <command>
Executes shell commands within the container during the image build process. Used for installing dependencies, setting up the environment, and configuring the application.
*RUN npm ci --only=production

EXPOSE <port>
Informs Docker that the container listens on the specified network ports at runtime. It does not actually publish the ports.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

**Post Build process**
**VOLUME** (Creates a mount point within the Docker container and specifies that the directory should be externally mounted. It's used for persisting data)
**HEALTHCHECK**

EX:2
CMD ["executable", "param1", "param2"]
-Defines the default command to run when the "container starts". It is often used to launch the application process.
CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT ["executable", "param1", "param2"]
USER <username>   switches to the user "root" or "nonroot" or nay custom created user


if there are multiple stages in the dockerfile..
# Copy the built application from the build stage
using the ==  COPY --from=build /app/build /usr/share/nginx/html

sample::

```
# Stage 1: Build Stage
FROM node:14 AS build
# Set the working directory
WORKDIR /app
# Copy package.json and package-lock.json to the working directory
COPY package*.json ./
# Install dependencies
RUN npm install
# Copy the rest of the application code
COPY . .
# Build the application
RUN npm run build
# Stage 2: Production Stage
FROM nginx:1.21-alpine AS production
# Copy the built application from the build stage
COPY --from=build /app/build /usr/share/nginx/html
# Expose port 80
EXPOSE 80
# Command to start Nginx
CMD ["nginx", "-g", "daemon off;"]
```

**EXPOSE**
Here's what EXPOSE does:Understanding EXPOSE is very tricky question for interview

1) It documents the ports that the container listens on.
2) It provides information to developers and operators about the network services offered by the container.
3) It does not actually publish the ports or make them accessible from outside the container.
    For example, if you have an application that listens on port 8080 inside the container, you can use the EXPOSE instruction to document that port:

    EXPOSE 8080
    Then, when you run a container from this image, you can use the -p option to publish the container's port to the host:

    "docker run -p 8080:8080 my_image"
    This command publishes port 8080 inside the container to port 8080 on the host, making the application accessible from outside the container.

Note::
**foreground mode**
CMD [ "nginx", "-g", "daemon off;"]: Provides additional arguments to the executable. In this case, it sets Nginx to run in the foreground mode (daemon off;). Running Nginx in the foreground mode ensures that the Docker container does not exit immediately after starting, allowing Nginx to stay active and serve incoming requests.

**Background Mode**
 In background mode, Nginx detaches from the terminal and runs as a daemon in the background. This is the default behavior of Nginx when started without the -g "daemon off;" option. In production environments, Nginx typically runs in background mode to allow the terminal session to be freed up after starting the server.


Note::
RUN,ADD,COPY  these instructions increases the image size by creating the many layers..
In dockerfile every step is a layer and every layer is a image which will compound to the image size ...

Metadata,ARG,ENV will not add any layers....

While  building the image from dockerfile..when we hit "docker images -a"  we see
**Dangling images** in Docker are those that have no tags associated with them.
=> docker images -a   => will list the untagged images also,which can be pruned..
=> docker image prune


**commands used everyday by devops engineers**

docker images
docker images -a  =>list both images and dangling images also\
docker images -aq  => list all images-ids
docker rmi $(docker images -aq) --force   =>removes all images expect with running containers
docker build -t <tag-name>/<org-name>:<version-id>  -f <dockerfile>
docker image history <tag-name>or<image-name>  => list all image-ids which imapcts the data i.e size
docker run --rm -dit <tag-name>  => it runs the containers after staring with the CMD specified
docker run --rm -dit <tag-name> /bin/bash  => => it overides the CMD or EntryPOInt in dockerfile with /bin/bash
docker run --rm -dit -p 8000:80 <tag-name>or<image-id>or<image-name>
docker logs <container-id>or<container-name> -f
(-f flag, also known as --follow, allows you to follow the log output in real-time, similar to the tail -f <log-path>command.)
docker run -e <variable-name1>=<value> <image-name>      (-e --environment)
docker run -e <variable-name1>=<value> <variable-name2>=<value> <image-name>
using the build args-we can pass the secrets
docker build --build-arg <arg-name1>=<value1> --build-arg <arg-name2>=<value2> -t <image-tag> -f <dockerfile>
docker build --build-arg terraform_ver=1.7.1 --build-arg packer_ver=1.10.1 -t <image-tag> -f <dockerfile>
docker build --no-cache -t <custom-image-name> .   => "."  refers current dir
docker container prune -a  => will delete all stooped conatiners 
docker container prune --force => deletes all the exited containers
docker exec -it <container-id> /bin/bash  => it opens the shell in conatiner to run commands on sevice,check logs
docker exec -d  <container-id> /bin/bash   => it will  detach from the container terminal after command execution
docker exec -it <container-id> cat /usr/share/nginx/html/index.html
docker container run -p 8080:80 <container-id>  => if container already running
 --- docker run  -d --restart always --name nginx1 -p 8080:80 nginx:latest
 ---To check the restart-policy::
 ---docker inspect --format='{{.HostConfig.RestartPolicy.Name}}' <container_id_or_name>



**Note::Imp**
**CMD** can be **overridden** and **ENTRYPOINT** cannot be **overridden**  in docker conatiners
For example, if the Dockerfile contains CMD ["nginx", "-g", "daemon off;"], you can override it by specifying a different command when running the container, such as "docker run my_image /bin/bash"
If a Dockerfile contains multiple CMD instructions, only the last one will take effect.

-override the ENTRYPOINT instruction by specifying the "--entrypoint" flag when running the container.
For example, if the Dockerfile contains ENTRYPOINT ["nginx", "-g"], you can override it by specifying a different entrypoint, such as "docker run --entrypoint /bin/bash my_image"

**About container Imp Notes::**
=>Containers exit when their main process completes or when they receive a stop signal (such as a SIGTERM or SIGKILL signal). If the process inside the container completes its execution, the container will automatically exit. Likewise, if you manually stop the container using the docker stop command, it will also exit.

=>"docker run -d your_image_name"   => -d=deatched from foreground run the daemon at background
This will start the container in the background, and it will continue running until explicitly stopped, even if its main process has completed.

In the context of Docker containers:

=>When you use the docker stop command, Docker sends a SIGTERM signal to the main process running inside the container, giving it an opportunity to shut down gracefully.
=>If the process does not exit within a certain timeout period (default is 10 seconds), Docker then sends a SIGKILL signal to forcefully terminate the process and stop the container.


# decreasing the docker image sizes

**using the multi statge builds and minimalistic distroless images and decreasing the layers**

"Distroless" images contain only your application and its runtime dependencies. They do not contain package managers, shells or any other programs you would expect to find in a standard Linux distribution.

The basic idea is that you'll have one stage to build your application artifacts, and insert them into your runtime distroless image

```Base image for your application stacks
gcr.io/distroless/static-debian12
gcr.io/distroless/static-debian11
gcr.io/distroless/base-nossl-debian12
gcr.io/distroless/base-nossl-debian11
gcr.io/distroless/base-debian12
gcr.io/distroless/base-debian11
gcr.io/distroless/java11-debian11
gcr.io/distroless/java17-debian12
gcr.io/distroless/java17-debian11
gcr.io/distroless/cc-debian12
gcr.io/distroless/cc-debian11
gcr.io/distroless/nodejs18-debian12
gcr.io/distroless/nodejs18-debian11
gcr.io/distroless/nodejs20-debian12
gcr.io/distroless/nodejs20-debian11
gcr.io/distroless/python3-debian12
```

Sample Go app using official distroless Images Published by google..

```
# Start by building the application.
FROM golang:1.18 as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN CGO_ENABLED=0 go build -o /go/bin/app

# Now copy it into our base image.
FROM gcr.io/distroless/static-debian11
COPY --from=build /go/bin/app /
CMD ["/app"]
```

**NOte::As ubuntu is based on debian**
Ubuntu 20.04 LTS (Focal) -> Debian 11.0 (Bullseye)  -stable
Ubuntu 22.04 LTS (jammy jellyfish) -> Debian 12.0 (bookworm) -unstable , please check for latest data

Minimising the layer count and skipping installing unwanted/recommednded packages ..

```Using --no-install-recommends --no-cache
FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends --no-cache vim net-tools dnsutils -y

```

To login to distroless image running container,
Ex-say python process is running behind
=> docker attach <container-id>  =>it does not opens the shell to execute commands,just opens the python terminal

Sample Node.js appilication deploy and push to private registry in dockerhub and enabling the Github-Actions for the future version upgrades..One can do beginer level hands-on 
https://betterstack.com/community/guides/scaling-nodejs/dockerize-nodejs/
https://github.com/betterstack-community/chucknorris


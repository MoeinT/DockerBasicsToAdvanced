# Docker Basics
We'll first review some of the most basic concepts and slowly move to more advanced concepts. We'll start by defining a typical Docker workflow and start packaging a source code into an image, push it to the Docker Hub, pull it again, and run it as a container. We'll then continue the whole declarative deployment concepts and how to run multi-container applications using docker-compose. We'll finish up the basics by introducing Docker Swarm. 
## Docker workflow

Docker is a way to package an application and all their dependencies into one isolated environment. There are a few steps in running a containerized application: 

- We would first package the application into a Docker Image shared into a docker registry, such 
as docker hub. 
- We would then need to pull that image and run it as a container. 

The above two steps would require running a few commands. For the first part, packaging the source code into a docker image, we would have to create the Dockerfile first with all
the required steps. We'll come back to it later, but for now let's go back to basics.

## What is Docker? 
Docker is an open-source platform that allows packaging an application into a lightweight, isolated environment, called container. So, containers are units that encapsulate the whole application like, its dependencies and necessary runtime environment. Using containers, we can run a whole application across multiple computing environment. Here are a few advantages from a Data Engineering perspective:

- **Consistency -** You can package your data engineering applications with all their depencencies and configuration into a container. This ensures to reproduce the same results across all development stages. 

- **Portability and scalability -** Portability means that you can package your application into a 
container and run it on any infrastructure that supports Docker, whether in cloud or on-premise. Containers also support horizontal scaling, which means you can scale your data processing application by deploying multiple instances of the containers
- **Resource efficiency -** Containers are lightweight, consuming fewer resources as virtual machines. This allows data engineers to reduce infrastructure costs, especially when dealing with large-scale data processing workloads.
- **Easy deployment -** Docker simplifies the deployment of applications and microservices. You can package a whole microservice and its dependencies into a portable artificat. These images can then be deployed across multiple environments.

- **DevOps and CI/CD processes -** Docker plays a crucial role in DevOps modern practices. A Docker image can be used as an Artifact within a CI/CD proceses, that ensures consistent and reproducible builds, testing and deployment.

## Building on the first workflow

- The first step would be to package the source code into a Docker Image and push it into a Docker registry. In order to do this, we would need to create a Dockerfile and specify a set of build instructions. It's a set of instructions for Docker to build the application and its dependencies into a container image. 

- Once you have created the Dockerfile in your repository, use the ```docker image build -t moeint/gsd:first-ctr .``` command to package it into an image and push it into the dockerhub. ***moeint*** is the dockerhub id to push the image to; and ***gsd*** is the name of the repository; and finally, ***first-ctr*** is the actuall name of the image. The final period at the end of command means that all the file required to build the image, especially the Dockerfile, is available to the repository I'm running this command from. We would have had to provide its location if that weren't the case.

- Once the image is created, you can go ahead and run it locally, however, it's always better practice to push it to a docker hub. run the ```docker image push moeint/gsd:first-ctr``` command to do so; you might need to login to your account first using ```docker login``` before pushing it remotely.

- Once we have pushed the image remotely, we can run it directly from the local machine, or pull it from the hub again and run it. Use the ```docker container run -d --name web -p 8000:8080 moeint/gsd:first-ctr``` command to do so. It'll first look at the images locally, if it doesn't exists, it'll pull it from the Dockerhub and run it locally as a container. 

- In order to stop the running container, run the ```docker container stop web``` command, web being the name of the running container.

- To see a list of all running and stopped containers, run the ```docker container ls -a``` command.

- See the list of all running and stopped containers by running ```docker container rm web``` command.

## Multi-container applications with Docker
Microservices architecture is a style where applications are built as a collection of small, loosely-coupled microservices. Each microservice can be responsible for a part of the bussiness logic and can be developed, deployed and scaled independently.  

## Declarative deploymeny 
This term refers to the practice of defining the final state of your infrastructure or application using a declarative configuration file, typically in a YAML file. This approach focuses on describing the final state, rather than providing details on every required step to reach that final state. 

## Docker Compose
Docker-compose allows you to manage and define your multi-container applications using a declarative approach in a YAML file. This file describes services, networks, volumes and configurations of your applications in a single docker-compose.yaml file. For example, an application might need a web server and a database; we can define both these components in a yaml file and run the whole application using a single docker compose command. 

- Using the ```docker-compose.yaml``` we won't need to use the docker commands manually to build or pull or run docker images. We will define the final state of what's required and everything else gets taken care of under the hood. 

- This is a better practice to document and keep track of containers running in a multi-container applications.

## Docker Swarm 
Docker Swarm is a native clusteing and orchestration solution provided by Docker; it allows you to create and manage a swarm of Docker nodes and join them into a unified docker engine. 

- In a Docker swarm, there are two types of Docker nodes, the worker node, and the manager node. The manager node is responsible for managing the cluster and coordinating the activities of the worker nodes; the worker nodes however, are responsible for the actual execution of containers. 

- In Docker Swarm, you can use the final state of the containerized application through docker-compose.yaml file and take advantage of declarative deployments. 

Here how we can **Deploy and manage multiple services in a Docker Swarm cluster**: 

Within the ```-c docker-compose.yaml``` file under the swarm-stack folder, we have defined two services: a redis database, and 10 replicas on the web application. Stacking these two services within Docker Swarm, the request get distributed and balanced across 10 containers. Here's a detailed instruction to get the stack up and running: 

- Under the swarm-stack folder, we have a multi-container application defined in the docker-compose.yaml file. Using Docker Swarm, we cannot build an image on the fly; we need to first have the image created by running ```docker image build -t moeint/gsd:swarm-stack .``` and push it remotely using the ```docker image push moeint/gsd:swarm-stack``` command. 

- Once that done, usg the ```docker stack deploy``` command to deploy a stack of services to the Docker Swarm cluster. Use the ```-c docker-compose.yaml``` argument and pass in the docker-compose file; the file describes the final state of the services including their dependencies and configurations and related information. 

- Pass in a name as an identifier for the group of services that will be deployed as a whole. Here would be the final command: ```docker stack deploy -c docker-compose.yaml counter```. By running this command, Docker Swarm will create the services described within the docker-compose file. These services will be scheduled and distributed across the worker nodes. Using this approach, we can manage and deploy multiple services as a unified stack in a Swarm cluster. 

- Once the swarm stack is created, check it and the running services using the ```docker stack ls``` command. Use the ```docker stack services counter``` command to get more details on each service within the stack. 

- We can modify the number of replicas and run the docker stack command again; the stack gets updated. Run the ```stack ps counter``` command to get more details on all the replicas. 

# Docker Deep Dive 
In this section we go through the same concepts, but will dive a lot deeper. 
## What is an image? 
A docker image is a lightweight, standalone, executable package that includes everything required to run a piece of software, including the code, runtime and libraries. It's built from a set of instructions specified in the Dockerfile. A docker image consists of multiple layers stacked on top of each other each representing an instruction mentioned in the Dockerfile, such as installing a software or copy a file. These layers will create a single, immutable and portable file that can run on any machine that has Docker installed in it. it provides a consistent and reproducible environment, ensuring that the application behaves the same way in any environment (dev, test, qa and prod).

Images are usually stored in a remote registry, like Docker Hub. We can pull an image and run it locally as a container. When pulling the image, the whole image is pulled as a number of independent layers stacked on top of each other, and not as a single blob or object. We can see  those layers in our terminal when being pulled. Here's model details on each of those layers.

### Manifest file
It is a JSON file that serves as the bluprint for the image providing information about each layer size, digest, and configurations. The goal of the manifest file is to provide a unified view of the image, ragardless of the platform on which it's running on. It maintains the loosely coupling of each layer and their ordering allowing Docker to reconstruct the image properly.

## What is a containers?
A few important concepts before defining containers:

- **kernel -** In an operating system, the kernel is the central component that acts as a bridge between applications and the underlying hardware. It is a critical part of the operating system responsible for managing system resources, providing essential services, and facilitating communication between software and hardware components.

- **Namespace -** Namespacing refers to the process of isolating resources within a system and allocating that portion of the resource to a specific program. The Kernel is then responsible for managing and orchestrating the incoming requests from the softwares by redirectign them to the correct namespace. So, namespacing refers to the isolations of resources per processs or group of processes. On a simlilar topic, a control group is a way to limit the amount of resources for a process or group of proceses.

- **Container -** Given the above definitions, a container is a specific process/software plus its dedicated namespace. The two will form a container. So, a Docker container can be thought of as a process or a grouping of processes that have their own resources assinged to it. So, when we run an image as a docker container, the Kernel will dedicate a portion of the hard drive resources to that container and install the required software and dependencies inside that segment; it'll also copy the file system from the image into that segment; once that's done, it'll run the commands specified in the image and create the required processes. The first portion of the above process is accomplished by running the ```docker create  <image_name>``` command. The second part would be accomplished by running the ```docker start <container_id>``` command.

- **Docker running on a non-linux OS**
Namespacing and control groups that we discussed above are concepts available in Linux; if that's the case, how can we run a Docker container on a Windows machine, for example? When we installed Docker for Windows, we also installed a linux-based virtual machine. When we run an instance of the image to create a container, the Linux kerner will dedicated the required resource from the computer's hardware and create an isolated namespace; it'll then pick up the required commands from the image and run the required processes on that namespace to create the whole container. 

## Docker CLI
Here's a quick review of some of the useful Docker CLI commands:
- **```Docker logs <container_id>``` -** Use this to inspect everything that gets emmited from a container. You can use logs for debugging issues and investingating why the container is not behaving as it should. Logs can also be useful within CI/CD workflows. 
- **```Docker stop and Docker kill``` -** In Docker, both docker stop and docker kill are commands used to stop running container. Docker stop sends a SIGTERM signal to the container, which instructs the main process inside the container to gracefully stop and exit. If the container doesn't stop within the timeout period, Docker proceeds to send a *SIGKILL* signal. ```Docker kill``` sends a *SIGKILL* signal to the container, which immediately terminates the container without giving it a chance to perform any cleanup tasks or save its state.

## Building an image
We will provide a set of instructions on a Dockerfile and build the image out of it. The Dockerfile includes instructions to copy files from your local filesystem into the Docker image, set environment variables, install dependencies, run commands during the build process, and define the command that should be executed when the container based on the image is run. In short, the dockerfile contains the following 3 steps:
- Create a base image
- Run commands to install additional programs
- Specify a command to run on container startup

### Base Layer
In Docker, the base image is the bottom-most layer and the foundation on which every other layer gets built on. It provides a basic operating system environment along with packages and softwares required to build an application. The base image is specified through the FROM instruction in the Dockerfile, like ```FROM ubuntu:latest```. An example of a base image is BusyBox. You can pull that image and run it as a container locally by running ```docker run -it --rm busybox```; -it stands for interactivelly, meaning that we'll be able to access the container in the terminal; --rm will delete the container once it's been stopped. When the busybox container running, we can run ```ls``` or ```echo``` commands on it; this is because these commands are available within the containers file system.

### All Steps in building an image
On each step a temporary container is build based on the previous step. It'll copy its file system and run a new command on it associated to the current step. It'll then copy the file system of the new container, take a snapshot and store it as a new image. It then shuts down the temporary container it'd created. The same process continues for the next instructions in the Dockerfile.

## Simple project
Under the simple-web folder, we'll create the required files to run a node.js application. ```package.json``` file, which is used in Node.js projects to define project metadata, manage dependencies, and specify scripts for various tasks; there are two main sections: 
    - **depencencies -** In this case, the only dependency mentioned is "express" with a wildcard version (*), which means it will install the latest available version of the Express framework. Express is a popular web framework for Node.js used for building web applications and APIs. When you run the application, Node.js will automatically read this section and install the specified dependencies using a package manager like npm (Node Package Manager) or yarn. 
    - **Scripts -** This section allows you to define custom scripts to execute various tasks related to your application. In this case, there is a "start" script defined, which specifies that when you run the command npm start or yarn start, it should execute the command node index.js. This script is typically used to start the application.

### Dockerfile instructions for Simple App
In order to get the container up & running, we need to build an image, for which we require a Dockerfile. Within this docker file we need to specify the following:
- Specify the base image using the ```FROM``` command: We need to  sure the base image we're choosing is compatible with the commands we'll run in the next instructions. In this case we choose node:14-alpine (the word alpine referes to the most basis and lightweight version of the node image).
- Copy the required files using the ```COPY``` command: We will have to copy the package.json and and index.js files into the namespace of the container (notice that the container will run on a small segment of the hard drive, which is isolated and is not aware of the local files). It's best practice to not copy the files in the root directory of the container's filesystem; use the ```WORKFIR``` instructions in the Dockerfile and specify the initial working directory before the ```COPY``` command. 
- Install the dependencies using the ```RUN``` command: we will install the dependencies using npm.
- Specify the command using the ```CMD``` command: This will be command that will run when the container is starting.

**Docker volumes** When making a change to the source code in the local machine, this change is not going to be automatically projected into the container's filesystem, so we might have to rebuild the whole image from scratch. In order to solve this problem, we can take advantage of what is known as Docker volumes. Using this approach, instead of a full copy, we'll provide a reference to the filesystem at the source. 

### Running Simple App as a container
In order to build the above image, run the ```docker build -t moeint/simple-web:first-ctr .``` command. Once the image is built, run it using the ```docker run moeint/simple-web:first-ctr``` command. Once it's run, use the ```docker exec -it <name_or_id_of_the_container> sh``` command to get inside the container and verify the existence of the files. 

### Running the Simple App on the browser 
In order to be able to see the app up & running in our browser, we will have to make a request to the local host network through the ```http://localhost:8080/``` url. However, this is not enough to connect to the container; by default, no incoming traffic to the local host gets routed to the container's network. The container has its onw isolated network with a range of available ports. In order to make sure that any incoming request gets routed to the container's network, we will have to set up an explicit port mapping. Port mapping means that anytime a machine makes a request to our local network, that request should automatically be forwarded to the container's network. In order to implement port mapping and forward the incoming traffic to the container, we need to modify the Docker run command to ```docker run -p 5000:8080 <image_id>```. This command says that any incoming request to our local's network on port 5000, should be automatically forwarded to port 8080 inside the container. **We need to make sure in the source code that the application running inside that container is also listening on port 8080.**

## Visits App
In this new simple application, we'll increment the number of times the page has been visited. In order to do this, we'll add an additional Redis container as a database to hold the number of visits. So, we'll have a node.js application running on one container, and a Redis server running on a separate container. To implement this we'll use Docker Compose. 

### Docker Compose
See the above sections for an introduction to Docker Compose. In order for the Redis database to be able to store information, number of visits in this case, we need to make sure the two containers can communicate with each other; so, we need to set up a networking infrastructure between 
the two containers. Docker Compose is beneficial to start multiple Docker containers at the same time and connect them together in an automated and declarative fashion. Here are the steps: 
- Start by providing the docker compose version: ```version: '3'```
- provide all services within your multi-container applications: ```services:```
- Under the services section, choose the images you'd like to run, or declare the ones you'd like to build using the ```build``` command. See the docker-compose.yaml file for more information. 

### Restart policies on docker-compose
Here are the different policies on how to restart a container in case it stops or crashes: 
- No: Never attemp to restart the container if it stops or crashes
- Always: If this container stops for any reason, always attemp to restart it.
- On-failure: Only restart if the container stops with an error code
- Unless-stopped: Always restart unless we forcibly stop it. 

## React Project
Here we take advantage of node.js to get a custom project to start testing and playing around with Docker. The project is under the frontend folder. Within this folder, we can test the application by running ```npm run test``` commad, run it in the development environment using ```npm run start```, and finally ```npm run build``` for production. We'll use docker to run the application in both dev and prod environments; for this, we'll create two dockerfiles, Dockerfile.dev and Dockerfile to build the docker images to run in dev and prod environments, respectively.

**Note -** In order to take advantege of Docker volumes and project changes in the source code to the application real time, run this command: ```docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app <image_id>```; pwd refers to the current working directory; won't work on windows; use the whole path instead. If we take advantage of Docker volumes, we won't have to copy every single file from the local machine to the container's filesystem.

### Workflow for the React App
We'll start by running the application in the Dev environment. For that, we've set up a docker-compose.yml file. There's a separate Dockerfile.dev file that build the required image for the dev environment. Once the application is running within the Dev environment, we'll test it using the ```npm run test``` command.

#### Tests
If you'd like to run any command on the running container, you need to specify it within the docker run command. For testing the react.js application, we can use the ```docker run -it <image_id> npm run test``` command. This will run the tests on the running container. Another approach would be to use the ```docker exec -it <image_it> npm run test``` command and run the tests inside the container. You can apply the ```npm run test``` command once you're inside the container.

#### Production 
We'll define a separate Dockerfile to create a production version of the Docker container in dev. For this we'll need a server that's more suitable for running production-level application. 

#### Nginx
When there are multiple environments for running our applications, we need to make sure the incoming traffic gets routed to the right one; i.e., the application for the dev environment is hosted on a different container than the one in the production environment. When we make a request to our browser, we need to make sure the incoming request/traffic gets routed to the right container. So, Nginx acts as a load balancer that can distribute the incoming traffic across multiple containers. 

#### Dockerfile for production
The Dockerfile to build the image required to build the application in production has two steps: 
- **build:** Build the production-level application using the ```npm run build``` command. For this step we'll use the same base image as we used for the development environment.  
- **Run:** Once the build process is finished, we'll need to run the production application; we'll do so using the Nginx base image and copy the ```build``` folder, which contains a number of static fiels, from the first step into the second ngix file system.

**Note -** The Ngix image listens on port 80; make sure to check out the documentation and specify the right port mapping when using a new base image.

### Continuous Integration and Delivery
Under the ```.github/workflows``` folder, we've created a workflow that runs on whenever there's a push to remote. It contains the following steps: 
    - Logs in to Dockerhub 
    - Creates an image based on ```Dockerfile.dev```
    - Runs the ```.npm run test``` command on the running image.   
# boca-docker

BOCA Online Contest Administrator (known simply as BOCA) is an administration system to held programming contests (e.g., ACM-ICPC, Maratona de Programação da SBC). According to the developers, its main features are portability, concurrency control, multi-site and distributed contests, and a simple web interface (for details refer to https://www.ime.usp.br/~cassio/boca/ and https://github.com/cassiopc/boca).

BOCA is implemented mainly in PHP and makes use of a PostgreSQL database in the backend (see architecture below). It is a good example of a monolithic system, in which the user interface and database access are all interwoven, rather than containing architecturally separate components. The problem is compound due to the low readability and complex code structuring, which is hard to adapt and extend.

The _boca-docker_ project is a use case of how we can take advantage of microservices architecture and containerization technology (i.e., Docker) to deploy applications in a more convenient and faster way (see illustration below). After quite some reverse engineering, we provide a dockerized version of BOCA's main components (web app, online automated judge and database) aiming at easing the customization, extensibility and automation of the operational effort required to deploy, run and scale BOCA.

Original architecture | _boca-docker_ architecture
:-------------------------:|:-------------------------:
![Alt text](/imgs/arquitetura-boca.png?raw=true "boca-docker architecture")  |  ![Alt text](/imgs/arquitetura-boca-docker.png?raw=true "boca-docker architecture")

This work started as part of the undergraduate final year project carried out by João Vitor Alves Fazolo under supervision of Prof. Dr. Rodrigo Laiola Guimaraes at Universidade Federal do Espirito Santo ([UFES](https://www.ufes.br/)).

## REQUIREMENTS:

* Install [Docker Desktop](https://www.docker.com/get-started).
* Install [Git](https://github.com/git-guides/install-git) (only for building and publishing).

## QUICK START:

* Open a Terminal window and make sure the Docker engine is up and running:

```bash
# List docker images
docker images -a
# List containers
docker container ls -a
```

* Download the `docker-compose.yml` and `docker-compose.prod.yml` files, and place them in the current work directory. Then,

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Voilà! The application should be running now.

* Open a web browser and visit the URL http://localhost:8000/boca. First, create and activate a BOCA contest (user: _system_ | password: _boca_). Then, login as admin (user: _admin_ | password: _boca_) to manage users, problems, languages etc. NOTE: consider changing these passwords later on. Find out more information on how to setup a contest [here](https://github.com/cassiopc/boca/tree/master/doc). For general questions about BOCA consider looking at this [forum](https://groups.google.com/g/boca-users).

* To stop the application (considering that the shell is in the same directory):

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml down
```

## HOW TO DEPLOY IT TO A SWARM:

* Create the stack (make sure Docker Engine is already running in [swarm mode](https://docs.docker.com/engine/swarm/swarm-mode/)):

```bash
docker stack deploy --compose-file docker-compose.yml -c docker-compose.prod.yml boca-stack
```

* Then, check if the stack is running:

```bash
docker stack services boca-stack
```

* Open a web browser and follow the instructions described above.

* To bring the stack down:

```bash
docker stack rm boca-stack
```

## HOW TO ADD CUSTOM CONFIGURATION:

There are many ways to customize the _boca-docker_ application. Without trying to support every possible use case, here are just a few that we have found useful.

* **Environment Variables:** shows the correct syntax for the various ways one can change pre-defined configuration values to keep the _boca-docker_ application flexible and organized. See documentation [here](tests/env/README.md).

* **Docker Secrets:** an alternative way to passing sensitive information via environment variables, causing the initialization scripts to load the values for those variables from files present in the containers. See documentation [here](tests/secrets/README.md).

* **Networking:** shows how to add network isolation between services in the _boca-docker_ application. See documentation [here](tests/networks/README.md).

* **Volume:** demonstrates how to persist data outside BOCA's database container in order to facilitate backup, restore, and migration. See documentation [here](tests/volume/README.md).

* **Healthcheck:** allows a check to be configured in order to determine whether or not the PostgreSQL container is "healthy." This is a particularly neat use case given that the other services depend on that to work. See documentation [here](tests/healthcheck/README.md).

## HOW TO BUILD IT (DEVELOPMENT):

* Clone this repo and set it as your working directory:

```bash
git clone https://github.com/joaofazolo/boca-docker.git
cd boca-docker
```

* Then, compose it up with the command below (this might take a while, sit back and relax):

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```

Follow the instructions [above](#quick-start) to set up the application.

* To stop it:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml down
```

* Alternatively, it is possible to build images without launching the application.

```bash
docker build -t boca-base . -f docker/dev/base/Dockerfile
docker build -t boca-web . -f docker/dev/web/Dockerfile
docker build -t boca-jail . -f docker/dev/jail/Dockerfile
```

## HOW TO PUBLISH IT:

* After building, set the user and image tags accordingly. The IMAGE_ID's will show up with the `docker images -a`.

```bash
docker images -a
docker tag IMAGE_ID_BOCA_BASE ghcr.io/joaofazolo/boca-docker/boca-base:1.1.0
docker tag IMAGE_ID_BOCA_WEB ghcr.io/joaofazolo/boca-docker/boca-web:1.1.0
docker tag IMAGE_ID_BOCA_JAIL ghcr.io/joaofazolo/boca-docker/boca-jail:1.1.0
```

* Log in into GitHub's Container Registry using your username and personal access token (details [here](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry)).

        docker login ghcr.io

* Push the container images to repository.

```bash
docker push ghcr.io/joaofazolo/boca-docker/boca-base:1.1.0
docker push ghcr.io/joaofazolo/boca-docker/boca-web:1.1.0
docker push ghcr.io/joaofazolo/boca-docker/boca-jail:1.1.0
```

## LICENSE:

Copyright Universidade Federal do Espirito Santo (Ufes)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

This program is released under license GNU GPL v3+ license.

## SUPPORT:

Please report any issues with _boca-docker_ at https://github.com/joaofazolo/boca-docker/issues

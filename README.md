# boca-docker

BOCA Online Contest Administrator (known simply as BOCA) is an administration system to held programming contests (e.g., ACM-ICPC, Maratona de Programação da SBC). It uses PHP and PostgreSQL in the backend and its main features are portability, concurrency control, multi-site and distributed contests, and a simple web interface (for details refer to https://www.ime.usp.br/~cassio/boca/ and https://github.com/cassiopc/boca).

The boca-docker project provides a dockerized version of BOCA's main components (web app, online automated judge and database) aiming at easying the deployment and extensibility of such a system. This implementation was part of the undergraduate final year project carried out by João Vitor Alves Fazolo under supervision of Prof. Dr. Rodrigo Laiola Guimaraes at Universidade Federal do Espírito Santo ([UFES](https://www.ufes.br/)).

## REQUIREMENTS:

* Install [Docker Desktop/CE](https://www.docker.com/get-started).
* Install [Git](https://github.com/git-guides/install-git) (only for building and publishing).

## QUICK START:

* Open a Terminal window and make sure Docker Desktop/CE is up and running:

```bash
# List docker images
docker images -a
# List containers
docker container ls -a
```

* Download the file `docker-compose-prod.yml` and place it in the shell current directory. Recommendation: open the file in a text editor and change all database passwords. Then,

```bash
docker-compose -f docker-compose-prod.yml up -d
```

Voilà! The application should be running now.

* Open a web browser and visit the URL http://localhost:8000/boca. First, create and activate a BOCA contest (user: system | password: boca). Then, login as admin  (user: admin | password: boca) to manage users, problems, languages etc. NOTE: consider changing these passwords later on.

* Autojudge will work only after restarting the boca-jail container.

```bash
docker stop docker stop boca-docker_boca-jail_1
docker start docker stop boca-docker_boca-jail_1
```

* To stop the application (considering that the shell is in the same directory):

```bash
docker-compose -f docker-compose-prod.yml down
```

## HOW TO DEPLOY IT TO A SWARM:

* Create the stack (make sure Docker Engine is already running in [swarm mode](https://docs.docker.com/engine/swarm/swarm-mode/)):

```bash
docker stack deploy --compose-file docker-compose-prod.yml boca-stack
```

* Then, check that the stack is running:

```bash
docker stack services boca-stack
```

* Open a web browser and follow the instructions described above.

* To bring the stack down:

```bash
docker stack rm boca-stack
```

## HOW TO BUILD IT:

* Clone this repo and set it as your working directory:

```bash
git clone https://github.com/joaofazolo/boca-docker.git
cd boca-docker
```

* Then, build the base image:

```bash
docker build -t boca-base . -f docker/dev/base/Dockerfile
```

* Next, compose it up with the command below (this might take a while, sit back and relax):

```bash
docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d --build
```

Follow the instructions above to set up the application.

* To stop it:

```bash
docker-compose -f docker-compose.yml -f docker-compose-dev.yml down
```

* Alternatively, it is possible to build images without launching the application.

```bash
docker build -t boca-web . -f docker/dev/web/Dockerfile
docker build -t boca-jail . -f docker/dev/jail/Dockerfile
```

## HOW TO PUBLISH IT:

* After building, set the user and image tags accordingly. The IMAGE_ID's will show up with the `docker images -a`.

```bash
docker images -a
docker tag IMAGE_ID_BOCA_BASE ghcr.io/joaofazolo/boca-docker/boca-base:1.0.0
docker tag IMAGE_ID_BOCA_WEB ghcr.io/joaofazolo/boca-docker/boca-web:1.0.0
docker tag IMAGE_ID_BOCA_JAIL ghcr.io/joaofazolo/boca-docker/boca-jail:1.0.0
```

* Log in into GitHub's Container Registry using your username and personal access token (details [here](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry)).

        docker login ghcr.io

* Push the container images to repository.

```bash
docker push ghcr.io/joaofazolo/boca-docker/boca-base:1.0.0
docker push ghcr.io/joaofazolo/boca-docker/boca-web:1.0.0
docker push ghcr.io/joaofazolo/boca-docker/boca-jail:1.0.0
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

Please report any issues with boca-docker at https://github.com/joaofazolo/boca-docker/issues

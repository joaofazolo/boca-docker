# boca-docker

BOCA Online Contest Administrator (known simply as BOCA) is an administration system to held programming contests (e.g., ACM-ICPC, Maratona de Programação da SBC). According to the developers, its main features are portability, concurrency control, multi-site and distributed contests, and a simple web interface (for details refer to https://www.ime.usp.br/~cassio/boca/ and https://github.com/cassiopc/boca).

BOCA is implemented mainly in PHP and makes use of a PostgreSQL database in the backend. It is a good example of a monolithic system, in which the user interface and database access are all interwoven, rather than containing architecturally separate components. The problem is compound due to the low readability and poor code structuring, which is hard to extend and has been barely updated in recent years.

The boca-docker project is a use case of how we can take advantage of microservices architecture and containerization technology (i.e., Docker) to deploy applications in a more convenient and faster way. After quite some reverse engineering, we provide a dockerized version of BOCA's main components (web app, online automated judge and database) aiming at easying the customization, extensibility and automation of the operational effort required to deploy, run and scale BOCA.

This work started as part of the undergraduate final year project carried out by João Vitor Alves Fazolo under supervision of Prof. Dr. Rodrigo Laiola Guimaraes at Universidade Federal do Espírito Santo ([UFES](https://www.ufes.br/)).

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

* Download the `docker-compose.yml` and `docker-compose.prod.yml` files, and place them in the shell current directory. Then,

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Voilà! The application should be running now.

* Open a web browser and visit the URL http://localhost:8000/boca. First, create and activate a BOCA contest (user: system | password: boca). Then, login as admin  (user: admin | password: boca) to manage users, problems, languages etc. NOTE: consider changing these passwords later on.

* The autojudge will work only after restarting the boca-jail container.

```bash
docker stop docker stop boca-docker_boca-jail_1
docker start docker stop boca-docker_boca-jail_1
```

* To stop the application (considering that the shell is in the same directory):

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
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

There are many ways to customize the boca-docker application. Without trying to support every possible use case, here are just a few that we have found useful.

### Environment Variables

The boca-docker application uses several environment variables which are easy to miss. The variables required are `POSTGRES_PASSWORD` (`boca-db` service) and `BOCA_DB_SUPER_PASSWORD` (`boca-web` service), the rest are optional.

For an example, check the YAML file in the `tests/variables` folder. To run:

#### ... via docker-compose

```bash
docker-compose -f tests/variables/docker-compose.yml up -d
```

#### ... or docker stack deploy

```bash
docker stack deploy --compose-file tests/variables/docker-compose.yml boca-stack
```

**`BOCA_DB_HOST`**

This optional environment variable, which can be set in the `boca-web` and `boca-jail` services, defines the address/host name of the PostgreSQL server. This is useful if you are connecting to an external server or a docker container named something other than the default `boca-db`.

**`BOCA_DB_SUPER_USER`**

This optional environment variable is used in conjunction with `BOCA_DB_SUPER_PASSWORD` (`boca-web` service) to manage the database. This environment variable must be the superuser for PostgreSQL. If it is not specified, then the default user of `postgres` will be used.

**Note:** If specified, this parameter and the `POSTGRES_USER` variable (`boca-db` service) must be set with the same value.

**`BOCA_DB_SUPER_PASSWORD`**

This environment variable is required for the `boca-web` service (web app) to manage the database (`boca-db` service). It must not be empty or undefined. This environment variable must be the superuser password for PostgreSQL. The default superuser is defined by the `BOCA_DB_SUPER_USER` environment variable.

**Note:** It must have the same value of the `POSTGRES_PASSWORD` variable (`boca-db` service).

**`BOCA_DB_USER`** and **`BOCA_DB_PASSWORD`**

Optional in the `boca-web` and `boca-jail` services, these variables are used in conjunction to change the credentials of the unprivileged database user in the web app and online judge, respectively, that can manage the PostgreSQL database but not alter its schema. If they are not specified, then the default values will be used.

**`BOCA_DB_NAME`**

This optional environment variable can be used to define a different name for the default database that is created when the `boca-web` service is first started. If it is not specified, then a default value will be used.

**`BOCA_PASSWORD`**

This optional environment variable can be specified in the `boca-web` service (web app) to define the initial password for the system and admin users. If not set, the default value is `boca`. These passwords can be individually updated later on via the BOCA web interface.

**`BOCA_KEY`**

This optional environment variable can be specified in the `boca-web` service to set the secret key in HTTP headers. It must be any random large sequence of characters. If it is undefined, then the default value will be used.

**`POSTGRES_USER`**

This optional environment variable is used in conjunction with `POSTGRES_PASSWORD` (`boca-db` service) to set a user and its password. This variable will create the specified user with superuser power and a database with the same name. If it is not specified, then the default user of `postgres` will be used.

**Note:** Be aware that if this parameter is specified, the `BOCA_DB_SUPER_USER` variable (`boca-web` service) must be defined with the same value.

**`POSTGRES_PASSWORD`**

This environment variable is required to setup the `boca-db` service (PostgreSQL database). It must not be empty or undefined. This environment variable sets the superuser password for PostgreSQL. The default superuser is defined by the `POSTGRES_USER` environment variable.

**Note:** The `BOCA_DB_SUPER_PASSWORD` variable (`boca-web` service) must be set with the same value.

**`BOCA_WEB_HOST`**

This optional environment variable, which can be set in the `boca-jail` service, defines the address/host name of the web application. Although `boca-jail` does not interact with the `boca-web` service directly, the original configuration keeps this reference (not certain why!). Nevertheless, if set, it must be named after the web app service (default: `boca-web`).

### Docker Secrets

As an alternative to passing sensitive information via environment variables, `_FILE` may be appended to some of the previously listed environment variables, causing the initialization scripts to load the values for those variables from files present in the containers. In particular, this can be used to load passwords from Docker secrets stored in `/run/secrets/<secret_name>` files. 

Currently, this is supported for `BOCA_DB_SUPER_USER`, `BOCA_DB_SUPER_PASSWORD`, `BOCA_DB_USER`, `BOCA_DB_PASSWORD`, `BOCA_DB_NAME`, `BOCA_PASSWORD`, `BOCA_KEY`, `POSTGRES_PASSWORD`, and `POSTGRES_USER`. 

For an example, check the YAML file in the `tests/secrets` folder. To run:

#### ... via docker-compose

```bash
docker-compose -f tests/secrets/docker-compose.yml up -d
```

#### ... or docker stack deploy

```bash
docker stack deploy --compose-file tests/secrets/docker-compose.yml boca-stack
```

## HOW TO BUILD IT:

* Clone this repo and set it as your working directory:

```bash
git clone https://github.com/joaofazolo/boca-docker.git
cd boca-docker
```

* Then, compose it up with the command below (this might take a while, sit back and relax):

```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```

Follow the instructions [above](#quick-start) to set up the application.

* To stop it:

```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml down
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

Copyright 2020-2022 Universidade Federal do Espirito Santo (Ufes)

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

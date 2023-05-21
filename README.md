[![GitHub release][release_badge]][release_link]
[![Build and publish Docker images on ghcr.io workflow][build_action_badge]][build_action_link]

[release_badge]: https://img.shields.io/github/release/joaofazolo/boca-docker.svg?style=flat-square
[release_link]: https://github.com/joaofazolo/boca-docker/releases/latest "latest release"
[build_action_badge]: https://img.shields.io/github/actions/workflow/status/joaofazolo/boca-docker/ghcr-docker-build-publish.yml?branch=master&label=build&logo=github&style=flat-square
[build_action_link]: https://github.com/joaofazolo/boca-docker/actions?workflow=build "build and publish docker images"

[![Ubuntu JAMMY][ubuntu_jammy_badge]][ubuntu_jammy_link]
[![Ubuntu FOCAL][ubuntu_focal_badge]][ubuntu_focal_link]

[ubuntu_jammy_badge]: https://img.shields.io/badge/ubuntu-jammy-E95420.svg?logo=Ubuntu
[ubuntu_focal_badge]: https://img.shields.io/badge/ubuntu-focal-E95420.svg?logo=Ubuntu
[ubuntu_jammy_link]: https://hub.docker.com/_/ubuntu/tags?page=1&name=jammy "ubuntu:jammy image"
[ubuntu_focal_link]: https://hub.docker.com/_/ubuntu/tags?page=1&name=focal "ubuntu:focal image"

[![Multi-Architecture][arch_badge]][arch_link]

[arch_badge]: https://img.shields.io/badge/multi--arch-%20amd64%20|%20arm/v7%20|%20arm64/v8%20|%20ppc64le%20|%20s390x%20-lightgray.svg?logo=Docker
[arch_link]: #how-to-run-on-different-ubuntu-release-images "multi-arch images"

# :balloon: boca-docker

- [What is boca-docker?](#what-is-boca-docker)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [How To Deploy It To A Swarm](#how-to-deploy-it-to-a-swarm)
- [How To Add Custom Configuration](#how-to-add-custom-configuration)
- [How To Run On Different Ubuntu Release Images](#how-to-run-on-different-ubuntu-release-images)
- [How To Build It (For Development)](#how-to-build-it-for-development)
- [How To Publish It](#how-to-publish-it)
- [License](#license)
- [Support](#support)

## What is boca-docker?

BOCA Online Contest Administrator (known simply as BOCA) is an administration system to held programming contests (e.g., ACM-ICPC, Maratona de Programação da SBC). According to the developers, its main features are portability, concurrency control, multi-site and distributed contests, and a simple web interface (for details refer to https://www.ime.usp.br/~cassio/boca/ and https://github.com/cassiopc/boca).

BOCA is implemented mainly in PHP and makes use of a PostgreSQL database in the backend (see architecture below). It is a good example of a monolithic system, in which the user interface and database access are all interwoven, rather than containing architecturally separate components. The problem is compound due to the low readability and complex code structuring, which is hard to adapt and to extend.

The _boca-docker_ project is a use case of how we can take advantage of microservices architecture and containerization technology (i.e., Docker) to deploy applications in a more convenient and faster way (see illustration below). After quite some reverse engineering, we provide a multi-platform/arch Docker version of BOCA's main components (web app, online automated judge and database) aiming at easing the customization, extensibility and automation of the operational effort required to deploy, run and scale BOCA.

Original architecture | _boca-docker_ architecture
:-------------------------:|:-------------------------:
![Alt text](/imgs/arquitetura-boca.png?raw=true "BOCA architecture")  |  ![Alt text](/imgs/arquitetura-boca-docker.png?raw=true "boca-docker architecture")

This work started as part of the undergraduate final year project carried out by João Vitor Alves Fazolo under supervision of Prof. Dr. Rodrigo Laiola Guimaraes at Universidade Federal do Espirito Santo ([UFES](https://www.ufes.br/)).

## Requirements:

* Install [Docker Desktop](https://www.docker.com/get-started).
* Install [Git](https://github.com/git-guides/install-git) (only for building and publishing).

## Quick Start:

* Open a Terminal window and make sure the Docker engine is up and running:

```sh
# List docker images
docker images -a
# List containers
docker container ls -a
```

* Download the `docker-compose.yml` and `docker-compose.prod.yml` files, and place them in the current work directory. Then,

```sh
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Voilà! The application should be running now.

* Open a web browser and visit the URL http://localhost:8000/boca. First, create and activate a BOCA contest (user: _system_ | password: _boca_). Then, login as admin (user: _admin_ | password: _boca_) to manage users, problems, languages etc. 

> **NOTE:** consider changing these passwords later on. Find out more information on how to setup a contest [here](https://github.com/cassiopc/boca/tree/master/doc). For general questions about BOCA consider looking at this [forum](https://groups.google.com/g/boca-users).

* To stop the application (considering that the shell is in the same directory):

```sh
docker compose -f docker-compose.yml -f docker-compose.prod.yml down
```

## How To Deploy It To A Swarm:

* Create the stack (make sure Docker Engine is already running in [swarm mode](https://docs.docker.com/engine/swarm/swarm-mode/)):

```sh
docker stack deploy --compose-file docker-compose.yml -c docker-compose.prod.yml boca-stack
```

* Then, check if the stack is running:

```sh
docker stack services boca-stack
```

* Open a web browser and follow the instructions described above.

* To bring the stack down:

```sh
docker stack rm boca-stack
```

## How To Add Custom Configuration:

There are many ways to customize the _boca-docker_ application. Without trying to support every possible use case, here are just a few that we have found useful.

* **Environment Variables:** shows the correct syntax for the various ways one can change pre-defined configuration values to keep the _boca-docker_ application flexible and organized. See documentation [here](tests/env/README.md).

* **Docker Secrets:** an alternative way to passing sensitive information via environment variables, causing the initialization scripts to load the values for those variables from files present in the containers. See documentation [here](tests/secrets/README.md).

* **Networking:** shows how to add network isolation between services in the _boca-docker_ application. See documentation [here](tests/networks/README.md).

* **Volume:** demonstrates how to persist data outside BOCA's database container in order to facilitate backup, restore, and migration. See documentation [here](tests/volume/README.md).

* **Healthcheck:** allows a check to be configured in order to determine whether or not the PostgreSQL container is "healthy." This is a particularly neat use case given that the other services depend on that to work. See documentation [here](tests/healthcheck/README.md).

## How To Run On Different Ubuntu Release Images:

To run the _boca-docker_ application built on top of different versions of Ubuntu images, please edit the `docker-compose.prod.yml` file with an alternative tag from the table below.

| Tag name                                   | BOCA version | Ubuntu version | Code name       | Architecture                            |
|--------------------------------------------|--------------|----------------|-----------------|-----------------------------------------|
| latest, 1.2, 1.2-jammy, 1.2.0, 1.2.0-jammy | 1.5          | 22.04 LTS      | Jammy Jellyfish | amd64, arm/v7, arm64/v8, ppc64le, s390x |
| 1.2-focal, 1.2.0-focal                     | 1.5          | 20.04 LTS      | Focal Fossa     | amd64, arm/v7, arm64/v8, ppc64le, s390x |
| nightly, nightly-jammy                     | 1.5          | 22.04 LTS      | Jammy Jellyfish | amd64, arm/v7, arm64/v8, ppc64le, s390x |
| nightly-focal                              | 1.5          | 20.04 LTS      | Focal Fossa     | amd64, arm/v7, arm64/v8, ppc64le, s390x |

For example, to use BOCA version 1.5 running on Ubuntu 20.04 LTS (Focal Fossa) on any supported architecture:
```sh
    ...
    # web app
    boca-web:
        image: ghcr.io/joaofazolo/boca-docker/boca-web:1.2-focal
    ...

    ...
    # online judge
    boca-jail:
        image: ghcr.io/joaofazolo/boca-docker/boca-jail:1.2-focal
    ...
```

### Deprecated Image Tags

The following image tags have been deprecated and are no longer receiving updates:
- 1.1.0
- 1.0.0

## How To Build It (For Development):

* Clone this repo and set it as your working directory:

```sh
git clone https://github.com/joaofazolo/boca-docker.git
cd boca-docker
```

* Then, compose it up with the command below (this might take a while, sit back and relax):

```sh
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```

> **NOTE:** Keep in mind that these Docker images are created for and to run on the default platform (i.e. `linux/amd64`). This works for the majority of development machines and cloud providers versions. To build target-specific or multi-platform Docker images consult the [documentation](https://docs.docker.com/build/building/multi-platform/).

Follow the instructions [above](#quick-start) to set up the application.

* To stop it:

```sh
docker compose -f docker-compose.yml -f docker-compose.dev.yml down
```

* Alternatively, it is possible to build images without launching the application.

```sh
docker build -t boca-base . -f docker/dev/base/Dockerfile
docker build -t boca-web . -f docker/dev/web/Dockerfile
docker build -t boca-jail . -f docker/dev/jail/Dockerfile
```

## How To Publish It:

> **NOTE:** These instructions take into account the Docker images generated in the previous section (no multi-platform support).

* After building, set the user and image tags accordingly. The IMAGE_ID's will show up with the `docker images -a`.

```sh
docker images -a
# boca-base only necessary for development
# docker tag IMAGE_ID_BOCA_BASE ghcr.io/joaofazolo/boca-docker/boca-base:1.2.0
docker tag IMAGE_ID_BOCA_WEB ghcr.io/joaofazolo/boca-docker/boca-web:1.2.0
docker tag IMAGE_ID_BOCA_JAIL ghcr.io/joaofazolo/boca-docker/boca-jail:1.2.0
```

* Log in into GitHub's Container Registry using your username and personal access token (details [here](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry)).

        docker login ghcr.io

* Push the container images to repository.

```sh
# boca-base only necessary for development
# docker push ghcr.io/joaofazolo/boca-docker/boca-base:1.2.0
docker push ghcr.io/joaofazolo/boca-docker/boca-web:1.2.0
docker push ghcr.io/joaofazolo/boca-docker/boca-jail:1.2.0
```

## License:

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

## Support:

Please report any issues with _boca-docker_ at https://github.com/joaofazolo/boca-docker/issues

# BOCA Online Contest Administrator
Boca is an administration system to held programming contests (e.g. ACM-ICPC, Maratona de Programação da SBC). It has been designed to use php and postgresql as backends. The main desired features are: portability, concurrency control, multi-site and distributed contests, simple web interface.

https://www.ime.usp.br/~cassio/boca/

https://github.com/cassiopc/boca

# BOCA Docker
BOCA Docker is a dockerized version of BOCA and BOCA jail

# Prerequisites
Docker

# Development Enviroment
Development includes volume mapping on BOCA and postgres containers.

## Running
This will create three containers boca, boca-jail, boca-postgres
### Build base ubuntu image
```bash
docker build -t boca-base .
```
### Compose up
```bash
docker-compose -f docker-compose-dev.yml up -d --build
```

### If running for the first time
Create database
```bash
docker-compose exec boca bash -c "cd src && php private/createdb.php"   
```

### Starting BOCA jail
This is still a little clunky

```bash
docker-compose exec boca-jail boca-createjail
```

This might take some time, when you get into a loop of snap errors stop it with CTRL+C. Then run

```bash
docker-compose exec boca-jail boca-autojudge
```


# License

Copyright (C) 2020 João Vitor Alves Fazolo

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see https://www.gnu.org/licenses/.




#!/bin/bash
docker run -d -h shared --name shared.loc -p 1521:1521 owcs-install-shared
docker run -h admin --name admin.loc --link shared.loc -ti owcs-install-admin bash install.sh
docker stop shared.loc
docker commit shared.loc owcs-installed-shared
docker commit admin.loc owcs-installed-admin

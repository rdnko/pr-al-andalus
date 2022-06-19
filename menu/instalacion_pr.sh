#!/bin/bash

#Instalacion de los componentes del proyecto
#Hace falta docker por lo que primero se comprobará que está instalado
#Despues se descarga la carpeta del repositorio y se instala con los docker compose

ROJO='\033[0;31m'
VERDE='\033[0;32m'
NC='\033[0m' #Sin color

command_exists() {

	command -v "$@" > /dev/null 2>&1

}

clear

echo -e "${VERDE}Procedemos a instalar todo el proyecto ${NC}"

necesario=("docker" "docker-compose" "git" "apache2")
todo=true

echo ""

echo "Vamos a comprobar que todo lo necesario está instalado"

echo ""

for str in ${necesario[@]};
do

	if command_exists $str; 
	then
		printf "${VERDE}La aplicacion $str existe${NC}\n"


	else
		printf "${ROJO}La aplicacion $str no existe${NC}\n"
		todo=false

	fi

	echo ""
done


if ! $todo;
then
	
	echo "Faltan componentes no se puede instalar"
	echo "Salimos de la instalacion"
	exit 0

fi


echo "Está todo instalado por lo que comenzamos la instalacion del proyecto"


echo "Procedemos a instalar el stack de multimedia en Docker"

cd multimedia

mkdir nextcloud  || echo -e "\nLa carpeta nextcloud ya existe"
mkdir jellyfin || echo -e "\nLa carpeta jellyfin ya existe"


chown -R www-data:www-data nextcloud
chown -R www-data:www-data jellyfin

multimedia_file_bak="./docker-compose.yml.bak"
multimedia_file="./docker-compose.yml"



if [[ -f "./docker-compose.yml.bak" ]]; then

	echo -e "\nExiste el archivo de copia, lo recuperamos"

	cp "./docker-compose.yml.bak" "./docker-compose.yml"

else

	echo -e "\nNo exsite el archivo de copia, lo creamos"

	cp "./docker-compose.yml" "./docker-compose.yml.bak"

fi

sed -i "s/local_ip/$(hostname -I | cut -f1 -d' ' | cut -f1,2,3 -d.)/g" docker-compose.yml

docker-compose up -d

echo ""
echo "Jellyfin instalado"

status="999"

echo ""
echo "Esperamos que el servicio Nextcloud este operativo para configurarlo"
echo ""

until [ "$status" -eq "302" ]
do
status=$(curl -s --head  -w %{http_code} http://$(hostname -I | cut -f1 -d' '):8080/ -o /dev/null)
sleep 10
echo .
done

if [ "$status" -eq "302" ]
then
        printf "${VERDE}Servidor operativo${NC}\n"

        echo ""

        echo "Activamos la aplicacion para dispostivos externos en Docker"

		docker exec -u www-data proyecto-nc php occ app:enable files_external

		echo "Creamos el directorio externo compartido"

		sudo docker exec -u www-data proyecto-nc php occ files_external:create peliculas local null::null --config datadir=/externo

		echo " Asiganmos permisos al directorio dentro del contenedor para poder manejarlo"

		sudo docker exec -u 0:0 proyecto-nc chown -R www-data:www-data /externo

		chown -R www-data:www-data /media/disco

fi

echo ""
echo "Nextcloud instalado y configurado"

cd ../monitoreo

sudo docker-compose up -d


echo ""

echo "El stack de monitoreo está instalado"


echo ""

echo "Creamos la pagina que servirá de nexo para todos los servicios"

cd ../apache

sed "s/direccion_local/$(hostname -I | cut -f1 -d' ')/g" index.html > /var/www/html/index.html

cp assets -R /var/www/html/

echo "Pagina nexo creada, accede a ella con el siguiente enlace http://$(hostname -I | cut -f1 -d' ')"

#!/bin/bash

ROJO='\033[0;31m'
VERDE='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

#printf "${ROJO}Esto es una prueba de color${NC}\n"
#printf "${VERDE}Esto es una prueba de color${NC}\n"
#printf "${CYAN}Esto es una prueba de color${NC}\n"

command_exists() {

	command -v "$@" > /dev/null 2>&1

}

printf "${CYAN}Vamos a proceder lo necesario para el funcionamiento del proyecto${NC}\n"

echo ""
echo "-----------------------------------------------"
echo ""

 sudo apt-get install ca-certificates curl gnupg lsb-release || echo -e "Los requerimientos basicos ya existe"



if command_exists docker;
	then

		printf  "${VERDE}Docker ya está instalado${NC}\n"

	else

		printf  "${ROJO}Docker no esta instalado${NC}, lo instalamos:\n"

		echo ""

		echo "Creamos la carpeta que contendrá las firmas digitales"

		sudo mkdir -p /etc/apt/keyrings

		echo ""

		echo "Descargamos la firma digital de docker y la añadimos a la carpeta que creamos antes: "

		curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

		echo ""

		echo "Ahora debemos añadir el repositorio de Docker para descargarlo y tener actualizaciones oficiales"

		echo \
			"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  			$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


  		echo ""

  		echo "------------------ Actaulizamos los paquetes y descargamos docker -------------------"
		apt-get update
		apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
		
		echo ""

		echo "Ahora debemos añadir el usuario al grupo de Docker para poder usarlo"

		usermod -aG docker $(whoami) 

		echo ""
		echo "Instalacion del Docker Engine finalizado"

		echo ""

		
		#chmod 666 /var/run/docker.soc

fi

echo ""

printf "${CYAN}Comprobamos que el Docker Compose está instalado:${NC}\n"


if command_exists docker-compose;

	then

		printf  "${VERDE}Docker compose se encuentra instalado${NC}\n"


	else

		printf  "${ROJO}Docker compose se encuentra instalado, lo instalamos${NC}\n"
		apt-get install docker-compose -y
fi

echo ""

printf "${CYAN}Comprobamos que está instalado Git ${NC}\n"



if ! command_exists git;

then

	printf  "${ROJO}No disponemos de Git, procedemos a instalarlo:${NC}\n"
	
	apt install git -y

else

	printf  "${VERDE}Git se encuentra instalado.${NC}\n"

fi

echo ""

printf "${CYAN}Comprobamos que está instalado el servidor web Apache2 ${NC}\n"



if ! command_exists apache2;

then

	printf  "${ROJO}No disponemos de Apache2, procedemos a instalarlo:${NC}\n"
	
	apt install apache2 -y

else

	printf  "${VERDE}Apache2 se encuentra instalado.${NC}\n"

fi

echo "Ahora debemos añadir el usuario por defecto al grupo de Docker para poder usarlo, será el usuario $(id -nu 1000)"

usermod -aG docker $(id -nu 1000) 

echo "Establecemos que Docker se encienda al enceder el equipo"
systemctl enable docker

echo ""
echo "Comenzamos el servicio de Docker ahora."
systemctl start docker

exit 1





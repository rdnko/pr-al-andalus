#!/bin/bash/

#Esto será el menu general para todas las funciones.

CYAN=$'\033[0;36m'
ROJO=$'\033[1;31m'
NC=$'\033[0m'


command_exists() {

	command -v "$@" > /dev/null 2>&1

}

clear



if [[ $EUID != 0 ]]; then
    echo "${ROJO}Por favor ejecuta el script como root escribiendo el comando sudo al principio${NC}" >&2
    echo -e "\nSaliendo"
    exit 1
fi



if [ ${PWD##*/} = "pr-al-andalus" ] || [ -d "pr-al-andalus" ]; 

then

	echo -e "\nEstamos en el sitio adecuado"
	clear

else

	echo -e "\nEl proyecto no existe, lo descargamos del repositorio Git"

	if command_exists git ;
	then

		printf  "${VERDE}Git se encuentra instalado${NC}\n"


	else

		printf  "${ROJO}Git no se encuentra instalado, lo instalamos para descargar repositorio${NC}\n"
		apt install git -y
	fi

	git clone https://github.com/rdnko/pr-al-andalus.git

	echo "Una vez descargado ejecuta este mismo script que viene dentro."
	echo "Gracias"

	exit 1
fi

echo ""

echo -e "\n${CYAN}Bienvenido al proyecto Pi, auto implementacion de un servidor multiproposito"
echo -e "desarrollado por Bogdan Rudenko como proyecto para I.E.S. Al Andalus ${NC}"

echo -e "\n---------------------------------------------------------------------------------------"

echo -e "Este es el menu principal:"

PS3="Elge una opcion: "

select opcion in "Solo Instalacion" "Solo Securizar" "Hacer todo" "Herramientas adicionales" "Salir"
	do
		case "$REPLY" in

		1 ) echo "Procedemos a realizar la instalacion del entorno"
			clear

			bash ./menu/instalacion_req.sh || echo "${ROJO}Ha ocurrido un error instalando los requerimientos${NC}"

			bash ./menu/instalacion_pr.sh || echo "${ROJO}Ha ocurrido un error instalando el entorno${NC}"

			break;;

		2 ) echo "Procedemos a solo securizar el dispositivo";

			bash ./menu/menu_sec.sh || echo "${ROJO}Ha ocurrido un error al securizar${NC}"
			break;;

		3 ) echo "Procedemos a realizar la instalacion y securizar el dispositivo"; 
				
				bash ./menu/instalacion_req.sh || echo "${ROJO}Ha ocurrido un error instalando los requerimientos${NC}"
				bash ./menu/instalacion_pr.sh || echo "${ROJO}Ha ocurrido un error instalando el entorno${NC}"
				bash ./menu/securizar_actaulizaciones.sh || echo "${ROJO}Ha ocurrido un error securizando las actualizaciones${NC}"
				bash ./menu/securizar_sistema.sh || echo "${ROJO}Ha ocurrido un error securizando el sistema${NC}"
				bash ./menu/securizar_ssh.sh || echo "${ROJO}Ha ocurrido un error securizando el servicio ssh${NC}"

			break;;

		4 ) echo "Te enseñamos algunas herramientas utiles";

			bash ./menu/herramientas.sh || echo "${ROJO}Ha ocurrido un error ejecutando las herramientas${NC}"
			

			break;;
		5) echo -e "\nHas elegido salir, salimos";
			echo -e "\n${VERDE}Adios, gracias${NC}"
			exit 1
			break;;

		*) echo "Opcion incorrecta, selecciona una valida.";continue;;

		esac

	done

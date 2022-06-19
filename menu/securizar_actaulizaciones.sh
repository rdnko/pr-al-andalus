#!/bin/bash

#Con este script buscamos securizar el dispositivo ya que contendrá datos sensibles

CYAN=$'\033[0;36m'
ROJO=$'\033[1;31m'
NC=$'\033[0m'

config_file="/etc/apt/apt.conf.d/50unattended-upgrades"
config_file_bak="/etc/apt/apt.conf.d/50unattended-upgrades.bak"

clear 

echo -e "\nLo primero es actualizar nuestro sistema de manera completa"

echo -e "\nActualizacion completa del sistema:"

sudo apt update && sudo apt-get full-upgrade -y

echo ""

echo -e "\nAhora instalaremos el servicio que nos permitirá obtener actualizaciones de manera desatendidas"

sudo apt install unattended-upgrades

echo -e "\nActivamos las actualizaciones desatendidas"

dpkg-reconfigure -plow unattended-upgrades

echo -e "\nUna vez activado realizamos unos ajustes"


if [[ -f $config_file_bak ]]; then
    echo "${CYAN}Existe un archivo de copia de seguridad del archivo${NC}" >&2
    
    PS3="Desea recuperar el archivo original o seguir con la configuracion? "

    select opcion in "Recuperar" "Continuar" "Salir"
		do
			case $REPLY in

				1) echo "Se procede a recuperar el archivo original";
						
						cp $config_file_bak $config_file

						echo -e "\nArchivo orignal recuperado"

						echo -e "\nSalimos de la automatizacion"

						exit 1
						
					 break;;
				
				2) echo "Seguimos con el script de configuracion"; break;;

				3) echo "Salimos del script"; exit 1; break;;

				*) echo "Entrada incorrecta, intenta otra vez"; continue;;
			esac
		done

else
	echo "No existe copia de seguridad de, realizamos la copia"
    cp $config_file $config_file_bak || {
        echo "${ROJO}Ha ocurrido un error" >&2
        echo "${CYAN}Realiza la copia manualmente, no recomndamos seguir sin copia$NC"
        exit 1
    }

fi

echo -e "\nAñadimos el paquete Docker para que busque sus actualizaciones"

sed -i 's/"origin=Debian,codename=${distro_codename}-security,label=Debian-Security";/"Docker: Docker CE ";/' "$config_file"

echo -e "\nActivamos la opcion de recibir todas las actualizaciones, hasta las opcionales"

sed -i 's/.*"origin=Debian,codename=${distro_codename}-updates";/\t"origin=Debian,codename=${distro_codename}-updates";/' "$config_file"

echo -e "\nEjecutamos un comando que nos mostrará si está funcional y cada cuanto se ejecuta, en nuestro caso hemos dejado gran parte por defecto por lo que será 1 dia"

apt-config dump APT::Periodic::Unattended-Upgrade


exit 1





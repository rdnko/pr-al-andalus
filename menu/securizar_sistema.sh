#!/bin/bash/

CYAN=$'\033[0;36m'
ROJO=$'\033[1;31m'
NC=$'\033[0m'

config_file="/etc/sudoers.d/010_pi-nopasswd"
config_file_bak="/etc/sudoers.d/010_pi-nopasswd.bak"

clear

echo -e "En este script configuraremos apartados mas especificos del sistema"
echo -e "que optimizaran su funcionamiento y mejoraran su seguridad"

echo -e "\nPrimero configuraremos que el servidor se reincie por la noche, para aplicar actualizaciones"
echo "y mejorará el rendimiento del dispositivo"


echo "0 3 * * * /sbin/shutdown -r now" > /var/spool/cron/crontabs/root

echo -e "\n${CYAN}Si quieres poner una hora personalizada usa el comando sudo crontab -e y cambia el 3 ${NC}"

echo "Por ultimo, ahora mismo al usar comando de super usuario no se requiere contraseña"
echo "se recomienda que esté activa siempre"

PS3="Desea activar la contraseña para las acciones especiales? "

select opcion in "Activar" "Dejar como está" "Recuperar" "Salir"
		do
			case $REPLY in

				1) echo "Se procede a activar la contraseña";
						

						if [[ ! -f $config_file_bak ]] 
						then

							echo -e "\nPrimero realizamos copia de de seguridad "

							cp $config_file $config_file_bak
						fi
						
						sed -i 's/NOPASSWD: ALL/PASSWD: ALL/g' "$config_file"
						
					 break;;
				
				2) echo "Lo dejamos como está"; break;;

				3) echo "Recuperamos como estaba antes" 
					
					if [[ -f $config_file_bak ]] 
						then

							echo -e "\nRecuperamos ela rchivo original"

							cp $config_file_bak $config_file

						else

							echo -e "\nNo existe copia de seguridad"

						fi

						 break;;

				*) echo "Entrada incorrecta, intenta otra vez"; continue;;
			esac
		done

echo -e "\nConfiguracion terminada"

exit 1





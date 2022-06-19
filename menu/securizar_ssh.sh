#!/bin/bash/

#Con este script se busca configurar el servicio SSH para que sea mas seguro

config_file_bak="/etc/ssh/sshd_config.bak"
config_file="/etc/ssh/sshd_config"
CYAN=$'\033[0;36m'
ROJO=$'\033[1;31m'
NC=$'\033[0m'
IP=$(hostname -I | cut -f1 -d' ')


## Comprobamos que existe el archivo de configuracion

clear

echo -e "${CYAN}Procedemos a securizar els ervicio SSH${NC}"

echo -e "\nComprobamos que el archivo de configuracion existe"

if [[ ! -f $config_file ]]; then
    echo "${ROJO}El archivo 'ssd_config' no existe" >&2
    echo -e "\nSaliendo"
    exit 1
fi

if [[ -f $config_file_bak ]]; then
    echo "${CYAN}Existe un archivo de copia de seguridad del archivo$NC" >&2
    
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
	echo "No existe copia de seguridad de 'sshd_config', realizamos la copia"
    cp $config_file $config_file_bak || {
        echo "${ROJO}Ha ocurrido un error" >&2
        echo "${CYAN}Realiza la copia manualmente, no recomndamos seguir sin copia$NC"
        exit 1
    }

fi



read -rp "Vamos a proceder a securizar el servicio SSH ya que es la unica ventand de acceso al dispositivo. Pulsa [Enter] para continuar."

## Hacemos copia de seguridad del archivo de configuracion 'sshd_config' si'sshd_config.bak' noe xiste.
if [[ ! -f $config_file_bak ]]; then
    echo "Haciendo copia de seguridad de 'sshd_config'"
    cp $config_file $config_fil|| {
        echo "${ROJO}Ha ocurrido un error" >&2
        echo "${CYAN}Realiza la copia manualmente, no recomndamos seguir sin copia$NC"
        exit 1
    }
fi


#
echo "Configuramos Port a 2200, cambiamos el puerto de acceso al dispositivo ahora el acceso se realizará mediante el comando $CYAN shh tusuario@$IP -p 2200$NC"
sed -i 's/\(#\)\?Port\(.*\)\?/Port 2200/g' "$config_file" || echo "${ROJO}Ha ocurrido un error configurando Port 2200$NC"

echo "Configuramos LoginGraceTime a 30 segundos, se refiere al tiempo que la pantalla de inicio de sesion permanece activa"
sed -i 's/\(#\)\?LoginGraceTime\(.*\)\?/LoginGraceTime 30/g' "$config_file" || echo "${ROJO}Ha ocurrido un error configurando LoginGraceTime 30$NC"

echo "Configuramos PermitRootLogin a no, denegará la conexion del usuario root, el mas poderoso"
sed -i 's/\(#\)\?PermitRootLogin\(.*\)\?/PermitRootLogin no/g' "$config_file" || echo "${ROJO}Ha ocurrido un error configurando PermitRootLogin no$NC"

echo "Configuramos MaxAuthTries a 3, signfica que se permite 3 intentos de conexion fallidos"
sed -i 's/\(#\)\?MaxAuthTries\(.*\)\?/MaxAuthTries 3/g' "$config_file" || echo "${ROJO}Ha ocurrido un error configurando MaxAuthTries 3$NC"

echo "Configuramos MaxSessions a 2, significa que como maximo se permite dos sesiones simultaneas"
sed -i 's/\(#\)\?MaxSessions\(.*\)\?/MaxSessions 2/g' "$config_file" || echo "${ROJO}Ha ocurrido un error configurando MaxSessions 2$NC"

echo "Configuramos PermitEmptyPasswords a no, denegamos el intento de conexiones con el campo de contraseña vacio"
sed -i 's/\(#\)\?PermitEmptyPasswords\(.*\)\?/PermitEmptyPasswords no/g' "$config_file" || echo "${ROJO}Ha ocurrido un error configurando PermitEmptyPasswords no$NC"

echo "Configuramos ChallengeResponseAuthentication a no, no permitermos el acceso al servicio al responder una pregunta"
sed -i 's/\(#\)\?ChallengeResponseAuthentication\(.*\)\?/ChallengeResponseAuthentication no/g' "$config_file" || echo "${ROJO}Ha ocurrido un error configurando ChallengeResponseAuthentication no$NC"

echo "Configuramos Compression a no, la conexion no se comprimirá"
sed -i 's/\(#\)\?Compression\(.*\)\?/Compression no/g' "$config_file" || echo "${ROJO}Ha ocurrido un error configurando Compression no$NC"

echo "Configuramos ClientAliveInterval a 300 segundos, la sesion permanecerá como maximo 300 segunso inactiva"
sed -i 's/\(#\)\?ClientAliveInterval\(.*\)\?/ClientAliveInterval 300/g' "$config_file" || echo "${ROJO}Ha ocurrido un error configurando ClientAliveInterval 30$NC"

echo "Configuramos ClientAliveCountMax a 2, nos preguntará dos veces si estamos activos tenniendo en cuenta el campo anterior"
sed -i 's/\(#\)\?ClientAliveCountMax\(.*\)\?/ClientAliveCountMax 2/g' "$config_file" || echo "${ROJO}Ha ocurrido un error configurando ClientAliveCountMax 2$NC"

echo -e "\nReiniciamos el servicio SSH para que se apliquen los cambios"
systemctl restart sshd

echo -e "\nTerminada la configuracion"


#### End of [ Main ]
########################################################################################


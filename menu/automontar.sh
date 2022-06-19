#!/bin/sh

modificar_fstab () {
	
	echo "UUID=$m_uuid	$m_dest	ext4	defaults	0	0" >> /etc/fstab

	printf "${GREEN}'/etc/fstab' actualizado!${NC}\n"
}

establecer_tipo () {
	echo "Configurando '$1' para realizar su montaje..."
	echo "Type: $(sudo blkid -o value -s TYPE $1)"

	m_type=$(sudo blkid -o value -s TYPE $1)
	dispo_selec=$(sudo blkid -o device $1)

	echo "$(dispo_selec)"
	
	echo ""

	if [ $m_type == "ext4" ];
	then
		echo "El formato del dispositivo es correcto"
	else
		echo "Para el uso correcto es necesario."
		echo "Si se cofirma se perderán todos los datos que hay"
		echo ""

		echo "Selecciona la opcion"

		PS3="Aplicar formato ext4?: "

		select opcion in "Confirmar" "Cancelar"
		do
			case $REPLY in

				1) echo "Se procede a aplciar el formato ext4";
						
						mkfs -t ext4 $dispo_selec

						echo "Formato aplicado"
						
					 break;;
				
				2) echo "No se aplica el formato"; break;;

				*) echo "Entrada incorrecta, intenta otra vez"; continue;;
			esac
		done
	fi

	establecer_ruta_montaje
}

establecer_ruta_montaje () {
	read -p "Introduce la ruta de montaje: " dest
	if [ $dest != "" ] && [ -d $dest ]; then
		echo "La ruta existe!"
		m_dest=$dest
		modificar_fstab
	else
		printf "${RED}Ruta '$dest' no existe!${NC}\n"
	fi
}

confirmar () {
	title="Seleccionado '$1'"
	prompt="Montar automaticamente '$1' ?"

	echo "$title"
	PS3="$prompt "
	select opcion in "Si" "Salir"
	do
		case "$REPLY" in

		1 ) echo "Confirmado";establecer_tipo $1;break;;

		2 ) echo "Adios!"; break;;

		*) echo "Opcion incorrecta, intenta otra vez.";continue;;

		esac

	done
}

crear_menu () {
	title="Dispositivos"
	prompt="Selecciona el dispositivo (Selecciona $(($#)) para salir):"

	echo "$title"
	PS3="$prompt "

	select option; do # in "$@" esta por defecto
		if [ "$REPLY" -gt "$#" ];
		then
			echo "Adios!"
			break;
		elif [ 1 -le "$REPLY" ] && [ "$REPLY" -le $(($#)) ];
		then
			
			m_uuid=$(echo $option | sed -e "s/^.*\((\)\(.*\)\()\).*$/\2/")
			
			confirmar $option
			break;
		else
			printf "${RED}Entrada incorrecta 1-$#${NC}\n"
		fi
	done
}

seleccionar_dispositivo () {
	declare -a dispositivos

	i=0

	for DEVICE in $(sudo blkid -o device); do

	        LABEL=$(sudo blkid -o value -s LABEL $DEVICE)
	        UUID=$(sudo blkid -o value -s UUID $DEVICE)
	        dispositivos+=("$DEVICE = $LABEL ($UUID)")
	        let "i++"
	done


	crear_menu "${dispositivos[@]}"}
}

seleccionar_dispositivo

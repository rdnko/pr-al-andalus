#!/bin/bash

#Menu para la securizacion

echo ""
echo "----------------------------------------"
echo ""


PS3="Que deseas securizar?: "

select securizar in "Securizar instalaciones" "Securizar sistema" "Securizar SSH" "Securizar todo a la vez" "Salir"
	do
		case $REPLY in
		1) echo "Securizamos solo las instalaciones";
	
			bash ./menu/securizar_actaulizaciones.sh || echo "${ROJO}Ha ocurrido un error securizando las actualizaciones${NC}"
		
		 	break;;
		2) echo "Securizamos solo el sistema"; 
			bash ./menu/securizar_sistema.sh || echo "${ROJO}Ha ocurrido un error securizando el sistema${NC}"
			break;;
		3) echo "Securizamos solo SSH"; 
			bash ./menu/securizar_ssh.sh || echo "${ROJO}Ha ocurrido un error securizando el servicio ssh${NC}"
			break;;
		4) echo "Securizamos todo"; 
			bash ./menu/securizar_actaulizaciones.sh || echo "${ROJO}Ha ocurrido un error securizando las actualizaciones${NC}"
			bash ./menu/securizar_sistema.sh || echo "${ROJO}Ha ocurrido un error securizando el sistema${NC}"
			bash ./menu/securizar_ssh.sh || echo "${ROJO}Ha ocurrido un error securizando el servicio ssh${NC}"
			break;;
		5) echo "Salimos"; break;;							
		*) echo "Entrada incorrecta, intenta otra vez"; continue;;
		esac
	done

	exit 1
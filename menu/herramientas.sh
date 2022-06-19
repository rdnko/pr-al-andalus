#!/bin/bash/

#Menu para las herramientas interesantes del proyecto

clear

echo -e "Te mostramos algunas herramientas utiles para el servicio"

echo "1 - Montar automaticamente la unidad extraible que hayas añadido"
echo "2 - Reiniciar los contendores"
echo "3 - Borrar todos los contenedores"
echo "4 - Borrar los volumenes"
echo "5 - Reiniciar el servicio Docker (encargado de mantener los servicios)"
echo "6 - Reiniciar el sevicio Apache (encargado de la pagina web nexo)"
echo "7 - Reinciar el dispositivo ahora"
echo "8 - Iniciar los contenedores en caso de estar apagados"
echo "9 - Salir"

echo ""

PS3="Elige una opcion: "

select opcion in "Automontar" "Reinciar contenedores" "Borrar contenedores" "Borrar volumenes" "Reiniciar Docker" "Reiniciar apache" "Reiniciar dispositivo" "Iniciar contendores" "Salir"
	do
		case "$REPLY" in

		1 ) echo -e "Has elegido montar automaticamente tu disco duro";
			
			echo ""

			bash ./menu/automontar.sh

			echo ""

			break;;

		2 ) echo "Reinciamos todos los contenedores";
			docker restart $(docker ps -q)
			echo ""

			echo "Contenedores reiniciados"
			break;;

		3) echo "Has elegido borrar los contenedores, los datos no se perderan.";

			echo ""

			PS3="Estas seguro?"

			select opcion in "Seguro" "Salir"
			do
			case $REPLY in

				1) echo "Borramos los contenedores activos";
					
					docker rm -f $(docker ps -a -q)

					echo -e "\nContenedores borrados"
					
					break;;
				
				2) echo "\nSalimos"; break;;

				*) echo "Entrada incorrecta, intenta otra vez"; continue;;
			esac
		done
			
			break;;


		4) echo "Vamos a borrar todos los volumenes activos, se perderan los datos";
				
			PS3="Estas seguro?"

			select opcion in "Seguro" "Salir"
			do
			case $REPLY in

				1) echo "Borramos los contenedores activos";
					
					docker volume rm $(docker volume ls -q)

					echo -e "\nVoluemens borrados"
					
					break;;
				
				2) echo "\nSalimos"; break;;

				*) echo "Entrada incorrecta, intenta otra vez"; continue;;
			esac
			done

			break;;


		5) echo "Reiniciaremos el servicio Docker";
			
			systemctl restart Docker

			break;;

		6) echo "Reinciaremos el servicio Apache";
			
			systemctl restart apache2

			break;;

		7) echo "Reiniciaremos el dispositivo ahora, se perderá la conexion";

			reboot -h now

			break;;

		8) echo "Activar los contenedores si estan parados"

			PS3="Que contenedores quieres reiniciar"

			select opcion in "Multimedia" "Monitorizacion" "Todos" "Salir"
			do
			case $REPLY in

				1) echo "Iniciremoas el conjunto multimedia";
					
					cd ../multimedia

					docker-compose up -d

					echo -e "\nContenedor activado"
					
					break;;
				
				2) echo "Iniciremoas el conjunto monitorizacion";
					
					cd ../monitoreo

					docker-compose up -d

					echo -e "\nContenedor activado"
					
					break;;

				3) echo "Iniciremoas los dos conjuntos";
					
					cd ../monitoreo

					docker-compose up -d

					echo -e "\nContenedor monitorizacion activado"

					cd ../multimedia

					docker-compose up -d

					echo -e "\nContenedor multimedia activado"
					
					break;;

				4) echo "Cancelamos la accion"; break;;


				*) echo "Entrada incorrecta, intenta otra vez"; continue;;
			esac
			done

			break;;

		9) echo "Has elegido salir"; break;;


		*) echo "Opcion incorrecta, intenta otra vez.";continue;;

		esac

	done

echo -e "\nGracias, salimos del script"

exit 1
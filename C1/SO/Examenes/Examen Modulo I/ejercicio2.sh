#!/bin/bash
# Autor:
# 	Sergio Quijano Rey
# 	sergiquijano@gmail.com
# Descripcion:
# 	Ejercicio 2 del examen del Modulo I


# El sistema de archivos con el que vamos a trabajar suponemos que va a ser
# /dev/sda1 con formato ext4 y lo vamos a montar en /datos

# El sistema de archivos debe ser montado solamente los sábados de 8.00 a 14.00h
# en modo lectura y escritura y de lunes a viernes de 8.00h a 22.00h en modo lectura
# Para ello vamos a necesitar usar cron para el montaje y desmontaje

# Lanzo el demonio cron
service crond start		# Lanzarlo ahora
service crond enable		# Que se lance al iniciar el sistema
service crond status		# Para comprobar que esta funcionando correctamente

# Edito la tabla de cron, desde modo root
crontable -e

# Escribo dentro de la tabla lo siguiente:

# Archivo crontab del root
#========================================================
# min hora dia-mes mes diasemana orden
0 8 * * 5 montajesabado
0 14 * * 5 desmontaje
0 8 * * 1-5 montajesemana
0 22 * * 1-5 desmontaje
#========================================================

# El script de desmontaje va a ser el siguiente:
#========================================================
#!/bin/bash
umount -f /data # Lo desmonto aunque el dispositivo este busy
#========================================================

# El script para montajesabado seria
#========================================================
#!/bin/bash
# Script para montar los sabados
mount -w -t ext4 -o usrquota,grpquota /dev/sda1 /data
# -w para lectura escritura
# -t ext4 para especificar el sistema de archivos
# -o usrquota,grpquota para habilitar el sistema de cuotas

# Lanzo un script para que realice los pasos posteriores
./montarquota
#========================================================

# El script para el montajesemana seria
#========================================================
#!/bin/bash
# Script para montar los dias laborales
mount -r -t ext4 -o usrquota,grpquota /dev/sda1 /data
# -r para lectura unicamente
# -t ext4 para especificar el sistema de archivos
# -o usrquota,grpquota para habilitar el sistema de cuotas

# Lanzo un script para que realice los pasos posteriores
./montarquota
#========================================================

# En vez de crear dos scripts, podria editar la tabla /etc/fstab. No lo hago porque
# esto provocaría montajes automaticos al arrancar el sistema, y me da menos flexibilidad
# que los scripts invocados por cron para tener un tipo de montaje u otro dependiendo
# del dia de la semana y la hora.
# Notar tambien que desde cron tendría que especificar la ruta absoluta de los scripts
# para que funcionasen de forma correcta.

# Ahora, desde un script, hago el resto del proceso para las cuotas
#========================================================
#!/bin/bash
# Realiza el proceso de montar quotas

# Creo los archivos para administrar las quotas
quotacheck -acug /datos
quotacheck -avug /datos

# Se activa el sistema de quotas
quotaon -a

# Establezco los parametros segun quiera el administrador de sistemas para cada usuario
for usr in usuario1 usuario2 usuario3
do
	edquota $usr
done

# Quiero que los limites sean soft
edquota -e
#========================================================

# Al ejecutar esta serie de scripts, se nos va a pedir, una unica vez, a traves del
# prompt que introduzcamos los parametros de las quotas, debido al edquota $user
# Con todo esto ya habríamos establecido lo pedido en el ejercicio2


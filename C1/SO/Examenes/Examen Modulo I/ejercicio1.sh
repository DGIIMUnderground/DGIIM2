#!/bin/bash
# Autor:
# 	Sergio Quijano Rey
# 	sergiquijano@gmail.com
# Descripcion:
# 	Ejercicio 1 del examen del lunes del modulo I

# Creo los tres usuarios como se especifica, creando sus directorios home correspondientes
adduser usuario1
adduser usuario2
adduser usuario3

# Creo los tres directorios
mkdir /home/usuario1/directorio1
mkdir /home/usuario2/directorio2
mkdir /home/usuario3/directorio3

# Creo los tres archivos
touch /home/usuario1/directorio1/datosUser1
touch /home/usuario2/directorio2/datosUser2
touch /home/usuario3/directorio3/datosUser3

# La estructura de ficheros es la correcta:
#[root@localhost ~]# ls -R /home
#/home:
#usuario1  usuario2  usuario3
#
#/home/usuario1:
#directorio1
#
#/home/usuario1/directorio1:
#datosUser1
#
#/home/usuario2:
#directorio2
#
#/home/usuario2/directorio2:
#datosUser2
#
#/home/usuario3:
#directorio3
#
#/home/usuario3/directorio3:
#datosUser3

# Creo un grupo para los tres usuarios para trabajar de forma mas comoda con los
# archivos del usuario1 y usuario3
groudadd usuarios
gpasswd -a usuario1 usuarios
gpasswd -a usuario2 usuarios
gpasswd -a usuario3 usuarios

# Creo un grupo para trabajar con el archivo2 de forma mas comoda
groupadd exclusivos
gpasswd -a usuario1 exclusivos
gpasswd -a usuario2 exclusivos

# Cambio el grupo para los archivos de los usuarios 1 y 2
chgrp usuarios /home/usuario3/directorio3/datosUser3

# Cambio el grupo para el archivo del usuario2
chgrp exclusivos /home/usuario2/directorio2/datosUser2

# Doy los permisos para el primer archivo
chmod u+rwx /home/usuario1/directorio1/datosUser1
chmod g+rx /home/usuario1/directorio1/datosUser1
chmod g-x /home/usuario1/directorio1/datosUser1
chmod o-rwx /home/usuario1/directorio1/datosUser1

# Estas ordenes son equivalentes a:
chmod 760 /home/usuario1/directorio1/datosUser1

# Doy los permisos para el segundo archivo
chmod u+rw /home/usuario2/directorio2/datosUser2
chmod u-x /home/usuario2/directorio2/datosUser2
chmod g+rw /home/usuario2/directorio2/datosUser2
chmod g-x /home/usuario2/directorio2/datosUser2
chmod o+r /home/usuario2/directorio2/datosUser2
chmod o-wx /home/usuario2/directorio2/datosUser2

# Estas ordenes son equivalentes a:
chmod 664 /home/usuario2/directorio2/datosUser2


# Doy los permisos para el tercer archivo
chmod u+rw /home/usuario3/directorio3/datosUser3
chmod u-x /home/usuario3/directorio3/datosUser3
chmod g+rw /home/usuario3/directorio3/datosUser3
chmod g-x /home/usuario3/directorio3/datosUser3
chmod o+r /home/usuario3/directorio3/datosUser3
chmod o-x /home/usuario3/directorio3/datosUser3

# Estas ordenes son equivalentes a:
chmod 664 /home/usuario3/directorio3/datosUser3

# Cambio los permisos de los directorios del usario2, quitando el campo x quito
# la posibilidad de busqueda o listado. En el ejercicio no queda claro si se quiere
# que el grupo y otros puedan leer y escribir, asi que al grupo le doy permiso de 
# lectura y escritura y a otros solo lecutra. Lo importante es que no puedan listar
# y eso se hace quitando los permisos de ejecucion, como ya he comentado
chmod u=rwx /home/usuario2/directorio2
chmod g=rw /home/usuario2/directorio2 	# Quito el permiso de busqueda y escritura
chmod o=r /home/usuario2/directorio2	# Quito el permiso de busqueda y escritura

# Estas ordenes son equivalentes a:
chmod 764 /home/usuario2/directorio2


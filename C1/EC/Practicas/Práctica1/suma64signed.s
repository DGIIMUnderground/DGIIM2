.section .data
	.macro linea
		.int 1, 2, -3, -4					#Para la lista, he usado 4 valores que se repiten cíclicamente
									#8 veces, dando lugar a los 32 valores que buscamos.
	.endm
lista: .irpc i, 12345678
		linea
	.endr
longlista:	.int 32							#La longitud de la lista es 32, aunque para precisar más se podría
									#poner (.-lista)/4, que es equivalente a restarle a la dirección actual
									#la de lista, y dividirlo entre el número de bytes que ocupa cada entero.

resultado:	.quad -1 						#Variable de tipo quad (long) donde se guardará el resultado de 64 bits.

.section .text
_start:	.global _start							#Sección donde empieza el código, equiparable al main() en C.


	mov    $lista, %ebx						#Se guarda la dirección donde empieza lista en %ebx.
	mov	longlista, %ecx						#Se guarda la longitud de lista anteriormente descrita en %ecx.
	call suma							#Llamada a la función suma.
	mov %eax, resultado						#Una vez calculado el resultado, que está guardado en EDX:EAX, se mueve
									#parte del a la variable resultado, que ocupa el doble que un entero común.
	mov %edx, resultado+4

	mov $1, %eax							#Ajuste final y fin de programa
	mov $0, %ebx
	int $0x80

suma:									#Función suma

	push %ebp							#Se le hace un push a %ebp para usarlo en la función preservando su valor.
									#Se inicializan a 0 los registros que usaremos.
	mov $0, %eax	#miembro de la lista
	mov $0, %edi	#Acumulador de acarreos
	mov $0, %edx	#EAX extendido
	mov $0, %esi	#Iterador
	mov $0, %ebp	#Acumulador

bucle:									#Bucle usado para hacer la suma.

	mov (%ebx,%esi,4), %eax						#Se guarda en %eax lo que haya en la posición de memoria
									#%ebx+4*%esi, recordemos que %ebx guarda la dirección de inicio de lista y
									#%esi es el índice.
	cdq								#cdq extiende por defecto %eax a EDX:EAX, se usa para la doble precisión.
	add %eax, %ebp							#Se suman las cifras menos significativas al acumulador
	adc %edx, %edi							#Se suman las cifras más significativas y el acarreo al acumulador de acarreos

	inc       %esi							#Incremento del índice
	cmp  %esi,%ecx							#Condición de salida del bucle, equiparable a indice==longlista en C.
	jne bucle
	
	mov %edi, %edx							#Se coloca el valor provisional de la suma en EDX:EAX
	mov %ebp, %eax
	
	pop %ebp							#Se le hace un pop a %ebp para recuperar su valor antes de ser llamado por
									#función.
	ret								#Retorno de la función
	
	#################################
	###Juan Antonio Villegas Recio###
	########Octubre de 2017##########
	#################################

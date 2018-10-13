	# Este programilla suma una lista de números
	# Blanca
	# warming: Violación de segmento (`core' generado)
	# qeu probablemente provenga de: en imprime_dato_lista
	# 12/10/2018

	.section .data

lista:	.int 1,2,3
tam_lista:	.int (.-lista)/4 # el tamaño de la lista lo calculamos con:
				 # ( dir actual ( . ) - dir lista) / tamaño bytes enteros	
resultado:	.int
mensaje:	.ascii "El resultado de sumar es %u \n\0"
dato_ms:	.ascii "%u\0"
fin_ms:		.ascii	"\n\0"

	.section .text
main:	.global main
	mov $lista, %ebx        # muevo la posición del primer elemento
	mov tam_lista, %ecx 	# tengo en cuenta el tamaño
	call suma		# llamada de subrutina %eax tendrá resultado

	call imprime

	# convenio de finalización
	mov $1, %eax	
	mov $0, %ebx
	int $0x80

	

suma:
	push %edx		# guardamos en pila el contenido de %edx
	mov $0, %eax		# ponemos el registro a cero, lo utilizaremos de ACUMULADOR
	mov $0, %edx 		# a 0, lo utilizaré de CONTADOR

bucle:
	add (%ebx,%edx,4), %eax # ACUMULADOR = (primer elemento lista   (ebx) + contador (edx)*tamaño_cada dato(4) )
	inc %edx 		# CONTADOR++
	cmp %edx, %ecx	
	jne bucle 		# contador != tam-lista

	pop %edx		# recuperamos de la pila el contenido de %edx 
	ret 			# retorno de la subrutina 
	
imprime:
	#imprime resultado de %eax, es decir la sumatoria
	#call imprime_dato_lista
	
	push %eax
	push $mensaje
	call printf
	add $8, %esp

	#procedo a mostrar los números de la lista: 
	push %edx  	#CONTADOR
	mov $0, %edx 	# de 0 hasta ecx (tam lista)
	
imprime_dato_lista:
	
	mov (%ebx, %edx, 4), %esi  	#llevo el valor de la lista a imprimir
	push %esi
	push $dato_ms		# preparo su contenido 	
	call printf
	add $8, %esp
	
	inc %edx
	cmp %edx, %ecx
	jne imprime_dato_lista

	push $fin_ms
	call printf
	add $4, %esp

	pop %edx

	ret
	

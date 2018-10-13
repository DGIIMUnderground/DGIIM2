	#ci Programa con el típico hola mundo
	#Blanca
	# 12/10/2018
	

	.section .data
saludo:	.ascii "Hola caracola... VIVA CULTUTRILLA\n\0 "
	
	.section .text
	
main:	 .global main
	push $saludo
	call printf 
	add $4 , %esp

	
# convenio para finalizar un programa
	mov $1, %eax
	mov $0, %ebx
	int $0x80
	

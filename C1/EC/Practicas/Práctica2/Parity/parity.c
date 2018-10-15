#include <stdio.h>	// para printf()
#include <stdlib.h>	// para exit()
#include <sys/time.h>	// para gettimeofday(), struct timeval

#define WSIZE 8*sizeof(unsigned)
#define SIZE 1<<20

unsigned lista[SIZE];
int resultado=0;


/*
Primera versión, utiliza un bucle for para calcular una a una la paridad de cada elemento.
*/
int parity1(unsigned* array, int len)
{
    int  i, j, res=0, val=0;
    for (i=0; i<len; i++){
	for (j = 0, val=0 ; j < WSIZE; j++) {
		unsigned mask=0x1 << j;						/*Aplica una máscara variable en cada iteración.*/
		val^= (array[i] & mask) != 0;				/*Comparación con la máscara*/
		
	}
	res+=val;
    }
    return res;
}


/*
Segunda versión, utiliza un bucle while para calcular una a una la paridad de cada elemento.
*/
int parity2(unsigned* array, int len)
{
    int  i, j, res=0, val=0;
    for (i=0; i<len; i++){
	j=0;
	while(j < WSIZE) {
		unsigned mask=0x1 << j;						/*El procedimiento es similar al de la v1 pero en este*/
		val^= (array[i] & mask) != 0;				/*Caso se usa un bucle while.						  */
		j++;
		
	}
	res+=val;
    }
    return res;
}


/*
Tercera versión, compara bit a bit.
*/
int parity3(unsigned* array, int len){
	int i;
	unsigned res=0, val=0, mask=0x1, x;
	for(i=0; i<len; i++){
		x=array[i];
		while(x){									/*Mientras que la variable auxiliar x no sea nula*/
			val^=x;									/*Se le hace una xor con val					 */
			x>>=1;									/*Se desplaza un bit							 */
			}
		res+=(val & mask);
		val=0;
	}
	return res;
}

/*
Cuarta versión, utiliza unas líneas en asm para calcular la paridad de cada elemento.
*/
int parity4(unsigned* array, int len){
	int i;
	unsigned res=0, val=0, mask=0x1, x;
	for(i=0; i<len; i++){
		x=array[i];
		val=0;
		asm("\n"
		".ini3:			\n\t"
			"xor %[x], %[v]	\n\t"				/*El procedimiento es similar al anterior pero el código*/
			"shr %[x]	\n\t"					/*utilizado es asm, de más bajo nivel					*/
			"jnz .ini3	\n\t"
			"and $0x1, %[v]	\n\t"
			: [v] "+r" (val)
			: [x] "r" (x)
			);		
		
		res+=val;
	}
	return res;
}

/*
Quinta versión, compara  x consigo misma desplazada unos lugares dependientes de cada iteración.
Observar que en esta versión no se necesita ninguna variable auxiliar val.
*/
int parity5(unsigned* array, int len){
	int i, j;
	unsigned res=0, mask=0x1, x;
	for(i=0; i<len; i++){
		x=array[i];
		for(j=16; j>=1; j/=2)					/*Con una variable j que en cada iteración se divide entre 2*/
			x^=x>>j;							/*a x se le hace una xor consigo misma desplazada j lugares	*/
		res+=(x & mask);						/*Se compara con la máscara a la vez que se suma			*/
	}
	return res;
}

/*
Sexta versión, el procedimiento es similar al anterior pero con unas lineas en asm.
*/
int parity6(unsigned* array, int len){
	int i, j;
	unsigned res=0, mask=0x1, x;
	for(i=0; i<len; i++){
		x=array[i];
		asm("\n"
		"mov	%[x], %%edx	\n\t"				/*Aprovechando el registro EDX y sus subregistros se realiza*/
		"shr	$0x10, %[x]	\n\t"				/*Un algoritmo similar al anterior pero usando unas lineas  */
		"xor	%[x], %%edx	\n\t"				/*En código asm que deberían mejorar la eficiencia			*/
		"shr	$0x08, %[x]	\n\t"
		"xor    %[x], %%edx	\n\t"
		"setpo  %%dl		\n\t" 				/*Para salvar la paridad usamos la instrucción SETPO		*/
		"movzx %%dl, %[x]	\n\t"
		: [x] "+r" (x)
		:
		: "edx"
		);
		res+=x;
	}
	return res;
}

void crono(int (*func)(), char* msg){
    struct timeval tv1,tv2;	// gettimeofday() secs-usecs
    long           tv_usecs;	// y sus cuentas

    gettimeofday(&tv1,NULL);
    resultado = func(lista, SIZE);
    gettimeofday(&tv2,NULL);

    tv_usecs=(tv2.tv_sec -tv1.tv_sec )*1E6+
             (tv2.tv_usec-tv1.tv_usec);
    printf("resultado = %d\t", resultado);
    printf("%s%9ld\n", msg, tv_usecs);
}

int main()
{
   int i;			// inicializar array
    for (i=0; i<SIZE; i++)	// se queda en cache
	 lista[i]=i;

    crono(parity1, "parity1 (bucle for           )");
    crono(parity2, "parity2 (bucle while         )");
    crono(parity3, "parity3 (comparacion al final)");
    crono(parity4, "parity4 (instrucciones asm   )");
    crono(parity5, "parity5 (arbol               )");
    crono(parity6, "parity6 (arbol en asm        )");
    printf("SIZE/2=%d\n", (SIZE)/2);

}


/***************************************/
/*****JUAN ANTONIO VILLEGAS RECIO*******/
/**********CURSO 2017-2018**************/
/***************************************/







   

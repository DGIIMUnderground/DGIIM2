#include <stdio.h>	// para printf()
#include <stdlib.h>	// para exit()
#include <sys/time.h>	// para gettimeofday(), struct timeval
#include <math.h>

#define WSIZE 8*sizeof(int)

#define SIZE 1<<20
unsigned lista[SIZE];

int resultado=0;

/*
Primera versión, utiliza un bucle for para calcular el peso hamming de cada elemento.
*/
int popcount1(unsigned* array, int len)
{
    int  i, j, res=0;
    for (i=0; i<len; i++){
	for (j = 0; j < WSIZE; j++) {
		unsigned mask = 0x1 << j;
		res += (array[i] & mask) != 0;
	}
    }
    return res;
}

/*
Segunda versión, utiliza un bucle while para calcular el peso hamming de cada elemento.
*/
int popcount2(unsigned* array, int len)
{
    int  i, j, res=0;
    for (i=0; i<len; i++){
	unsigned x=array[i];
		do {
			res += x & 0x1;
			x >>= 1;
		} while (x);
	}
  
    return res;
}

/*
Tercera versión, utiliza unas lineas en asm para calcular el peso hamming de cada elemento.
*/
int popcount3(unsigned* array, int len)
{
    int  i, res=0;
    for (i=0; i<len; i++){
	unsigned x =array[i];
	asm("\n"								/*El bucle while de la segunda versión se ha sustituido*/
	".ini3:		\n\t"						/*por ensamblador en línea							   */
	"shr %[x]	\n\t"
	"adc $0, %[r]	\n\t"
	"cmp $0, %[x]	\n\t"
	"jne .ini3	\n\t"


	: [r] "+r" (res)
	: [x] "r" (x)	);	
	
    }
    return res;
}

/*
Cuarta versión, calcula el popcount mediante comparaciones con una máscara diferente y sumando
a una variable auxiliar val el resultado de las comparaciones.
*/
int popcount4(unsigned* array, int len) {
	int i, k;
	int result = 0;
	for (i = 0; i < len; i++) {
		int val = 0;
		unsigned x = array[i];
		for (k = 0; k < 8; k++) {				/*El cuerpo del buvle se ha sustituido por una comparación*/
			val += x & 0x01010101; 				/*con la máscara 0x01010101 dos veces por cada elemento   */
			x >>= 1;
		}

	val += (val >> 16);							/*Usando un arbol, a val se le suma ella misma desplazada */
	val += (val >> 8);							/*16 y 8 lugares, para finalmente compararla con 0xff y   */
	result += (val & 0xff);						/*añadir el resultado de esa comparación a res			  */
	}
	return result;
}

/*
Quinta versión, escogida desde la referencia indicada por la guía de esta práctica
*/
int popcount5(unsigned* array, int len) {
	int i;
	int val, result = 0;
	int SSE_mask[] = { 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f };
	int SSE_LUTb[] = { 0x02010100, 0x03020201, 0x03020201, 0x04030302 };
	if (len & 0x3)
		printf("leyendo 128b pero len no multiplo de 4?\n");
	for (i = 0; i < len; i += 4) {
	
		asm(
			"movdqu %[x], %%xmm0 \n\t"
			"movdqu %[m], %%xmm6 \n\t"// mascara
			"movdqa %%xmm0, %%xmm1 \n\t" // dos copias de x
			"psrlw $4, %%xmm1 \n\t"
			"pand %%xmm6, %%xmm0 \n\t"//; xmm0 â€“ nibbles inferiores
			"pand %%xmm6, %%xmm1 \n\t"//; xmm1 â€“ nibbles superiores
			"movdqu %[l], %%xmm2 \n\t"//; ...como pshufb sobrescribe LUT
			"movdqa %%xmm2, %%xmm3 \n\t"//; ...queremos 2 copias
			"pshufb %%xmm0, %%xmm2 \n\t"//; xmm2 = vector popcount inferiores
			"pshufb %%xmm1, %%xmm3 \n\t"//; xmm3 = vector popcount superiores
			"paddb %%xmm2, %%xmm3 \n\t"//; xmm3 - vector popcount bytes
			"pxor %%xmm0, %%xmm0 \n\t"//; xmm0 = 0,0,0,0
			"psadbw %%xmm0, %%xmm3 \n\t"//;xmm3 = [pcnt bytes0..7|pcnt bytes8..15]
			"movhlps %%xmm3, %%xmm0 \n\t"//;xmm3 = [ 0 |pcnt bytes0..7 ]
			"paddd %%xmm3, %%xmm0 \n\t"//;xmm0 = [ no usado |pcnt bytes0..15]
			"movd %%xmm0, %[val] \n\t"

		: [val]"=r" (val)
		: [x] "m" (array[i]),
		[m] "m" (SSE_mask[0]),
		[l] "m" (SSE_LUTb[0])

		);

		result += val;
	}
	return result;
}
/*
Sexta versión, usa una instrucción propia de asm llamada POPCNT.
*/
int popcount6(unsigned * array, int len){
	int i;
	unsigned x;
	int val, res=0;
	for(i=0; i<len; i++){
		x=array[i];
		asm("popcnt %[x], %[val]"
		: [val] "=r" (val)
		: [x] "r" (x)
		);
		res+=val;
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
    printf("%s:%9ld us\n", msg, tv_usecs);
}

int main()
{
  unsigned i;
    for(i=0; i<SIZE; i++)
	lista[i]=i;
    crono(popcount1, "popcount1 (bucle for             )");
    crono(popcount2, "popcount2 (bucle while           )");
    crono(popcount3, "popcount3 (intruccion asm        )");
    crono(popcount4, "popcount4 (lenguaje C            )");
    crono(popcount5, "popcount5 (referencia de la guia )");
    crono(popcount6, "popcount6 (instruccion popcnt    )");
    printf("NBITS*SIZE/2 = %d\n", (1<<20)*20/2);

    exit(0);
}

/***************************************/
/*****JUAN ANTONIO VILLEGAS RECIO*******/
/**********CURSO 2017-2018**************/
/***************************************/
















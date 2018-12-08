# Preguntas de autoevaluación Dominios euclídeos  

## El entero de Gauss 2+3i   

### No tiene norma 5  
Ya que su norma se define como el cuadrado de su módulo. Es decir
$ N(2+3i) =(2+3i)(2-3i) = 13 $

### No es una unidad
Las unidades tienen norma 1. 

### Es un irreducible  
Por ser un entero de Gauss, pertenece a un anillo, todo anillo es un dominio de integridad. En un dominio euclideo son equivalentes ser primo o irreducible. 

Un elemnto de los enteros de Gauss es primo si y sólo si cumple alguna de estas propiedades: 
- Si su norma es congruente a uno módulo 4: 
Hemos visto que su norma es 13 = 4*3+1, por consiguiente es un irreducible. 
( Termino de enumerar el resto de casos)
- si su norma es primo si es congruente a 3 módulo 4.  

## El elemento $3 \in \math{Z}[\sqrt{-5} ]$

Tengamos presente que no todos los $ \math{Z}[\sqrt{D} ]$  son dominios de factorización única, o equivlentemente, dominio euclídeos. 
O 
### No es  primo 
Por la deficinión esencial de primo 3 | 6 pero 6 =  $( a+ \sqrt(-5) )( b- \sqrt(-5) )$ y 3 no divide a ninguno de ellos. ( Ya que ambos son irreducibles).  

## No es una unidad  
No es una unidad ya que suy norma es 9, distinto de 0. 

### Irreducible 

Supongamso que es irreducible y lleguemos a una contradicción:
si no fuera irreducible se escribiría como produzto de dos elementos del cuerpo: 
$( a+ \sqrt(-5) )( b+\sqrt(-5) ) = 3$  de donde obtendríamos las siguientes ecuaciones para conocer el valor de a y b. 

$a = -b$ y $-5 + ab = 3$ Pero ab es un número negativo por la primera ecuación y por la segunda ecuación, la suma de dos números negativos no puede ser nunca positiva, por consiguiente no existen a, b enteros. 
Y la otra posibilidad posible sería: $( a+ \sqrt(-5) )( b- \sqrt(-5) ) = 3$  En tal caso tras despejar resultaría $a = \sqrt{2}$, que no es un entero y por tanto para este caso tampoco habría solución. 
Como consecuencia 3 es un irreducible. 


## El elemento  $2 \in \math{Z}[\sqrt{-2} ]$

### No es una unidad  
Su norma es 4

### No es primo ni irreducible  
Estamos en un dominio euclídeo y su norma no es un primo en $\math{Z}$ por tanto no es un irreducible y por consiguiente tampoco un primo. 

## Para los elementos a=2+3i y b=5+i de $\mathbb {Z}[i]$ se tiene que

Con el obtivo de resolver las cuestiones que se nos plantean con mayor facilidad procedo a calcular la descomposión en factores primos de a y b. 

1.Calculo su norma: 
N(b) = 26 = 13*2 
N(a) = 13 Es primo por tanto es un irreducible y por estar en un dominio euclídeo es un primo. 

2. Cada uno de los factores primos que descompone su norma será la norma de sus factores. 

Por tanto para b su descomposión es en un primo de norma 2 y otro de norma 13. 

Para el de norma 2 el único que existe es: (1+i). 
Para conocer al siguiente dividiré entre (1+i) dando como resultado (3-2i)


## Para los elementos a=4 y b=3+3i de $\mathbb {Z}[i]$ 

### existen $u,v\in \mathbb {Z}[i]$ tales que u a+v b=-1+5i.
Verdaero, ya que el mcd es (1+i) que es divisor de b


## El ideal de $\mathbb {Z}[i]$ generado por 2+5i y 4-i.  
Este ideal generado da lugar a los enteros de gauss ya que la norma de cada uno de los elementos es un número primo, por consiguiente su mcd es uno y por bezout cualquier elemento de los enteros de gauss se puede obtener. 

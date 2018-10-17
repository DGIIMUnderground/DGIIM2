# ÁLGEBRA I: AUTOEVALUACIÓN DE ANILLOS

## Pregunta 1
### a) $\mathbb{Z}_{31}$ No tine divisores de cero no nulos
Se dice que a es divisor de cero si para $a,b \in \mathbb{Z}_{31}$ se tiene que $ab = 0$.
Por encontrarnos en el ideal $\mathbb{Z}_{31}$ tenemos que 31 pertenece a la clase del 0 y por consiguiente sería equivalente a buscar dos naturales menores que 31 que ambos multiplicados resultasen 31.
Pero por ser 31 irreducible sabemos que sus únicos divisores son 1 y 31, por tanto hemos demostrado lo que se buscaba.

### b) El ideal $10\mathbb{Z}$ de $\mathbb{Z}$  NO es un ideal maximal

Se dice que un ideal es maximal si no existe ningún otro ideal del mismo conjunto que lo contenga.

Y un conjunto de elementos de A es un ideal de éste si, si es cerrado para la suma de elementos del ideal y para el producto de un elemento del ideal con los de A .

Para ver que no es un ideal maximal bastará con ver que $5\mathbb{Z}$  es un ideal, ya que contiene a $10\mathbb{Z}$:


Es cerrado para la suma, ya que los elementos de $5\mathbb{Z}$ son de la forma z5, con z un entero, por tanto al sumar dos elementos de esta forma sólo habría que sacar factor común y ver que sigue siento de la forma un entero por 5.

Y de una forma más evidente sigue ocurriendo con el producto, el resultado de multiplicar un entero por un múltiplo de 5 sigue siendo un múltiplo de 5 y por tanto pertenece $5\mathbb{Z}$ .

### c) $\mathbb{Q} \times \mathbb{Q}$ NO es un dominio de integridad
Para que sea un dominio de integridad el cero: (0,0) debe ser el único divisor de cero, pero tenemos que (0,1) $\times$ (1,0) es (0,0);
por tanto no es el único y no nos hallamos frente a un dominio de integridad.

### d) $\mathbb{Z}_6$ NO es un cuerpo

Todo cuerpo es un dominio de integridad, esto se debe a la definición de dominio de integridad, veamos:

Sea A es un anillo conmutativo no trivial, se dice que a es un anillo conmutativo si y sólo si se verifica que el único divisor de cero es cero, o equivalentemente que para todo elemento del anillo conmutativo, dados dos numéros cualesquiera de éste, si el producto del anterior con ambos es igual, quiere decir que ambos son el mismo elemento:

$\forall a \in A \setminus \{0\} \quad x,y \in A \quad ax = ay \Rightarrow x = y$

En un cuerpo se cumple la última propiedad ya que contamos con elementos inversos:

$\forall a \in A \setminus \{0\} \quad x,y \in A \quad ax = ay \quad \Leftrightarrow \quad a^{-1}ax = a^{-1}ay  \quad \Leftrightarrow \quad x = y$

Por otra parte contamos con que $\mathbb{Z}_6$ no es dominio de integridad, ya que $2 \times 3 = 6 = 0$.

Enlazando los razonamientos anteriores $\mathbb{Z}_6$ no es un dominio de integridad y por tanto no puede ser un cuerpo, demostrando con esto lo que se pretendía.



## Pregunta 2
Seleccionar la afirmación verdadera:
a) $\mathbb{Q} \times \mathbb{Z}$ no tiene divisores de cero no nulos.
b) $\mathbb{Z}_{7}$ tiene tres unidades.
c) $\mathbb{Z}$ tiene infinitas unidades.
d) $\mathbb{Z} \times \mathbb{Z}$ tiene dos unidades.

### Solución:

a) Verdadera.
Como $\mathbb{Q}$ es un cuerpo, $q^{-1} \in \mathbb{Q} \; \forall q \in \mathbb{Q}$. Es claro que los pares $(q, 1),(q^{-1}, 1)  \in \mathbb{Q} \times \mathbb{Z}$.
Como $(q, 1)\cdot(q^{-1}, 1) = (1, 1)$ se tiene que $(q, 1)$ es unidad de $\mathbb{Q} \times \mathbb{Z} \; \forall q \in \mathbb{Q}$.
Por tanto, al haber infinitos racionales, tenemos infinitos pares del tipo $(q, 1)$ que son unidades.

b) Falsa.
$\mathbb{Z}_{7} = \{\bar{0}, \bar{1}, \bar{2}, \bar{3}, \bar{4}, \bar{5}, \bar{6}\}$
Tenemos al menos seis unidades, ya que:
$$
\bar{1}\cdot\bar{1} = \bar{2}\cdot\bar{4} = \bar{3}\cdot\bar{5} = \bar{6}\cdot\bar{6} = \bar{1}
$$

c) Falsa.
Las únicas unidades de $\mathbb{Z}$ son el 1 y el -1, ya que son los únicos con inverso perteneciente a $\mathbb{Z}$:
$$
1\cdot1 = 1 \quad (-1)\cdot(-1) = 1
$$
No ocurre así con $\mathbb{Z} \setminus \{-1,1\}$

d) Falsa.
$\mathbb{Z} \times \mathbb{Z}$ tiene al menos cuatro unidades, ya que:
$$
(1, -1)\cdot(1, -1) = (-1, 1)\cdot(-1, 1) = (-1, -1)\cdot(-1, -1) = (1, 1)\cdot(1, 1) = (1, 1)
$$



## Pregunta 3
Escoger la afirmación verdadera:
a) $\mathbb{Q} \times \mathbb{Z}$ no tiene divisores de cero no nulos.
b) $\mathbb{Q} \times \mathbb{Z}$ tiene infinos ideales.
c) $\mathbb{Q} \times \mathbb{Q}$ no tiene ideales propios.
d) Todos los elementos de $\mathbb{Q} \times \mathbb{Q}$ son unidades.

### Solución:
a) Falsa.
$(0, 1) \cdot (1, 0) = (0, 0) \Rightarrow$ existen divisores de cero no nulos

b) Verdadera.
Sea $I = n\mathbb{Q} \times n\mathbb{Z}$. Veamos que I es un ideal $\forall n \in \mathbb{N}$ y, por haber infinitos números naturales habremos probado el enunciado.
- $(I, +)$ es un subgrupo:
  - Evidentemente $(0, 0) \in I$.
  - Sean $(nq, nz), (nq', nz') \in I$.
    $(nq, nz) + (nq', nz') = (nq + nq', nz + nz') = (n(q + z), n(q' + z')) \in I$
  - Dado $(nq, nz) \in I$, es claro que $(-nq, -nz) = (n(-q), n(-z)) \in I$ y que $(nq, nz) + (-nq, -nz) = (0,0)$

- Propiedad para el producto:
Sea $(q, z) \in \mathbb{Q} \times \mathbb{Z}$ y $(nq', nz') \in I$.
$$
(q, z) \cdot (nq', nz') = (nqq', nzz') \in I
$$

c) Falsa.
Contraejemplo: $I = 2\mathbb{Q} \times 2\mathbb{Q}$ es un ideal propio de $\mathbb{Q} \times \mathbb{Q}$, siendo $2\mathbb{Q} = \{q \in Q \vert \exists q' \in Q : q = 2q' \}$
- $(I, +)$ es un subgrupo:
  - Evidentemente $(0, 0) \in I$
  - Sean $(2\frac{m_{1}}{n_{1}}, 2\frac{m_{2}}{n_{2}}), (2\frac{r_{1}}{s_{1}}, 2\frac{r_{2}}{s_{2}}) \in I$
  $$
  (2\frac{m_{1}}{n_{1}}, 2\frac{m_{2}}{n_{2}}) + (2\frac{r_{1}}{s_{1}}, 2\frac{r_{2}}{s_{2}}) = (2(\frac{m_{1}}{n_{1}} + \frac{r_{1}}{s_{1}}), 2(\frac{m_{2}}{n_{2}} + \frac{r_{1}}{s_{2}})) \in I
  $$
  - Dado $(2\frac{m_{1}}{n_{1}}, 2\frac{m_{2}}{n_{2}}) \in I$ es claro que $(-2\frac{m_{1}}{n_{1}}, -2\frac{m_{2}}{n_{2}}) = (2\frac{-m_{1}}{n_{1}}, 2\frac{-m_{2}}{n_{2}}) \in I$ y que $(2\frac{m_{1}}{n_{1}}, 2\frac{m_{2}}{n_{2}}) + (-2\frac{m_{1}}{n_{1}}, -2\frac{m_{2}}{n_{2}}) = (0, 0)$

- Propiedad para el producto:
Sea $(\frac{p_1}{q_{1}}, \frac{p_{2}}{q_{2}}) \in \mathbb{Q} \times \mathbb{Q}$ y $(2\frac{m_{1}}{n_{1}}, 2\frac{m_{2}}{n_{2}}) \in I$
$$
(\frac{p_1}{q_{1}}, \frac{p_{2}}{q_{2}}) \cdot (2\frac{m_{1}}{n_{1}}, 2\frac{m_{2}}{n_{2}}) = (2\frac{p_1 \cdot m_{1}}{q_{1} \cdot n_{1}}, 2\frac{p_{2} \cdot m_{2}}{q_{2} \cdot n_{2}}) \in I
$$

d) Falso.
Contraejemplo: $(0, 0) \in \mathbb{Q} \times \mathbb{Q}$ no es unidad porque no tiene inverso.

## Pregunta 4

### a) $\mathcal{M}_2(\mathbb{R})$ es anillo conmutativo.

Falso. Contraejemplo:

$$\begin{pmatrix} 1 & 1 \\\ 1 & 0 \end{pmatrix} \begin{pmatrix} 0 & 0 \\\ 0 & 1 \end{pmatrix} = \begin{pmatrix} 0 & 0 \\\ 0 & 1 \end{pmatrix}$$

Lo cual es distinto de

$$\begin{pmatrix} 0 & 0 \\\ 0 & 1 \end{pmatrix} \begin{pmatrix} 1 & 1 \\\ 1 & 0 \end{pmatrix}  = \begin{pmatrix} 0 & 0 \\\ 1 & 0 \end{pmatrix}]$$

### b) $\mathcal{M}_2(\mathbb{Z})$ tiene divisores de cero no nulos

Verdadera

$\begin{pmatrix} 0 & 1 \\\ 0 & 0 \end{pmatrix}$ es divisor no nulo de $0$ ya que:

$$
\begin{pmatrix} 0 & 1 \\\ 0 & 0 \end{pmatrix} \begin{pmatrix} 1 & 0 \\\ 0 & 0 \end{pmatrix} = \begin{pmatrix} 0 & 0 \\\ 0 & 0 \end{pmatrix}
$$

### c) $\mathcal{M}_2(\mathbb{C})$ tiene infinitas unidades

Verdadera. Las unidades son las matrices regulares, las cuales tienen determinante no nulo. Éstas son infinitas ya que hay infinitas matrices $\begin{pmatrix} a & 0 \\\ 0 & 1 \end{pmatrix}$ con

$$
\begin{vmatrix} a & 0 \\\ 0 & 1 \end{vmatrix} = a \neq 0
$$

Por haber infinitos reales distintos de 0.

### d) $\begin{pmatrix} 2 & 3\\0 & 1\end{pmatrix}$ es unidad en $\mathcal{M}_2(\mathbb{Z})$

Falso. La inversa de la matriz pertenece a $\mathcal{M}(\mathbb{R})$, no a $\mathcal{M}(\mathbb{Z})$:

$$
\begin{pmatrix} 2 & 3 \\\ 0 & 1\end{pmatrix}^{-1} = \begin{pmatrix} 1/2 & -3/2 \\\ 0 & 1\end{pmatrix} \notin \mathcal{M}(\mathbb{Z})
$$


# Pregunta 5
Sea D un dominio de integridad. ¿Qué afirmación es correcta?
Selecciones una:  
- Nunca D puede ser un cuerpo.
- En cualquier caso D es un cuerpo.
- Es un cuerpo si tiene infinitos elementos.
- Es un cuerpo si tiene cardinal finito.

## Solución
La respuesta correcta  **Es un cuerpo si tiene cardinal finito.**

Para **desmentir la primera** veremos que un cuerpo es siempre un dominio de integridad, ya que por tener elemento inverso si se tiene que ab = ac  entonces $a^{-1}ab = a^{-1}ac$ de donde se deduce que b = c, cumpliendo la definición de dominio de integridad.

**La segunda es falsa**, ya que no todo dominio de integridad tiene que ser un cuerpo, véase por ejemplo: el anillo conmutativo  de integridad **$ 2\mathbb{Z}$**

Veamos ahora que todo dominio de integridad es un cuerpo si tiene cardinal finito.

Recordemos que un dominio de integridad es un anillo conmutativo, por tanto para ver que es un cuerpo bastaría con comprobar que todo elemento distinto del neutro de la suma cuenta con inverso.
Sea A un dominio de integridad finito, por ser finito sabremos que debe existir un i > 1 y un j>0 tal que para todo $ a \in A-\{0\}$ se tiene que $ a^i = a^{i+j}$
Si ahora planteamos la ecuación $ a^i x = a^{i+j}$ resultan dos soluciones para x; $x= a^j$ y $x = 1$ así que con esto llegamos a la conclusión de que $a^j = 1$ y aplicando que nos encontramos en un dominio de integridad:
$ a^i = a^{i+1} \Leftrightarrow a^i a^{-1}= a^{i+j}a^{-1} \Leftrightarrow a^i a^{-1}= a^{j-1}a^i{-1}  $
Aplicando otra que nos encontramos en un dominio de integridad llegamos a que  $a^{-1}= a^{j-1}$ y por tanto hemos encontrado al inverso de todo elemento de A distinto de 0 probando con ello que nos hallamos ante  un cuerpo.  

Respecto a la tercera afirmación...
QUE NO TENGAMOS UN DEMOSTRACIÓN PARA UN CUERPO INFINITO NO SIGNIFICA QUE ESTO NO EXISTA... Sin embargo podríamos pensar por lo general no se podría tener la certeza de que todos los elementos tengan inversos ya que no los podemos conocer a todos por eso de que sean infinitos...


## Pregunta 6

Entre las consiguientes afirmaciones hay una única verdadera.
Seleccione una:
- $5\mathbb{Z}$ es un subanillo de $\mathbb{Z}$
- $\mathbb{Q}$ no tiene subanillos propios
- cualquier ideal de un anillo es un subanillo.
- $\mathbb{Z}$ no tiene subanillos propios.

### Solución
- $5\mathbb{Z}$ es un subanillo de $\mathbb{Z}$  
Esta es falsa, ya que para que sea un subanillo $\mathbb{Z}$ entre otras, se le exige que su elemento neutro para el producto, el uno en nuestro caso esté contenido en $5\mathbb{Z}$, pero este no es el caso, y aque los elementos de $5\mathbb{Z}$ son de la forma: un entero por cinco.

- $\mathbb{Q}$ no tiene subanillos propios  

Falso ya que el propio $\mathbb{Z}$  es un subanillo de $\mathbb{Q}$  

- cualquier ideal de un anillo es un subanillo.  
Falso, ya que para ello debe contener al neutro del producto. Y su ausencia no impide que sea un ideal. Por ejemplo:
$2\mathbb{Z}$ es un ideal de $\mathbb{Z}$ y sin embargo no es un subanillo ya que no contiene al uno.  

- $\mathbb{Z}$ no tiene subanillos propios.  
Un subanillo es propio cuando no coincide con el vacío o con el propio anillo.
Supongamos que sí los tiene y lleguemos a una contradicción:
El subanillo no es vacía y debe contener al uno, pero como es cerrado para la suma de elementos 1+1 = 2 y por tanto 2 debe pertenecer al conjunto y por lo tanto ahora el 1 y el 2 son dos elementos del subanillo, pero por ser cerrado para la suma 1+2=3 y por tanto 3 pertenecerá al subanillo.
Por tanto veamos que si n pertece al subanillo n+1 también ya que es cerrado para la suma y el 1 pertenece al subanillo.

Por otra parte tenemos que si un pertenece al subanillo su opuesto también pertenecerá, por tanto ya contamos con todos los enteros salvo el cero, lo obtenemos sumando dos opuestos.

Y con esto hemos llegado a que el subanillo debe ser el propio $\mathbb{Z}$ y por tanto no es propio. 

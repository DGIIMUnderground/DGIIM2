# Proposición  
Sean $g_n:]a,b[ \longrightarrow \mathbb{R} tales que g_n \in {C}^1(]a,b[) \forall n \in \mathbb {N} $ 
Supongamos que $\sum_{n\geq 1} g_n$ converge puntualmente en $]a,b[$ y que $\sum_{n\geq 1} g_n'$ converge uniformemente.

Probad que $\sum_{n\geq 1} g_n $converge uniformemente. Sea $g(x) = \sum_{n=1}^\infty g_n(x)$.

Probad también que 
$g'(x) = \sum_{n=1}^\infty g_n'(x)  \forall x \in ]a,b[ $



## Demostración primera proposición

Se quiere demostrar que dado cualquier épsilon real positivo existe un natural a partir
del cual cualquier n superior cumpla la siguiente igualdad sea cual sea el $x$ del dominio se tenga que:

$ \sum_{n\geq 1} g_n(x) - g(x) | < \epsilon$

Por el teorema fundamental del cálculo sabemos que
$g(x) = g(x_0) + \int_{x_0}^x g'(x)$

Sustituyendo tal igualdad en $ |\sum_{n\geq 1} g_n(x) - g(x)|$
 obtenemos:
$ | \sum_{n\geq 1} g_n(x_0) + \sum_{n\geq 1} \int_{x_0}^x g_n'(t) dt  - g(x_0) - \int_{x_0}^x g'(t) dt |$
Reagrupamos miembros y aplicamos desigualdad triangular:
$ |\sum_{n\geq 1} g_n(x_0) -  g(x_0)| + | \sum_{n\geq 1} \int_{x_0}^x g_n'(t) dt - \int_{x_0}^x g'(t) dt| $
Por la convergencia puntual se sabe que existe un $n_p$  a partir del cual

$ |  \sum_{n\geq 1} g_n(x_0) -  g(x_0)| < \epsilon /2 $

Para acotar el segundo valor absoluto utilizamos la propiedad asociativa de la integral
y que que $\sum_{n\geq 1} g_n'$ converge uniformemente, por tanto obtenemos un
$n_u$ a partir del cual  $ | \int_{x_0}^x  \sum_{n\geq 1}  g_n'(t) - g'(t) dt | < \epsilon /2 $

Tomamos como $n_0$ = max { $n_p,n_u$} y por por tanto hemos demostrado lo que se buscaba.


## Demostración segunda proposición

Para demostrar el segundo resultado que se nos pide, volvamos a utiliza la igualdad proporcionada
por el teorema fundamental del cálculo
$  \sum_{n\geq 1} g_n(x) =  \sum_{n\geq 1} g_n(x_0) + \int_{x_0}^x  \sum_{n\geq 1} g_n'(x)$
Tomamos límites y como sabemos que es convergente uniformemente :
$  g(x) =  g(x_0) + \int_{x_0}^x  \sum_{n\geq 1}  g_n'(t) dt $
(para el límite de la integral utilizamos el resultado conocido
y demostrado en uno de los mismo apartado del foro)

El teorema fundamental del cálculo y la continuidad de la serie afirmamos también que tal igualdad es derivable,
así que derivando en ambos miembros obtenemos:

$  g'(x) =  \sum_{n\geq 1}  g_n'(x) $ que es lo que se buscaba probar.

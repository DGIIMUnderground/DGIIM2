# Teorema
Sean $ g_n:]a,b[ \longrightarrow \mathbb{R} $funciones continuas $\forall n \in \mathbb {N} $ tales que


∑n≥1gn

converge uniformemente en ]a,b[.

Probad que

$ \int_a^b∑_{n \geq1}^\infty g_n(x)dx= ∑_n^\infty \int_a^b g_n(x)dx.$

---

En virtud de los enunciados demostrados en clase, veamos que es una mera cuestión de nomenclatura. 

Definamos una sucesión auxiliar, donde cada término viene dado por
$ f_n = \sum_{i=1}^n g_i $ Cada función de la sucesión es continua en el intervalo abierto a,b, y su imagen son los reales ya que por definición es suma de funciones continuas. Además por la hipótesis  de convergecia uniforme de la sucesión con la que se ha definido, ésta también lo será y sus límites serán idénticos. 

Ahora en virtud del teorema que afirma que dada una sucesión de funciones todas de dominio el intervalo abierto a,b y su imagen en los reales que converge uniformemente a una función definida en el mismo dominio e imagen se tiene que

$ lim_{n \rightarrow  \infty} \int_a^b f_n (x) dx =  \int_a^b lim_{n \rightarrow  \infty}  f_n (x) dx = \int_a^b f(x) dx $

Ahora deshaciendo la notación auxiliar llegamos a que
$ lim_{n \rightarrow \infty }\int_a^b \sum_{i=1}^ng_i (x) dx  = \int _a ^b lim_{n \rightarrow \infty} \sum_{i=1}^ng_i (x) dx $ y tomando límites hemos probado lo que buscábamos. 
## Ejercicio

### Caracterización de compactos

Sea $A \subset \mathbb{R^n}$ compacto, $B \subset \mathcal{C}(A, \mathbb{R^n})$.

$B$ es compacto $\iff B$ es cerrado, acotado y equicontinuo

### Demostración

En clase ya hicimos $\Leftarrow$. Demostraremos ahora la condición necesaria mediante abiertos

Como estamos en un espacio métrico, sabemos que un compacto es cerrado y acotado. Debemos comprobar que también es equicontinuo.

Para ello, tomamos un $\varepsilon > 0$, y consideramos la familia $\{B(f, \varepsilon) \ |\  f \in B \}$. Todas ellas son bolas abiertas. Además, la unión de todas forma un recubrimiento de $B$:

$$B \subseteq \bigcup_{f \in B}{B(f, \varepsilon)}$$

Como $B$ es compacto, podemos extraer un subrecubrimiento finito:

$$B \subseteq \bigcup_{i = 0}^{n}{B(f_i, \varepsilon)}$$

Notemos que $\forall f \in B(f_i, \varepsilon) \Rightarrow |f(x) - f_i(x)| < \varepsilon\ \forall x \in A$.
Además, por ser $A$ compacto, cada una de las funciones $f_i$ será uniformemente continua. Esto nos dice que para cada una de las $f_i$ existe un $\delta _i > 0$ tal que si $x,y\in A$, $|x-y| < \delta _i \Rightarrow |f_i(x) - f_i(y)| < \varepsilon$

Si tomamos $\delta = min\{\delta _i \ |\  0 \leq i \leq n\}$, conseguimos que $\forall f \in B$, $f \in B(f_i, \varepsilon)$ con $0 \leq i \leq n$, y que si $x, y\in A$, $|x-y| < \delta < \delta _i$

Usando la desigualdad triangular, tenemos que

$$|f(x) - f(y) \leq |f(x) - f_i(x)| + |f_i(x) - f_i(y)| + |f_i(y) - f(y)| < \varepsilon + \varepsilon + \varepsilon = 3\varepsilon$$

Por lo cual, $B$ es equicontinuo
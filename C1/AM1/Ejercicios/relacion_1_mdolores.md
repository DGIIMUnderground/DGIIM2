# Relación de ejercicios I: Espacios normados. Espacios métricos. Topología de $\mathbb{R}^n$

## Ejercicio 14
**Prueba que en todo espacio métrico $(E, d)$ la distancia es una función continua, esto es:**
$$
x_n, y_n \in E, \forall n \in \mathbb{N}, x, y \in E, \{x_n\} \rightarrow x, \{y_n\} \rightarrow y \Rightarrow \{d(x_n, y_n)\} \rightarrow d(x, y)
$$

### Demostración:
Sean $\{x_n\}$ e $\{y_n\}$ sucesiones que cumplen la hipótesis. Entonces:
$$
\forall \varepsilon > 0 \quad \exists m_1 \in \mathbb{N}: n > m \Rightarrow d(x_n, x) < \varepsilon / 2 \\
\forall \varepsilon > 0 \quad \exists m_2 \in \mathbb{N}: n > m \Rightarrow d(y_n, x) < \varepsilon / 2
$$

Tomando $n > máx\{m_1, m_2\}$ y aplicando la desigualdad triangular resulta:
$$
\forall \varepsilon > 0 \quad d(x_n, y_n) \leq d(x_n, x) + d(x, y) + d(y, y_n) < \varepsilon / 2 + d(x, y) + \varepsilon / 2 = \varepsilon + d(x, y) \\
$$
Equivalentemente:
$$
(\forall \varepsilon > 0 \exists m \in \mathbb{N}: n > m \Rightarrow d(x_n, y_n) - d(x, y) < \varepsilon) \Leftrightarrow \{d(x_n, y_n)\} \rightarrow d(x, y)
$$
QED.

## Ejercicio 24
**Prueba que todo espacio métrico finito es compacto. En caso de que se considere la distancia discreta en un conjunto no vacío E, prueba que todo subconjunto compacto de E es finito.**

### E finito $\Rightarrow$ E compacto. Demostración:
Sea $E = \{t_1, ..., t_n\}$ un espacio finito y $\{x_n\}$ una sucesión de elementos de $E$.

Sea $A = \{A_1, ..., A_n\}$, siendo cada $A_i$ un conjunto de ínidces definido como: $A_i = \{n \in \mathbb{N}: x_n = t_i\}$.

Veamos que $\mathbb{N} = \cup_{i = 1}^{n} A_i$
- $\subseteq$: Sea $m \in \mathbb{N}$. Es claro que existe $x_m$ y como $\{x_n\} \subset E$ necesariamente $x_m = t_k$ para algún $k \in \{1, ..., n\}$, luego $m \in A_k \subseteq \cup_{i = 1}^{n} A_i$
- $\supseteq$: Trivial porque todos los $A_i$ son conjuntos de números naturales

Como $\mathbb{N}$ es infinito, debe haber al menos un $A_k$ inifinito para algún $k \in \{1, ..., n\}$. Tomo ese $A_k$.

Sea la aplicación $\phi: \{1, ..., n\} \rightarrow \mathbb{N}$ definida por $$
\phi(1) = mín\{A_k\} \\
\phi(2) = mín\{a \in A_k: a > \phi(1)\} \\
\phi(3) = mín\{a \in A_k: a > \phi(2)\} \\
... \\
\phi(i) = mín\{a \in A_k: a > \phi(i-1)\}
$$
Como, por definción de $A_k$, $x_a = t_k \quad \forall a \in A_k$, se tiene que:
$$
x_{\phi(1)} = x_{\phi(2)} = x_{\phi(3)} = ... = x_{\phi(i)} = t_k
$$
Lo que nos dice que $\{x_{\phi(n)}\}$ es constante y por tanto, convergente.
Así, hemos probado que cualquier sucesión tiene una parcial convergente, luego el espacio $E$ es compacto.

### Con la distancia discreta, $A \subseteq E$ compacto $\Rightarrow$ A finito.
Razonemos por el contrarecíproco, esto es, demostraremos:
$A \subseteq E$ infinito $\Rightarrow A$ no compacto

#### Demostración:
Por ser $A$ inifinito, puedo definir, $\forall n \in \mathbb{N}$, una sucesión $\{x_n\} \subset A$ tal que:
$$
x_1 \in A \\
x_2 \in A - {x_1} \\
... \\
x_i \in A - \{x_j: j < i\} \\
$$
Es decir, acabamos de definir una sucesión que no repite valores.

Veamos que $\{x_n\}$ no tiene ninguna sucesión parcial convergente. Supongamos que sí y llegaremos a una contradicción:
Sea $\{x_{\sigma(n)}\} \rightarrow x$, entonces, por definición:
$$
\forall \varepsilon > 0 \quad \exists m \in \mathbb{N}: n > m \Rightarrow d(x_{\sigma(n)}, x) < \varepsilon
$$
Tomo $0 < \varepsilon < 1$. Como usamos la distancia discreta:
$$
d(x_{\sigma(n)}, x) < 1 \Rightarrow d(x_{\sigma(n)}, x) = 0 \Leftrightarrow x_{\sigma(n)} = x
$$
a patir de un cierto m.

Pero esto es absurdo porque $\{x_n\}$ no repite valores, luego $\{x_n\}$ no tiene ninguna sucesión parcial convergente y $A$ no es compacto.

## Ejercicio 35
**Prueba que toda sucesión de Cauchy en un espacio métrico que admita una sucesión parcial convergente es convergente**

Sea E un espacio métrico. Hay que demostrar la siguiente implicación:
$$
\forall \{x_n\} \subset E \ de \ Cauchy: \exists \{x_{\sigma(n)}\} \ convergente \Rightarrow \{x_n\} \ converge
$$

#### Demostración:
Sea $\{x_n\} \subset E$ una sucesión de Cauchy, entonces:
$$
\forall \varepsilon > 0 \quad \exists M \in \mathbb{N}: \sigma(n), p > M \Rightarrow d(x_{\sigma(n)}, x_p) < \varepsilon / 2
$$
Sea $\{x_{\sigma(n)}\}$ una sucesión parcial convergente de $\{x_n\}$, entonces:
$$
\forall \varepsilon > 0 \quad \exists m \in \mathbb{N}: n > m \Rightarrow d(x_{\sigma(n)}, x) < \varepsilon / 2
$$
Por la desigualdad triangular:
$$
d(x_p, x) \leq d(x_{\sigma(n)}, x_p) + d(x_{\sigma(n)}, x) = \varepsilon / 2 + \varepsilon / 2 = \varepsilon
$$
Adecuando la notación, obtenemos:
$$
\forall \varepsilon > 0 \exists M \in \mathbb{N}: d(x_p, x) < \varepsilon
$$
Por lo cual, $\{x_n\}$ converge. QED


## Ejercicio 36
**Prueba que todo espacio métrico compacto es completo. Prueba también que en un espacio métrico completo, todo subconjunto cerrado también es completo. ¿Es todo espacio métrico completo un conjunto compacto? Justifica la respuesta.**

### E espacio métrico compacto $\Rightarrow$ E espacio completo
Esta implicación es equivalente, por definición, a esta otra:
Toda sucesión tiene una parcial convergente $\Rightarrow$ Toda sucesión de Cauchy es convergente

#### Demostración
Sea $\{x_n\} \in E$ una sucesión de Cauchy, entonces, por definición:
$$
\forall \varepsilon > 0 \quad \exists M: p, q > M \Rightarrow d(x_p, x_q) < \varepsilon / 2
$$
Por hipótesis, sabemos que $\{x_n\}$ tiene una sucesión paracial convergente, esto es:
$$
\exists \{x_{\sigma(n)}\} \quad \vert \quad \forall \varepsilon > 0 \quad \exists m \in \mathbb{N}: n > m \Rightarrow d(x_{\sigma(n)}, x) < \varepsilon / 2
$$
Sea $n \in \mathbb{N}: n > máx\{M, m\}$, entonces aplicando la desigualdad triangular a $d(x_n, x)$ resulta:
$$
d(x_n, x) \leq d(x_n, x_{\sigma(n)}) + d(x_{\sigma(n)}, x)
$$
Como $\{x_n\}$ es de Cauchy, entonces $d(x_n, x_{\sigma(n)}) < \varepsilon / 2$; y como $\{x_{\sigma(n)}\}$ converge a x, se tiene que $d(x_{\sigma(n)}, x) < \epsilon / 2$
Por tanto,
$$
d(x_n, x) < \varepsilon / 2 + \varepsilon / 2 = \varepsilon
$$
y con ello concluimos que $\{x_n\} \rightarrow x$ (es convergente), como se quería.


### A cerrado de un espacio métrico completo $\Rightarrow$ A espacio completo
Esta implicación es equivalente, por definición, a esta otra:
En E un espacio métrico completo,
$$\forall A \subseteq E: A \in \mathcal{C} \Rightarrow (\forall \{x_n\} \subset A\ de\ Cauchy \Rightarrow \{x_n\} \ converge)
$$

#### Demostración
Sea $\{x_n\} \in E$ una sucesión de Cauchy, entonces, por definición:
$$
\forall \varepsilon > 0 \quad \exists M: p, q > M \Rightarrow d(x_p, x_q) < \varepsilon
$$
Como $E$ es un espacio completo y $\\{x_n\\} \in A \subseteq E \quad \Rightarrow \quad \\{x_n\\} \rightarrow x \in E$
Si demostramos que $x \in A$ habremos acabado, ya que en tal caso toda sucesión de Cauchy de A sería convergente en A.

Usamos la siguiente proposición, de la página 23 de los apuntes de R. Payá (Tema 2):
> Sea $E$ un espacio métrico, $x \in E$ y $A \subset E$, entonces $x \in \bar{A} \Leftrightarrow \exists \\{x_n\\} \subset A: \\{x_n\\} \rightarrow x$

Entonces, como teníamos $\\{x_n\\} \subset A$ y $\\{x_n\\} \rightarrow x \in E$, aplicando la proposión resulta que $x \in \bar{A}$
Ahora bien, como A es cerrado, $A = \bar{A}$ y por tanto $\\{x_n\\} \rightarrow x \in A$, como se quería.

### Todo espacio métrico completo NO es un conjunto compacto
#### Contraejemplo:
Sea $A = [a, \infty[ \subset \mathbb{R}$. A es cerrado porque su complemento es un abierto de $\mathbb{R}$ con la topología usual. Por el apartado anterior, como A es un cerrado perteneciente a un espacio completo, sabemos que A es un espacio completo.
Por otra parte, es claro que A no está acotado.

Usamos la siguiente proposición, de la página 43 de los apuntes de R. Payá (Tema 4):
> Un subconjunto de $\mathbb{R}^n$ es compacto si, y sólo si, es cerrado y acotado.

Al no estar A acotado, A no es compacto.
Por tanto hemos encontrado un espacio métrico completo que no es un conjunto compacto.

# Relación de ejercicios I: Espacios normados. Espacios métricos. Topología de $\mathbb{R}^n$

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

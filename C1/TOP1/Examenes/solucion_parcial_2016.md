# Solución al examen de Topología I del 21 de noviembre de 2016

## Ejercicio 1: 4 puntos
**Un espacio topológico $(X, \tau)$ se llama Hausdorff si para cualquier par de puntos distintos $x \neq y$ existen entornos $V \in \mathcal{U}^x$ y $W \in \mathcal{U}^y$ cumpliendo $V \cap W = \emptyset$.**

**(1) Probar que si $(X, \tau)$ es un espacio topológico Hausdorff, entonces cualquier punto suyo es un subconjunto cerrado.**

> **Proposición 1.1.1:**
$C \subseteq X$ cerrado $\Leftrightarrow \forall y \notin C \quad \exists V \in \mathcal{U}^y: V \cap C = \emptyset$

Sea $C = \{x\} \subset X$, veamos que es cerrado.
Tomo $y \notin C \Rightarrow y \in X - \{x\}$. Es claro que $x \neq y$.
Como $(X, \tau)$ es Hausdorff, $\exists V \in \mathcal{U}^y, \exists W \in \mathcal{U}^x: V \cap W = \emptyset$.
Al ser $C = \{x\} \subset W$, se tiene que $V \cap C = \emptyset$, luego C es cerrado por la proposición 1.1.1.


**(2) Probar que cualquier subespacio topológico de un espacio Hausdorff es Hausdorff** ("La propiedad Hausdorff es hereditaria")

Dado $Y \subset X$ veamos que $(Y, \tau_y)$ es Hausdorff.
Sean $y_1, y_2 \in Y, y_1 \neq y_2$. Como también pertenecen a X y éste es Hausdorff, $\exists O_1, O_2$ tales que $y_1 \in O_1, y_2 \in O_2$ y $O_1 \cap O_2 = \emptyset$.
También se sabe que
$$
y_1 \in O_1 \cap Y \in \tau_y \\
y_2 \in O_2 \cap Y \in \tau_y
$$
Por lo que $O_1 \cap Y$ y $O_2 \cap Y$ son entornos de $y_1$ e $y_2$, respectivamente, en $(Y, \tau_y)$.
Si su intersección es vacía, habremos acabado, ya que tendremos dos entornos en la topología inducida con intersección vacía, por lo que ésta será Hausdorff.
$$
(O_1 \cap Y) \cap (O_2 \cap Y) = (O_1 \cap O_2) \cap Y = \emptyset \cap Y = \emptyset
$$
QED.


**(3) Probar que el producto topológico de dos espacios Hausdorff es Hausdorff**
Sean $(X_1, \tau_1)$ y $(X_2, \tau_2)$ dos espacios Hausdorff. Veamos que $(X_1 \times X_2, \tau_1 \times \tau_2)$ es un espacio Hausdorff.

> **Proposición 1.3.1:**
Sea $(X, \tau)$ un espacio topológico y $\mathcal{B}^x$ una base de entornos de $x \in X$. Equivalen:
a)  $(X, \tau)$ es Hausdorff
b) $\forall x, y \in X, x \neq y, \exists V \in \mathcal{B}^x \ \exists W \in \mathcal{B}^y: V \cap W = \emptyset$

> **Proposición 1.3.2:**
Sean $(X_1, \tau_1)$ y $(X_2, \tau_2)$ dos espacios topológicos y $(x_1, x_2) \in X_1 \times X_2$.
Se verifica que $\mathcal{B}^{(x_1, x_2)} = \{V_1 \times V_2: V_1 \in \mathcal{U}^{x_1}, V_2 \in \mathcal{U}^{x_2}\}$ es una base de entornos de $(x_1, y_1)$.

Sean:
- $(y_1, y_2) \in X_1$
- $(z_1, z_2) \in X_2$
- $V \in \mathcal{U}^{(y_1, y_2)}$
- $W \in \mathcal{U}^{(z_1, z_2)}$
- $\mathcal{B}^{(y_1, y_2)}$ una base de entornos de $(y_1, y_2)$
- $\mathcal{B}^{(z_1, z_2)}$ una base de entornos de $(z_1, z_2)$

Por la proposición 1.3.2
- $\exists V_1 \times V_2 \in \mathcal{B}^{(y_1, y_2)}: V_1 \times V_2 \subset V$, con $V_1 \in \mathcal{U}^{y_1}$ y $V_2 \in \mathcal{U}^{y_2}$
- $\exists W_1 \times W_2 \in \mathcal{B}^{(z_1, z_2)}: W_1 \times W_2 \subset W$, con $W_1 \in \mathcal{U}^{z_1}$ y $W_2 \in \mathcal{U}^{z_2}$

Hemos obtenido así $V_1 \times V_2$ y $W_1 \times W_2$, veamos que su intersección es vacía y entoces estaremos en las condiciones de la proposión 1.3.1 b):
$$
(V_1 \times V_2) \cap (W_1 \times W_2) =^1 (V_1 \cap W_1) \times (V_2 \cap W_2) =^2 \emptyset \times \emptyset = \emptyset
$$
donde en la igualdad 1 se ha aplicado una propiedad general de conjuntos vista en clase y en 2 que $(X_1, \tau_1)$ y $(X_2, \tau_2)$ son Hausdorff.

Así, al verificarse b) de la proposión 1.3.2 también lo hace a) y concluimos que $(X_1 \times X_2, \tau_1 \times \tau_2)$ es Hausdorff.


**(4) Probar que un espacio topológico $(X, \tau)$ es Hausdorff si y sólo si la diagonal $\Delta = \{(x, x) \in X \times X \vert \ x \in X\}$ es un subconjunto cerrado de $(X \times X, \tau \times \tau)$**

<u> Condición necesaria: </u>

<u> Condición suficiente: </u>

---

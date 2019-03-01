**Sea $A\subset\mathbb{R^n}$. Probar que $(\mathcal{C}_b(A,\mathbb{R}), \Vert \cdot \Vert_\infty )$ es un espacio normado**

Debemos probar que $\Vert  \cdot \Vert _\infty$ es, en efecto, una norma. Para ello, comprobaremos la no negatividad, homogeneidad y la desigualdad triangular de la posible norma.

- Sea $f: A\rightarrow\mathbb{R^{n}}$. Debemos comprobar que $\Vert f \Vert_\infty\ge0 \ \forall f \in \mathcal{C}_b(A,\mathbb{R})$

Hemos definido la norma infinito como

$$\Vert{f}\Vert_\infty := \sup_{x \in A} |f(x)|$$

Por tanto, necesariamente, se tiene que las imágenes son todas mayores e iguales que 0, debido al valor absoluto. Además, $\Vert f\Vert _\infty = 0 \iff f(x) = 0\forall x \in A$

- Si $k \in \mathbb{R}$, ¿ $\Vert f \cdot k\Vert _\infty = |k| \cdot \Vert f\Vert _\infty$ ?

$$\Vert k \cdot f\Vert _\infty = \sup_{x \in A} |k \cdot f(x)| = |k| \cdot \sup_{x \in A} |f(x)| = |k| \cdot \Vert f\Vert _\infty$$

- Desigualdad triangular: $\Vert f+g\Vert _\infty \le \Vert  f \Vert _\infty + \Vert  g \Vert _\infty$

$$\Vert f+g \Vert_\infty = \sup_{x \in A} |f(x)+g(x)| \le \sup_{x \in A} |f(x)| + \sup_{x \in A} |g(x)| = \Vert f \Vert_\infty + \Vert g \Vert_\infty$$

Por tanto, $\Vert f\Vert _\infty$ define una norma sobre el espacio de funciones continuas acotadas y $(\mathcal{C}_b(A,\mathbb{R}), \Vert  \cdot \Vert _\infty )$ es un espacio normado
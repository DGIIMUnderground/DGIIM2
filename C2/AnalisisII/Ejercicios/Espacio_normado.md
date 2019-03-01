**Sea $A\subset\mathbb{R^n}$. Probar que $(\mathcal{C}_b(A,\mathbb{R}), \| \cdot \|_\infty )$ es un espacio normado**

Debemos probar que $\| \cdot \|_\infty$ es, en efecto, una norma. Para ello, comprobaremos la no negatividad, homogeneidad y la desigualdad triangular de la posible norma.

- Sea $f: A\rightarrow\mathbb{R^{n}}$. Debemos comprobar que $\|f\|_\infty\ge0 \ \forall f \in \mathcal{C}_b(A,\mathbb{R})$

Hemos definido la norma infinito como

$$\|f\|_\infty := \sup_{x \in A} |f(x)|$$

Por tanto, necesariamente, se tiene que las imágenes son todas mayores e iguales que 0, debido al valor absoluto. Además, $\|f\|_\infty = 0 \iff f(x) = 0\forall x \in A$

- Si $k \in \mathbb{R}$, ¿ $\|f \cdot k\|_\infty = |k| \cdot \|f\|_\infty$ ?

$$\|k \cdot f\|_\infty = \sup_{x \in A} |k \cdot f(x)| = |k| \cdot \sup_{x \in A} |f(x)| = |k| \cdot \|f\|_\infty$$

- Desigualdad triangular: $\|f+g\|_\infty \le \| f \|_\infty + \| g \|_\infty$

$$\|f+g\|_\infty = \sup_{x \in A} |f(x)+g(x)| \le \sup_{x \in A} |f(x)| + \sup_{x \in A} |g(x)| = \|f\|_\infty + \|g\|_\infty$$

Por tanto, $\|f\|_\infty$ define una norma sobre el espacio de funciones continuas acotadas y $(\mathcal{C}_b(A,\mathbb{R}), \| \cdot \|_\infty )$ es un espacio normado
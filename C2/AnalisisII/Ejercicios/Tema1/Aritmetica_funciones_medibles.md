Aritmética de funciones medibles positivas

Sea $\Omega$ un espacio medible, $\alpha \in [0, \infty]$, y $f,g:\Omega \rightarrow [0, \infty]$. Entonces, $f+g$, $fg$ y $\alpha f$ son funciones medibles.

Demostración:

Por el teorema de aproximación de Lebesgue, somos capaces de encontrar una sucesión de funciones $\{s_n\}$ que converge a $f$, y $\{t_n\}$ convergente a $g$, con ambas sucesiones crecientes. 

Además, por una proposición, sabemos que la suma y la multiplicación de funciones simples es una función simple, así como la multiplicación de un escalar positivo por una función simple.

Por tanto, podemos construir una sucesión $\{s_n + t_n\} \rightarrow f + g$, por lo que la suma es medible al ser límite puntual de funciones medibles. 

El mismo razonamiento se puede aplicar a la multiplicación: si construimos $\{s_n t_n\} \rightarrow f g$, sabemos entonces que $fg$ es medible, por ser límite puntual de medibles.

Si tomamos $\alpha \in [0, \infty]$, construimos $\{\alpha s_n\} \rightarrow \alpha f$, la cual es medible
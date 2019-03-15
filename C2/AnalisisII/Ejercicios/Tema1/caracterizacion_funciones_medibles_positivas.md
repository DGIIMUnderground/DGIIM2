# Caracterización de funciones medibles positivas

## Proposición 
Sea $(\Omega,\mathscr A)$ un espacio de medida y $f:\Omega \to [0,\infty]$. Entonces:

- $f  \text{ es medible } \Leftrightarrow \{w \in \Omega : f(w) < \gamma \} \text{ es medible } \forall \gamma \geq 0 $ 

- $f  \text{ es medible } \Leftrightarrow  \{w \in \Omega : f(w) \leq \gamma \} \text{ es medible } \forall \gamma \geq 0 $

- $f  \text{ es medible } \Leftrightarrow \{w \in \Omega : f(w) > \gamma \} \text{ es medible } \forall \gamma \geq 0 $

- $f  \text{ es medible } \Leftrightarrow \{w \in \Omega : f(w) \geq \gamma \} \text{ es medible } \forall \gamma \geq 0$

## Demostración  

Antes de comenzar con la demostración haremos notar que se está trabajando con la recta real inducida, un espacio topológico y por tanto será de utilidad n el siguiente resultado: 

### Caracterización de aplicaciones medibles por abiertos
Si  $(\Omega,\mathscr A)$ un espacio de medida y $X$ un espacio topológico con $B$ su $\sigma$-algebra de Borel entonces: 
$ f: \Omega \to X  \text{ es medible} \Leftrightarrow f^{-1} (G) \in \mathscr A \ \forall G \in   \tau$

Por tanto empecemos demostrando que: 

$f  \text{ es medible } \Leftrightarrow \{w \in \Omega : f(w) < \gamma \}  = f^{-1}([0 ,\gamma )  )\ \  \text{ es medible } \ \ \forall \gamma \geq 0 $ 


### Condición suficiente  
Se tiene que $[0, \gamma) $ es un abierto de la topología entontes por la caracterización de una aplicación medible por abiertos tenemos que 
$$f^{-1}([0, \gamma) ) \in \mathscr A  $$ 
Y por la definición del conjunto se llega a que 
$$f^{-1}([0, \gamma) ) = \{w \in \Omega : f(w) < \gamma \} \in \mathscr A   $$

Con esto hemos probado lo que buscábamos. 

### Recíproco 

Para la que la aplicación definida sea medible tenemos que ver que 
$$ \forall b \in  B \ \ \ f^{-1}(b) \in \mathscr A  $$

Como la unión de medibles es medible esto equivale a probar que 
$\{ f^{-1}(b) \ \forall b  \in B\}$ es medible  y volviendo a basarnos en la caracterización de medibles por abiertos tenemos que el conjunto anterior es equivalente a $ \{ f^{-1}(O) \ \forall O \in \mathcal T\} $ lo que por definición de la topología es 
$$\{ f^{-1}(O) :  O \subseteq [0,\gamma) \ \text{  con  } \gamma \in \mathbb R^+\} \Leftrightarrow \{ w \in \Omega \ \text{  con  } f(w) \in [0,\gamma) \} $$

Y por hipótesis sabemos que este conjunto es medible. 

### Equivalencia de medibles entre los conjuntos anteriores. 

Veamos ahora que con que uno de los conjuntos definidos sea medible esto implica que lo sean todos. 

Hemos visto que $f^{-1}( [0,\gamma) )$ es medible,por tanto su opuesto  $f^{-1}( [\gamma, \infty] )$ también lo es. 

Como la unión de medibles es medibles $ \cup^\infty_{n=1} f^{-1}( [0,\gamma -\frac{1}{n})  ) = f^{-1}( [0,\gamma] )$ también será medible. 

Finlemente su opuesto $f^{-1}( (\gamma, \infty] )$ también lo será.  Y con esto ya he demostrado que todos los conjuntos anteriores son medibles con que uno lo sea. 

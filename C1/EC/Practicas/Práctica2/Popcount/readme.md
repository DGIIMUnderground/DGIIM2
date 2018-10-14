# Documento informativo sobre POPCOUNT

El fichero `popcount.c` es el código fuente de las 6 funciones (una por cada versión)
realizadas para calcular el peso Hamming de una lista de 2²⁰ términos.

A partir de `popcount.c` se hicieron 3 compilaciones, cada una con un nivel de optimización
diferente, de la siguiente forma:

- `gcc -m32 -g -O0 popcount.c -o popcount`
- `gcc -m32 -g -O1 popcount.c -o popcount`
- `gcc -m32 -g -O2 popcount.c -o popcount`

Con cada compilación se obtuvo un fichero ejecutable cuya ejecución nos proporciona el
tiempo en microsegundos (μs) que tarda cada versión en procesar el peso Hamming de los
elementos de la lista.

Mediante 11 ejecuciones por cada compilación (11 porque normalmente la primera se
desprecia o por si alguna medición no es válida), realizadas con la siguiente instrucción:
`for (( i=0; i<11; i++ )); do echo $i; ./popcount; done`
se obtienen datos de estas 11 ejecuciones y se calcula el tiempo medio de procesado de las
últimas 10 ejecuciones de cada versión.

Así se obtienen 3 tablas, una por cada nivel de ejecución, cuyas entradas son la versión y el
número de ejecución, conteniendo cada celda a_ij el tiempo de procesado de la versión i en
la ejecución j en microsegundos.

Con estos datos, se realiza un gráfico que compara las versiones según el nivel de
optimización. Por lo general, se puede concluir que **cada versión mejora a la anterior** y **cada
nivel de optimización mejora también al anterior**. Podemos por tanto afirmar que la forma
más eficiente de calcular el peso Hamming de una lista de enteros sin signo es usar la
versión 6 en el nivel de optimización `-02`.

> **NOTA**: En el repositorio de nextcloud están subidas algunas [preguntas de autocomprobación](https://dgiimcloud.ml/remote.php/webdav/DGIIM/2/1%C2%BA%20Cuatrimestre/estructura%20de%20computadores/Pr%C3%A1cticas%202017_2018/Practica%202/Preguntas%20de%20autocomprobaci%C3%B3n.pdf) y las [tablas y gráficos](https://dgiimcloud.ml/remote.php/webdav/DGIIM/2/1%C2%BA%20Cuatrimestre/estructura%20de%20computadores/Pr%C3%A1cticas%202017_2018/Practica%202/Popcount/TablasPopcount.xlsx) en cuestión. 
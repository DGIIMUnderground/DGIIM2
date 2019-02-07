#include <iostream>
#include <list>
#include <iterator> // advance

using namespace std;

/*
    Dada una lista de enteros l y 2 listas seq y reemp, construir una función que busque
todas las secuencias seq en l y las remplace por reemp.

    Por ejemplo, si
        l     = {1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5},
        seq   = {4, 5, 1},
        reemp = {9, 7, 3, 5};
    el resultado es
        l = {1, 2, 3, 9, 7, 3, 5, 2, 3, 9, 7, 3, 5, 2, 3, 4, 5}
*/

void reemplaza_lista (list<int>& l, const list<int>& seq, const list<int> reemp) {
    bool cambiar;

    for (list<int>::iterator it = l.begin(); it != l.end(); ++it) {
        cambiar = true;

        if ( *(it) == *(seq.begin()) ) {
            /*
                Una vez estamos ante una posible cadena, debemos comprobar que
                los siguientes números son exactamente iguales a los de reemplazo.

                Sin embargo, debemos contemplar un caso especial: una parte de la secuencia seq se encuentra justo al final de
                la cadena principal. Esto lo arreglamos mirando la distancia entre iteradores.

                Por ejemplo:
                    l   = {..., 4, 5}
                    seq = {4, 5, 1}

                Lo solventamos mirando la distancia entre el primero y el último. Esto lo podemos ver en el condicional de abajo
                En cualquier otro caso, lo más sencillo es mirar que los números seguidos son los correspondientes

                Este parche la verdad es que me parece feo pero no se me ocurre otra cosa ¯\_(ツ)_/¯
            */

            list<int>::iterator posicion_temporal = it;

            if ( distance(it, l.end()) < distance(seq.begin(), seq.end()) )
                cambiar = false;
            else {
                for (auto it_seq = seq.begin(); it_seq != seq.end(); ++it_seq) {
                    if (*it_seq != *it)
                        cambiar = false;
                    else
                        ++it;
                }
            }

            if (cambiar) {
                /* Consejo: mirar los siguientes enlaces para ver cómo funcionan erase e insert:
                http://www.cplusplus.com/reference/list/list/insert/
                http://www.cplusplus.com/reference/list/list/erase/ */

                list<int>::iterator desplazamiento = posicion_temporal;
                advance(desplazamiento, seq.size());

                l.erase(posicion_temporal, desplazamiento);
                l.insert(it, reemp.begin(), reemp.end());

                it--;
            }
        }
    }
}

int main() {
    list<int> l     = {1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5}
            , seq   = {4, 5, 1}
            , reemp = {9, 7, 3, 5};

    reemplaza_lista(l, seq, reemp);

    for (auto entero: l)
        cout << entero << " ";
}
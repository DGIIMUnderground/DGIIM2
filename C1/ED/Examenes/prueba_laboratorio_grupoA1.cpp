#include <iostream>
#include <set>
#include <ctime>
#include <cstdlib>
using namespace std;

// Por Andrés Millán Muñoz

///////////////////////////
//     Compilar con    ///
//        C++11        ///
//////////////////////////

/**
 * @brief Inicializar el generador de numero aleatorios
 *        Esta funcion debe ser llamada antes de usar rand
**/
void InicializarSemilla() { srand(time(0)); }
/**
 * @brief Genera numero enteros positivos aleatorios en el rango [min,max]
**/

int generaEntero(int min, int max){
    int tam= max -min+1;
    return ((rand()%tam)+min);
}

/**
 * @brief Imprime un conjunto de tipo T sobre el flujo de salida
 * @param s: flujo de salida. Es MODIFICADO
 * @param l: el conjunto con los elementos a imprimi
 * */
template <class T>
ostream & operator<<(ostream & s, const set<T> & c){
  typename set<T>::const_iterator i;


  for (i=c.begin(); i != c.end(); i++)
      s << (*i) << " ";
  
  return s;
}
///////////////////////////////////////////////////////////////////
/////////////////////    Funciones propias   /////////////////////
//////////////////////////////////////////////////////////////////
set<int> Union_triple(set<int> A, set<int> B, set<int> C){
    set<int> resultado;

    for (auto a:A)  resultado.insert(a);
    for (auto b:B)  resultado.insert(b);
    for (auto c:C)  resultado.insert(c);
    
    return resultado;
}

set<int> Interseccion_disjunta(set<int> A, set<int> B, set<int> C){
    set<int> resultado;

    // Elementos comunes de A y B que no están en C
    for (auto a:A)
        for (auto b:B)
            if (a==b && C.find(a) == C.end()) resultado.insert(a);
    
    // Elementos comunes de B y C que no están en A
    for (auto b:B)
        for (auto c:C)
            if (b==c && A.find(b) == A.end()) resultado.insert(b);
    
    // Elementos comunes de A y C que no están en B
    for (auto a:A)
        for (auto c:C)
            if (a==c && B.find(a) == B.end() ) resultado.insert(c);
    
    return resultado; 
}

int main(){
    InicializarSemilla();
  
    set<int>    A = {1,2,4,5,8}
            ,   B = {4,5,6,9}
            ,   C = {3,4,7,8,9};

    set<int>    union_triple          = Union_triple(A,B,C)
            ,   interseccion_disjunta = Interseccion_disjunta(A,B,C);

    cout <<"Unión: " << union_triple <<"\nIntersección disjunta: " << interseccion_disjunta;

  /* for (int i=0;i<10;i++)
    c.insert(generaEntero(1,100)); //inserta un entero generado aleatoriamente en el rango 1-100
  cout<<endl<<c; */
}  

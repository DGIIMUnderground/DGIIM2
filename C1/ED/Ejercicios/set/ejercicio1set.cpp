//By Mapachana
#include <iostream>
#include <set>

using namespace std;

//Unión de dos conjuntos
set<int> miunion(const set<int>& a, const set<int>& b){
    set<int> resultado = a;
    set<int>::iterator itb;
    for (itb = b.begin(); itb != b.end(); ++itb)
        if (a.find(*itb) == a.end())
            resultado.insert(*itb);

    return resultado;
}

//Intersección de dos conjuntos
set<int> miinterseccion(const set<int>& a, const set<int>& b){
    set<int> resultado;
    set<int>::iterator ita;
    for (ita = a.begin(); ita != a.end(); ++ita)
        if (b.find(*ita) != b.end())
            resultado.insert(*ita);

    return resultado;
}

//Complementario, a-b: devuelve los elementos de a que no estan en b
set<int> micomplementario(const set<int>& a, const set<int>& b){
    set<int> resultado;
    set<int>::iterator ita;
    for (ita = a.begin(); ita != a.end(); ++ita)
        if (b.find(*ita) == b.end())
            resultado.insert(*ita);

    return resultado;
}

//Sobrecarga del operador de salida para conjuntos
ostream& operator<<(ostream& os, const set<int>& a){
    set<int>::iterator ita;
    for (ita = a.begin(); ita != a.end(); ++ita)
        os << *ita << " ";
    os << endl;
    return os;
}

int main(){
    set<int> a;
    a.insert(1);
    a.insert(4);
    a.insert(2);
    a.insert(17);

    set<int> b;
    b.insert(2);
    b.insert(1);
    b.insert(5);
    b.insert(23);

    cout << "Conjunto a:" << endl;
    cout << a << endl;
    cout << "Conjunto b:" << endl;
    cout << b << endl;
    cout << "Union de a y b:" << endl;
    cout << miunion(a,b) << endl;
    cout << "Interseccion de a y b:" << endl;
    cout << miinterseccion(a,b) << endl;
    cout << "Elementos que estan en a y no en b:" << endl;
    cout << micomplementario(a,b) << endl;

    set<int> c;
    c.insert(2);
    c.insert(5);
    c.insert(4);
    c.insert(49);

    cout << "Conjunto c:" << endl;
    cout << c << endl;
    cout << "Interseccion de los 3:" << endl;
    cout << miinterseccion(miinterseccion(a,b), c) << endl;
    cout << "La interseccion de a y b sin la interseccion total es:" << endl;
    cout << micomplementario(miinterseccion(a,b), miinterseccion(miinterseccion(a,b),c)) << endl;
    cout << "La interseccion de a y c sin la interseccion total es:" << endl;
    cout << micomplementario(miinterseccion(a,c), miinterseccion(miinterseccion(a,b),c)) << endl;
    cout << "La interseccion de b y c sin la interseccion total es:" << endl;
    cout << micomplementario(miinterseccion(b,c), miinterseccion(miinterseccion(a,b),c)) << endl;
    cout << "La unión de los 3 sin la intersección total es:" << endl;
    cout << micomplementario(miunion(miunion(a,b),c), miinterseccion(miinterseccion(a,b),c)) << endl;
    cout << "La unión de las intersecciones disjuntas:" << endl;
    cout << miunion(miunion(miinterseccion(a,b),miinterseccion(a,c)), miinterseccion(b,c)) << endl;
    cout << "La unión de las intersecciones disjuntas que no están en la interseccin total:" << endl;
    cout << micomplementario(miunion(miunion(miinterseccion(a,b),miinterseccion(a,c)), miinterseccion(b,c)), miinterseccion(miinterseccion(a,b), c)) << endl;
}

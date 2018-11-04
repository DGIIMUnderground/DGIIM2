//By Juanjo
//Cualquier sugerencia y/o corrección de error se acepta amablemente.
#include <iostream>
#include <iterator>
#include <set>
#include <string>
using namespace std;

//La union esta implementada de dos formas distintas, en la funcion Union y en el operador+

set<int> Intersecion( const set<int> & a, const set<int>& b){

    set<int>::iterator ita;
    set<int> Inter;
    

    for( ita=a.begin(); ita!=a.end(); ++ita)
        if ( b.count(*ita) == 1)
            Inter.insert(*ita);
        

    return Inter;    

}

set<int> Union( const set<int> &a, const set<int> &b) {
    
    set<int>Union;
    set<int>::iterator ita, itb;

    ita = a.begin();
    itb = b.begin();
    int max= a.size() < b.size() ? b.size() : a.size();
    int i=0;
    
    while( i< max ){

        if ( ita!= a.end() )
            Union.insert(*ita);
        if ( itb != b.end() )
            Union.insert(*itb);
        ++i;
        ++ita;
        ++itb;
    }

    return Union;

}

void imprimir ( const set<int> &a){

    set<int>::iterator it;
    if( !a.empty() )
        for ( it=a.begin(); it!=a.end(); ++it )
            cout << *it << " ";
    else{
        cout << "Vacio";
    }    
    cout << endl;

}

set<int> operator+(const set<int> & a, const set<int> &b){ //Operador para la union

    set <int> res(a);
    for( set<int>::iterator it=b.begin(); it!= b.end(); ++it )
        res.insert(*it);

    return res;
}

//Hace el complementario dado dos conjuntos. A-B: Los elementos de A que no estén en B
set<int> operator-(const set<int> &A, const set<int> &B){

    set<int>resul(A);
    set<int>::iterator it;
    
    //Si algun elemento de A está en B, lo borramos
    for( it=resul.begin(); it!=resul.end(); ++it){
        if( B.find(*it) != B.end() )
            resul.erase(*it);
    }

    return resul;

}

/**
 * @brief Determina si un conjunto está incluido en otro
 * @param B Superconjunto
 
 * @param A Conjunto pequeño
 * @precond El conjunto B tiene que ser mas grande que el conjunto A
 * @return true si A incluido en B
 *         false en caso caso de no estarlo
 */
bool operator<(const set<int> & A, const set<int> &B){

    bool condicion=true;
    set<int>::iterator it;

    //Si la precondicion no se cumple devolvemos false
    if( A.size() > B.size() )
        return false;

    for( it=A.begin() ; it!=A.end(); ++it )
        if( B.find(*it) == B.end() )    
            condicion=false;
    
    return condicion;

}



int main(){

    //Creamos conjuntos A y B
    int eleA, eleB;
    set<int> A;
    set<int> B;
    cout << "Elementos conjunto A: ";
    cin >> eleA;
    
    cout << "Introduce elementos conjunto A: ";
    for ( int i = 0 ; i < eleA ; i++){
        int ele;
        cin >> ele;
        A.insert(ele); 
    }
    

    cout << "Elementos Conjunto B: ";
    cin >> eleB;

    int conB[eleB];
    cout << "Introduce elementos conjunto B: ";
    for ( int i = 0 ; i < eleB ; i++){
        int ele;
        cin >> ele;
        B.insert(ele);
    }
    
    
    //OPERACIONES
    set<int> operacion;

        //INTERSECCION
    cout << "\nInterseccion: ";
    operacion=Intersecion(A,B);
    imprimir(operacion);

        //UNION
    cout << "\nUnion: ";
    operacion=A+B; //Equivalente a hacer Union(A,B)
    imprimir(operacion);

        //COMPLEMENTARIO
    cout << "\nComplementario A-B: ";
    operacion=A-B;
    imprimir(operacion);
    cout << "\nComplementario B-A: ";
    operacion=B-A;
    imprimir(operacion);

        //INCLUSION
    if( A < B )
        cout << "\nA incluido en B" << endl;
    else
        if( B < A )
            cout << "\nB incluido en A" << endl;
        else 
            cout << "\n No hay inclusion por parte de ningun conjunto" << endl;

    
    
    
    
    
}

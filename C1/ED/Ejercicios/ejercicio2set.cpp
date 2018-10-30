// Ejemplo de como afecta la delcaración cambiando la palabra de orden con el tipo set.
// By Mapachana

#include <iostream>
#include <set>

using namespace std;

set <int> uniones (set <int> aa, set <int> bb){
	set <int> ::iterator ita;
	set <int> ::iterator itb;
	set <int> c;
	c = aa;
	for (ita = aa.begin(); ita != aa.end(); ++ita)
		for (itb = bb.begin(); itb != bb.end(); ++itb)
			if (*itb != *ita)
				c.insert(*itb);
	return c;

}

set <int> intersecciones (set <int> aa, set <int> bb){
	set <int> ::iterator ita;
	set <int> ::iterator itb;
	set <int> c;
	for (ita = aa.begin(); ita != aa.end(); ++ita)
		for (itb = bb.begin(); itb != bb.end(); ++itb)
			if (*ita == *itb)
				c.insert(*itb);
	return c;
}


int main(){
	set <int> a;
	a.insert(2);
	a.insert(4);
	a.insert(5);
	a.insert(1);
	a.insert(3);

	cout << "Mi conjunto normal: " << endl;
	set <int> ::iterator it;
	for (it = a.begin(); it != a.end(); ++it){
		cout << " " << *it;
	}
	cout << endl;

	set <int, greater<int> > b;
	b.insert(2);
	b.insert(4);
	b.insert(5);
	b.insert(1);
	b.insert(3);

	cout << "Mi conjunto con greater: " << endl;
	set <int> ::iterator itt;
	for (itt = b.begin(); itt != b.end(); ++itt){
		cout << " " << *itt;
	}
	cout << endl;

	set <int, less <int> > c;
	c.insert(2);
	c.insert(4);
	c.insert(5);
	c.insert(1);
	c.insert(3);

	cout << "Mi conjunto con less: " << endl;
	set <int, less <int> > ::iterator ittt;
	for (ittt = c.begin(); ittt != c.end(); ittt++){
		cout << " " << *ittt;
	}
	cout << endl;

}


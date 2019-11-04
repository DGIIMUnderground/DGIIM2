/**
 * @file ingrediente.cpp
 * @brief Implementación de la clase ingrediente::ingrediente.
 */

#include "ingrediente.h"
#include<iostream>
#include<string>

using namespace std;


void ingrediente::setNombre(const std::string& n){
	if(n!="")
		nombre = n;
	else {
		cerr << "ERROR: Nombre inválido" << endl;
		exit(1);
	}
}

void ingrediente::setCalorias(const double& c){
    if(c >= 0)
		calorias = c;
	else {
		cerr << "ERROR: Calorías inválidas" << endl;
		exit(1);
	}
}

void ingrediente::setHc(const double& nhc){
	if(nhc >= 0)
		hc = nhc;
	else {
		cerr << "ERROR: Hidratos carb. inválidos" << endl;
		exit(1);
	}
}

void ingrediente::setProteinas(const double& p){
    if(p >= 0)
		proteinas = p;
	else {
		cerr << "ERROR: Proteínas inválidas" << endl;
		exit(1);
	}
}

void ingrediente::setGrasas(const double& g){
	if(g >= 0)
		grasas = g;
	else {
		cerr << "ERROR: Grasas inválidas" << endl;
		exit(1);
	}
}

void ingrediente::setFibra(const double& f){
	if(f >= 0)
		fibra = f;
	else {
		cerr << "ERROR: fibra inválida" << endl;
		exit(1);
	}
}

void ingrediente::setTipo(const std::string& ntipo){
    if( ntipo != "")
		tipo = ntipo;
	else {
		cerr << "ERROR: tipo inválido" << endl;
		exit(1);
	}
}

ingrediente::ingrediente() {
	nombre="Undefined";
	tipo="Undefined";
	calorias=-1;
	hc=-1;
	proteinas=-1;
	grasas=-1;
	fibra=-1;
}

ingrediente::ingrediente(const ingrediente& otro) {
	nombre=otro.getNombre();
	tipo=otro.getTipo();
	calorias=otro.getCalorias();
	hc=otro.getHc();
	proteinas=otro.getProteinas();
	grasas=otro.getGrasas();
	fibra=otro.getFibra();
}

ostream &operator<<( ostream &out, const ingrediente& I) {
	char pc = ';';
	out << I.getNombre() << pc << I.getCalorias() << pc << I.getHc() << pc << I.getProteinas() << pc << I.getGrasas() << pc << I.getFibra() << pc << I.getTipo() << endl;

	return out;
}

istream &operator>>( istream &in, ingrediente& I) {
	string tmp;

	getline(in ,tmp, ';');
	I.setNombre(tmp);
	getline(in ,tmp, ';');
	I.setCalorias(atof(tmp.c_str()));
	getline(in ,tmp, ';');
	I.setHc(atof(tmp.c_str()));
	getline(in ,tmp, ';');
	I.setProteinas(atof(tmp.c_str()));
	getline(in ,tmp, ';');
	I.setGrasas(atof(tmp.c_str()));
	getline(in ,tmp, ';');
	I.setFibra(atof(tmp.c_str()));
	getline(in ,tmp);
	I.setTipo(tmp);

	return in;
}

ingrediente& ingrediente::operator= (const ingrediente& original) {
	nombre = original.getNombre();
	tipo = original.getTipo();
	calorias = original.getCalorias();
	hc = original.getHc();
	proteinas = original.getProteinas();
	grasas = original.getGrasas();
	fibra = original.getFibra();

	return *this;
}

/**
 * @file VD.cpp
 * @brief Implementación de la clase @c VD.
 */

template <class T>
VD<T>::VD(int n) {
	if(n >= 0) { 
		datos = (n==0)?nullptr:new T[n];
		nelementos = n;
	}
	else {
		std::cerr << "El número de elementos debe ser positivo" << std::endl;
		std::exit(1);
	}
}

template <class T>
VD<T>::VD(const VD& original) {
	nelementos=0;
	if (original.nelementos > 0) {
		resize(original.nelementos);
		for (int i = 0; i  < original.nelementos; ++i)
			datos[i] = original.datos[i];
	}
	else 
		datos = nullptr;
}

template <class T>
VD<T>::~VD() {
	if (datos != nullptr) {
		delete [] datos;
		datos = nullptr;
	}
}

template <class T>
unsigned VD<T>::size() const {
	return (unsigned) nelementos;
}

template <class T>
T& VD<T>::operator[](int i) {
	if ( 0 <= i && i < nelementos)
		return datos[i];
	else {
		std::cerr << "Índice inválido" << std::endl;
		std::exit(1);
	}
}

template <class T>
const T& VD<T>::operator[](int i) const {
	if ( 0 <= i && i < nelementos)
		return datos[i];
	else {
		std::cerr << "Índice inválido" << std::endl;
		std::exit(1);
	}	
}

template <class T>
void VD<T>::resize(int n) {
	if (n >= 0){
		if (n != nelementos) {
			if (n != 0) {
				T* nuevos_datos = new T[n];
				if(nelementos > 0) {
					int minimo = (nelementos<n) ? nelementos : n;
					for (int i=0; i < minimo; ++i) 
						nuevos_datos[i] = datos[i];
					delete [] datos;
				}
				nelementos = n;
				datos = nuevos_datos;
			}
			else {
				if (datos != nullptr) {
					delete [] datos;
					datos = nullptr;
				}
				nelementos = 0;
			}		
		}
	}
	else {
		std::cerr << "El nuevo tamaño debe ser positivo" << std::endl;
		std::exit(1);
	}
}

template <class T>
VD<T>& VD<T>::operator= (const VD& original) {
	if (this != &original) {
		if (nelementos > 0) 
			delete [] datos;
		nelementos = original.nelementos;
		datos = new T[nelementos];
		for (int i = 0; i < nelementos; ++i)
			datos[i] = original.datos[i];
	}
	return *this;
}

template <class T>
void VD<T>::add(T nuevo) {
	resize(size()+1);
	datos[size()-1] = nuevo;
}

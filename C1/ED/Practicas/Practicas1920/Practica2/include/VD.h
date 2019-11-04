/**
 * @file VD.h
 * @brief Archivo cabecera para la clase template @c VD
 */
#ifndef VDinclude
#define VDinclude

#include<iostream>
/**
 * @brief Clase para representar un vector dinámico de datos.
 *
 * Representa un vector dinámico de datos mediante un puntero y un indicador del número 
 * de elementos.
 */
template <class T>
class VD {
	private:
		/**
		 * @brief Vector que almacena los datos.
		 *
		 * Este puntero apuntará a un vector dinámico que almacenará los datos que se
		 * manejen en la clase.
		 */
		T* datos;
		/**
		 * @brief Tamaño de @a datos.
		 *
		 * Este entero almacena el número total de elementos del vector.
		 */
		int nelementos;
	public:
		/**
		 * @brief Constructor por defecto y parametrizado con número de elementos. 
		 *
		 * Este constructor inicializa el vector @a datos y @a nelementos con 
		 * @a n número de elementos, haciendo la reserva de memoria pertinnente.
		 *
		 * @param "int n=0" Número de elementos del vector, en caso de no proporcionarse
		 * argumento, se inicializa a 0 (@c nullptr).
		 * @pre @a n debe ser positivo.
		 * @post Se reserva memoria para @a n elementos.
		 */
		VD(int n=0);
		/**
		 * @brief Constructor de copia.
		 *
		 * Copia todos los elementos de @a original en @a this. Reserva memoria
		 * adecuadamente.
		 *
		 * @param "const VD& original" Objeto que se copiará.
		 * @post Ahora @a this es igual a @a original.
		 */
		VD(const VD& original);
		/**
		 * @brief Destructor de la clase.
		 *
		 * Libera la memoria en uso.
		 */
		~VD();

		/**
		 * @brief Devuelve el tamaño del vector.
		 *
		 * Devuele @a nelementos, que es el tamaño del vector.
		 *
		 * @retval unsigned Tamaño del vector.
		 */
		unsigned size() const;
		/**
		 * @brief Añade un nuevo elemento al final del vector.
		 *
		 * Reserva memoria para @a nelementos +1 y añade @a nuevo en la última posición.
		 *
		 * @param "T nuevo" El nuevo elemento a añadir.
		 * @post El vector ahora contiene al nuevo elemento al final.
		 */
		void add(T nuevo);
		/**
		 * @brief Redimensiona el vector.
		 *
		 * Este método redimensiona el vector para que tenga @a n elementos. Si @a n es
		 * mayor que @a nelementos, se copia todo el vector y se dejan vacías las últimas
		 * posiciones. Si @a n es menor que @a nelementos, se eliminan las últimas
		 * posiciones.
		 *
		 * @pre @a n debe ser positivo.
		 * @post Ahora @a datos contiene @a n elementos. @c nelementos @c = @c n.
		 */
		void resize(int n);
		/**
		 * @brief Sobrecarga del operador=
		 *
		 * Este operador sobrecargado asigna a @a this el contenido de @a original, 
		 * realizando toda la gestión de memoria pertinente.
		 *
		 * @param "const VD& original" El objeto que se copiará
		 * @retval "VD<T>&" El objeto copiado (@c *this)
		 * @post @c this @c == @c original.
		 */
		VD<T>& operator= (const VD<T>& original);
		/**
		 * @brief Sobrecarga del operador[].
		 *
		 * Este operador accede a la i-ésima posición de @a datos.
		 *
		 * @pre @a i debe ser un índice válido @f$i \ge 0@f$ y @f$i < nelementos@f$
		 */
		T& operator[](int i);
		/**
		 * @brief Sobrecarga constante del operador[].
		 *
		 * Realiza la misma función que @c operator[]() pero devolviendo una referencia
		 * constante y sin alterar los datos.
		 * @see VD::operator[]()
		 */
		const T& operator[](int i) const;
};

#include "VD.cpp"

#endif

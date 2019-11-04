/**
 * @file ingrediente.h
 * @brief Cabecera de la clase @c ingrediente::ingrediente.
 *
 * Esta clase se utiliza para guardar la información sobre un ingrediente de cocina.
 */
#ifndef INGREDIENTE
#define INGREDIENTE

#include<string>
#include<iostream>

/**
 * @brief Clase Utilizada para representar un ingrediente.
 *
 * Esta clase representa un ingrediente valiéndose de dos @c string y de cinco @c double
 * que representan el nombre, el tipo, y los macronutrientes del ingrediente,
 * respectivamente. 
 *
 * Nótese que los miembros @a getter se han declarado como @a inline para mejorar la 
 * eficiencia en memoria de esta clase. También se destaca que los @a setters incluyen un 
 * control básico de los parámetros, abortando si son inválidos.
 *
 * La restricción que se impone a esta clase es que los @c string tengan valores no nulos
 * y los @c double sean positivos @f$(>=0)@f$.
 */
class ingrediente {
	public:
		/**
		 * @brief Método para obtener el nombre de un ingrediente.
		 * @retval string Nombre del ingrediente.
		 */
		inline std::string getNombre() const { return nombre; };
		/**
		 * @brief Método para obtener el Tipo de un ingrediente.
		 *
		 * @retval string Tipo del ingrediente.
		 */
		inline std::string getTipo() const { return tipo; };
		/**
		 * @brief Método para obtener las calorías de un ingrediente por cada 100 gramos del mismo.
		 *
		 * @retval double Las calorías por 100g de ingrediente.
		 */
		inline double getCalorias() const { return calorias; };
		/**
		 * @brief Método para obtener los hidratos de carbono de un ingrediente por cada 100 gramos del mismo.
		 *
		 * @retval double Los hidratos de carbono por 100g de ingrediente.
		 */
		inline double getHc() const { return hc; };
		/**
		 * @brief Método para obtener las proteínas de un ingrediente por cada 100 gramos del mismo.
		 *
		 * @retval double Las proteínas por 100g de ingrediente.
		 */
		inline double getProteinas() const { return proteinas; };
		/**
		 * @brief Método para obtener las grasas de un ingrediente por cada 100 gramos del mismo.
		 *
		 * @retval double Las grasas por 100g de ingrediente.
		 */
		inline double getGrasas() const { return grasas; };
		/**
		 * @brief Método para obtener la fibra de un ingrediente por cada 100 gramos del mismo.
		 *
		 * @retval double La fibra por 100g de ingrediente.
		 */
		inline double getFibra() const { return fibra; };
		/**
	     * @brief Modifica el nombre del ingrediente.
	     * @param "const std::string& n" El nuevo nombre. 
	     */    
	    void setNombre(const std::string& n);
	    /**
	     * @brief Modifica la cantidad calorías por cada 100 gramos del ingrediente.
	     * @param "const double& c" La nueva cantidad de calorías por cada 100 gramos.
	     */
	    void setCalorias(const double& c);
	    /**
	     * @brief Modifica la cantidad de hidratos de carbono por cada 100 gramos del ingrediente.
	     * @param "const double& hc" La nueva cantidad de hidratos de carbono por cada 100 gramos.
	     */
	    void setHc(const double& hc);
	    /**
	     * @brief Modifica la cantidad de proteinas por cada 100 gramos del ingrediente.
	     * @param "const double& p" La nueva cantidad de proteinas por cada 100 gramos.
	     */
	    void setProteinas(const double& p);
	    /**
	     * @brief Modifica la cantidad de grasas por cada 100 gramos del ingrediente.
	     * @param "const double& g" La nueva cantidad de grasas por cada 100 gramos.
	     */
	    void setGrasas(const double& g);
	    /**
	     * @brief Modifica la cantidad de fibra por cada 100 gramos del ingrediente.
	     * @param "const double& f" La nueva cantidad de fibra por cada 100 gramos.
	     */
	    void setFibra(const double& f);
	    /**
	     * @brief Modifica el tipo del ingrediente.
	     * @param "const std::string& tipo" El nuevo tipo.
	     */
	    void setTipo(const std::string& tipo);
		/**
		 * @brief Constructor por defecto. 
		 *
		 * Inicializa:
		 *	- @a nombre a @c "Undefined"
		 *	- @a tipo a @c "Undefined"
		 *	- @a calorias a @c -1
		 *	- @a hc a @c -1
		 *	- @a proteinas a @c -1
		 *	- @a grasas a @c -1
		 *	- @a fibra a @c -1
		 *
		 *	De esta forma podemos en cualquier punto del programa comprobar si el objeto 
		 *	que teneemos está inicializado comprobando si el nombre no es @c "Undefined", 
		 *	se puede ver un ejemplo en @c test_ingredientes.cpp @see src/test_ingredientes.cpp
		 */
		ingrediente();

		/**
		 * @brief Constructor de copia.
		 *
		 * Este constructor toma como parámetro un objeto de tipo @a ingrediente y copia
		 * todos los datos miembros al nuevo objeto que estamos construyendo.
		 *
		 * @param "const ingrediente & otro" El ingrediente a copiar.
		 */
		ingrediente(const ingrediente & otro);

		/**
		 * @brief Sobrecarga del operador de asignación.
		 *
		 * Este operador sobrecargado asigna a todos los miembros del ingrediente en el 
		 * lado izquierdo el valor de los miembros del ingrediente del lado derecho.
		 *
		 * @param "const ingrediente& original" El ingrediente al lado derecho del igual.
		 * @retval ingrediente& Referencia al objeto ingrediente, necesaria para 
		 * encadenar varias expresiones de asignación.
		 */
		ingrediente& operator= (const ingrediente& original);

		/**
		 * @brief Sobrecarga del operador de salida.
		 *
		 * Este operador envía al buffer de salida la información del objeto @a
		 * ingrediente siguiendo la siguiente convención:
		 *
		 * @c "nombre;calorias;hc;proteinas;grasas;fibra;tipo"
		 *
		 * @note Hay que incluir un salto de línea. En esta implementación lo hemos hecho
		 * con @c std::endl.
		 *
		 * @param "std::ostream & out" Búffer de salida.
		 * @param "const ingrediente & I" ingrediente que se envía al búffer.
		 * @retval "std::ostream&" Flujo de salida. Necesario para encadenar los
		 * operadores.
		 */
		friend std::ostream& operator<<( std::ostream & out, const ingrediente & I);
		/**
		 * @brief Sobrecarga del operador de entrada.
		 *
		 * Este operador está sobre todo pensado para usarlo con ficheros de texto plano,
		 * no para interactuar con el usuario por pantalla. Se ha implementado usando @c 
		 * getline con el delimitador @c ; tal y como se explica en el otro operador de 
		 * flujo. Para convertir las cadenas a @c double usamos @c atof() y @c c_str().
		 */
		friend std::istream& operator>>( std::istream & in, ingrediente & I);
		
	private:
		/**
		 * @brief Nombre del ingrediente.
		 */
		std::string nombre;
		/**
		 * @brief Tipo del ingrediente.
		 */
		std::string tipo;
		/**
		 * @brief Calorías por 100g de ingrediente.
		 */
		double calorias;
		/**
		 * @brief Hidratos de Carbono por 100g de ingrediente.
		 */
		double hc;
		/**
		 * @brief Proteínas por 100g de ingrdiente.
		 */
		double proteinas;
		/**
		 * @brief Grasas por 100g de ingrediente.
		 */
		double grasas;
		/**
		 * @brief Fibra por 100g de ingrediente.
		 */
		double fibra;
};

#endif

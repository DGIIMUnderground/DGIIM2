/**
 * @file tipos_ingredientes.cpp
 * @brief Archivo para obtener información sobre un tipo de ingredientes.
 *
 * Este programa toma una lista de ingredientes y un tipo de ingredientes como argumento 
 * y devuelve información detallada de los ingredientes de dicho tipo. 
 *
 * Concretamente, devuelve:
 *
 * - Una lista de todos los tipos ingredientes encontrados.
 * - Una lista de todos los ingredientes del tipo pedido.
 * - Información estadística sobre los ingredientes del tipo pedido:
 *   + El nombre del tipo.
 *   + La media de los valores de cada macronutriente
 *   + La desviación típica de los valores de cada macronutriente.
 *   + El máximo valor de cada macronutriente y el ingrediente que lo tiene.
 *   + El mínimo valor de cada macronutriente y el ingrediente que lo tiene.
 *
 * @note Los macronutrientes son Calorías, Hidratos de Carbono, Grasas, Proteínas y Fibra.
 */

#include <iostream>
#include "ingrediente.h"
#include "ingredientes.h"
#include <fstream>
#include <cmath>

using namespace std;

/**
 * @brief Método para mostrar los parámetros de uso.
 *
 * Muestra cómo debe usarse el programa. Esto es:
 *
 * @c "<ejecutable> <fichero ingredientes> <tipo a procesar>" 
 */
void MuestraParametros();
/**
 * @brief Calcula la media de un conjunto de datos.
 *
 * Esta función calcula la media de los datos contenidos en el vector @a valores.
 * @pre @a valores debe ser no vacío, de lo contrario devuelve 0.
 * @param "const VD<double>& valores" Vector de datos sobre el que se calcula la media.
 * @retval double La media de los elementos de @a valores.
 */
double media(const VD<double>& valores);
/**
 * @brief Calcula la desviación típica de un conjunto de datos.
 *
 * Esta función calcula la desviación típica de los datos contenidos en @a valores.
 * Para ello se vale de la función @c media(). 
 *
 * @pre @a valores debe ser no vacío. De lo contrario devuelve 0 
 * @param "const VD<double>& valores" Vector de datos sobre el que se calcula la
 * desviación típica.
 * @retval double La desviación típica de los elementos de @a valores.
 */
double desviacion(const VD<double>& valores);
/**
 * @brief Halla el valor máximo del vector dado.
 *
 * Esta función encuentra el máximo valor en @a valores. De haber varios devuelve la 
 * primera ocurrencia.
 *
 * @pre @a valores debe ser no vacío, de lo contrario la función devuelve @c "{0,0}"
 * @param "const VD<double>& valores" El vector en el que se busca un máximo.
 * @retval VD<double> Vector que contiene la posición del máximo y su valor, en ese orden.
 */
VD<double> maximo(const VD<double>& valores);
/**
 * @brief Halla el mínimo del vector dado.
 *
 * Esta función encuentra el mínimo valor en @a valores. De haber varios devuelve la 
 * primera ocurrencia.
 *
 * @pre @a valores debe ser no vacío, de lo contrario la función devuelve @c "{0,0}"
 * @param "const VD<double>& valores" El vector en el que se busca un mínimo.
 * @retval VD<double> Vector que contiene la posición del mínimo y su valor, en ese orden.
 */
VD<double> minimo(const VD<double>& valores);

/**
 * @brief Función para hallar media, des. típica, máximo y mínimo del vector.
 *
 * Esta función realiza llamadas a @c media() @c desviacion() @c maximo() y @c minimo(),
 * pasando valores como argumento a todas ellas y almacenando los resultados en un vector
 * con la siguiente convención:
 *
 * - Posición 0: Media.
 * - Posición 1: Desviación Típica.
 * - Posición 2: Posición del Máximo en @a valores.
 * - Posicion 3: Valor del Máximo.
 * - Posicion 4: Posición del Mínimo en @a valores.
 * - Posicion 5: Valor del Mínimo.
 *
 * @param "const VD<double>& valores" Vector de datos.
 * @pre @a valores debe ser no vacío.
 * @retval VD<double> Vector conteniendo los resultados según la convención especificada.
 * @see media() desviacion() maximo() minimo()
 */
VD<double> estadistica(const VD<double>& valores);

/**
 * @brief Variable global para almacenar el número de macronutrientes.
 */
const unsigned NNUTRIENTES=5; // Número de macronutrientes.

/**
 * @brief Toma los datos del fichero con nombre @a argv[1] y los procesa buscando el 
 * tipo @a argv[2]
 */
int main(int argc, char *argv[]) {
	/// Primeramente se comprueba si los argumentos son correctos.
	if (argc != 3) {
		MuestraParametros();
		return 1;
	}

	/// Después se abre el archivo con los controles de seguridad correspondientes, y 
	/// se cargan los datos en memoria.
	string archivo=argv[1];
	string tipo=argv[2];
	ifstream f(archivo);

	if(!f) {
		cerr << "ERROR: No se ha podido abrir el archivo" << endl;
		return 1;
	}

	ingredientes all_ingre;
	f >> all_ingre;

	/// Luego se muestran por pantalla los tipos encontrados y los ingredientes del tipo
	/// pedido.
	VD<string> tipos_total=all_ingre.getTipos();

	cout << "Los tipos encontrados son: " << endl;
	for (unsigned i=0; i<tipos_total.size(); ++i)
		cout << tipos_total[i] << endl;
	
	ingredientes tipo_pedido(all_ingre.getIngredienteTipo(tipo));

	cout << endl << "Los ingredientes de tipo " << tipo << " son: " << endl;
	cout << tipo_pedido << endl;

	/// A continuación se procesan los ingredientes del tipo pedido y sus datos 
	/// estadísticos, que se almacenan en una matriz bidimensional para su posterior
	/// manejo y salida por pantalla. 
	VD<VD<double>> macronutrientes;
	VD<VD<double>> medidas;
	macronutrientes.resize(NNUTRIENTES);
	medidas.resize(NNUTRIENTES);

	for (unsigned i=0; i < NNUTRIENTES; ++i) {
		macronutrientes[i].resize(tipo_pedido.size());
		for (unsigned j=0; j < macronutrientes[i].size(); ++j) {
			switch (i) {
				case 0:
					macronutrientes[i][j] = tipo_pedido[j].getCalorias();
					break;
				case 1:
					macronutrientes[i][j] = tipo_pedido[j].getHc();
					break;
				case 2:
					macronutrientes[i][j] = tipo_pedido[j].getProteinas();
					break;
				case 3:
					macronutrientes[i][j] = tipo_pedido[j].getGrasas();
					break;
				case 4:
					macronutrientes[i][j] = tipo_pedido[j].getFibra();
					break;
				default:
					cerr << "Switch por defecto, nutriente no reconocido" << endl;
			}
		}
	}
	
	for (unsigned i=0; i < medidas.size(); ++i)
		medidas[i]=estadistica(macronutrientes[i]);

	/** La matriz que queda es del tipo:
	 *
	 * | Índice | Macronutriente		| 0: Media | 1: Desviación Típica | 2: Posición Máximo | 3: Máximo | 4: Posición Mínimo | 5: Mínimo |
	 * |:------:|:----------------------|:--------:|:--------------------:|:------------------:|:---------:|:------------------:|:---------:|
	 * | 0		| Calorías				|		   |					  |					   |		   |					|			|
	 * | 1		| Hidratos de Carbono	|		   |					  |					   |		   |					|			|
	 * | 2		| Proteínas				|		   |					  |					   |		   |					|			|
	 * | 3		| Grasas				|		   |					  |					   |		   |					|			|
	 * | 4		| Fibra					|		   |					  |					   |		   |					|			|
	 * --------------------------------------------------------------------------------------------------------------------------------------
	 *
	 *  Usamos esta información y le damos formato para sacarla por pantalla, según lo 
	 *  especificado en el guión de la práctica.
	 */

	string t="\t",pm="+-";

	cout << "Estadística ___________________________________" << endl;
	cout << "Tipo de Alimento " << tipo << endl;

	cout << endl << "Promedio +- Desviación" << endl;
	cout << "Calorías\tHidratos de Carb\tProteínas\tGrasas\tFibra" << endl;
	
	for (unsigned i=0; i < 5; ++i)
		cout << medidas[i][0] << pm << medidas[i][1] << t;
	cout << endl;

	cout << endl << "Máximos Valores" << endl;
	cout << "Calorías (Alimento)\tHidratos de Carb (Alimento)\tProteínas (Alimento)\tGrasas (Alimento)\tFibra (Alimento)" << endl;

	for (unsigned i=0; i < 5; ++i)
		cout << medidas[i][3] << " ("<< tipo_pedido[medidas[i][2]].getNombre() << ")" << t;
	cout << endl;

	cout << endl << "Mínimos Valores" << endl;
	cout << "Calorías (Alimento)\tHidratos de Carb (Alimento)\tProteínas (Alimento)\tGrasas (Alimento)\tFibra (Alimento)" << endl;

	for (unsigned i=0; i < 5; ++i)
		cout << medidas[i][5] << " (" << tipo_pedido[medidas[i][4]].getNombre() << ")" << t;
	cout << endl;

	return 0;
}

void MuestraParametros() {
	cout << "\tNúmero de parámetros incorrecto." << endl;
	cout << "\tUso correcto: " << endl;
	cout << "\t\t./tipos_ingredientes <fichero de datos> <tipo a procesar>" << endl;
}

double media(const VD<double>& valores) {
	double res=0;
	
	for (unsigned i=0; i < valores.size(); ++i)
		res+=valores[i];
	if(valores.size()!=0)
		res /= (double)valores.size();
	
	return res;
}

double desviacion(const VD<double>& valores) {
	double m = media(valores);
	VD<double> dist(valores);
	
	for (unsigned i=0; i < dist.size(); ++i)
		dist[i] = (dist[i]-m)*(dist[i]-m);
	double var = media(dist);
	
	return sqrt(var);
}

VD<double> maximo(const VD<double>& valores) {
	double max=0;
	unsigned pmax=0;
	
	for (unsigned i=0; i < valores.size(); ++i) 
		if (valores[i] > max) {
			max = valores[i];
			pmax = i;
		}
	
	VD<double> res;
	res.add((double)pmax);
	res.add(max);
	
	return res;
}

VD<double> minimo(const VD<double>& valores) {
	double min;
	unsigned pmin;

	min = (valores.size()>0)?valores[0]:0;
	pmin = 0;
	for (unsigned i=0; i < valores.size(); ++i)
		if (valores[i] < min) {
			min = valores[i];
			pmin = i;
		}
	
	VD<double> res;
	res.add((double)pmin);
	res.add(min);
	
	return res;
}

VD<double> estadistica(const VD<double>& valores) {
	VD<double> resultado;

	resultado.resize(6);

	resultado[0]=media(valores);		// Media
	resultado[1]=desviacion(valores);	// Desviación Típica
	resultado[2]=maximo(valores)[0];	// Posicion del máximo
	resultado[3]=maximo(valores)[1];	// Valor del máximo
	resultado[4]=minimo(valores)[0];	// Posición del mínimo
	resultado[5]=minimo(valores)[1];	// Valor del mínimo

	return resultado;
}

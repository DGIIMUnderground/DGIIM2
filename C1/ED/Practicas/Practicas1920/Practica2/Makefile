# MAKEFILE.
# Autor: Alejandro Villanueva Prados.
# Modificada de un Makefile anterior entregado por el profesor de prácticas F. David Charte Luque.

SRC = src
INC = include
OBJ = obj
BIN = bin
CXX = g++
WARN = -Wall -Wpedantic -Wextra # Añadir si se quieren warnings detalladas
								# Nota: una de ellas salta en test_ingredientes debido a mi elección de valores de retorno del metodo size().
CPPFLAGS = -g -I$(INC) -c --std=c++11 
all:$(BIN)/test_ingredientes $(BIN)/tipos_ingredientes

# ************ Generación de documentación ******************
documentacion:
	doxygen doc/doxys/Doxyfile
	
# ************ Compilación de módulos ************


$(BIN)/test_ingredientes: $(OBJ)/test_ingredientes.o $(OBJ)/ingredientes.o $(OBJ)/ingrediente.o
	$(CXX) -o $(BIN)/test_ingredientes $(OBJ)/test_ingredientes.o $(OBJ)/ingredientes.o $(OBJ)/ingrediente.o 

$(BIN)/tipos_ingredientes: $(OBJ)/tipos_ingredientes.o $(OBJ)/ingredientes.o $(OBJ)/ingrediente.o
	$(CXX) -o $(BIN)/tipos_ingredientes $(OBJ)/tipos_ingredientes.o $(OBJ)/ingredientes.o $(OBJ)/ingrediente.o

$(OBJ)/test_ingredientes.o: $(SRC)/test_ingredientes.cpp $(INC)/ingrediente.h $(INC)/ingredientes.h
	$(CXX) $(CPPFLAGS) $(SRC)/test_ingredientes.cpp -o $(OBJ)/test_ingredientes.o 

$(OBJ)/tipos_ingredientes.o: $(SRC)/tipos_ingredientes.cpp $(INC)/ingrediente.h $(INC)/ingredientes.h
	$(CXX) $(CPPFLAGS) $(SRC)/tipos_ingredientes.cpp -o $(OBJ)/tipos_ingredientes.o 

$(OBJ)/ingredientes.o: $(SRC)/ingredientes.cpp $(INC)/ingredientes.h $(INC)/ingrediente.h
	$(CXX) $(CPPFLAGS) $(SRC)/ingredientes.cpp -o  $(OBJ)/ingredientes.o 	

$(OBJ)/ingrediente.o: $(SRC)/ingrediente.cpp $(INC)/ingrediente.h 
	$(CXX) $(CPPFLAGS) $(SRC)/ingrediente.cpp -o  $(OBJ)/ingrediente.o 	
	
# ************ Limpieza ************
clean :
	-rm -f $(OBJ)/* $(SRC)/*~ $(INC)/*~ ./*~

mrproper : clean
	-rm -rf $(BIN)/* doc/html/ doc/latex/

# ************ Entrega *************
entrega: all mrproper
	-rm -f practica2.tgz
	tar -czvf practica2.tgz \
		--exclude-vcs --exclude-vcs-ignores --exclude='datos/*' \
		--exclude='README.md' --exclude='practica2.tgz' \
		../`basename $(PWD)` 

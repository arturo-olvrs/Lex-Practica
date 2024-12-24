# Variables
FLEX = flex++  # Usa flex++ para generar código C++
COMPILER = g++  # Compilador C++
FLAGS = -std=c++11 -g -Wall  # Flags para el compilador
INPUT_FILE = cuentas.txt  # Archivo de entrada
EXEC_NAME = prueba_bancos  # Nombre del ejecutable

# Regla para ejecutar flex++ y generar el código C++ (lex.yy.cc)
bancos: regex_bancos_exe
	./$< $(INPUT_FILE)  

regex_bancos.cpp: regex_bancos.l
	$(FLEX) $<
	mv lex.yy.cc regex_bancos.cpp

# Regla para compilar el código C++ generado por flex++
%_exe: %.cpp
	$(COMPILER) $(FLAGS) $< -o $@ -lfl 

# Limpiar los archivos generados
clean:
	rm -f prueba_bancos lex.yy.cc

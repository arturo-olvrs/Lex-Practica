# Variables
FLEX = flex++  # Usa flex++ para generar código C++
COMPILER = g++  # Compilador C++
FLAGS = -std=c++11 -g -Wall  # Flags para el compilador

# ----------------------------------------------
INPUT_FILE_BANCO = Bancos/cuentas.txt  # Archivo de entrada
INFO_FILE_BANCO = Bancos/Cods_Bancos.csv  # Archivo de información

# Regla para ejecutar flex++ y generar el código C++ (lex.yy.cc)
bancos: Bancos/regex_bancos_exe	$(INFO_FILE_BANCO)
	./$< $(INFO_FILE_BANCO) $(INPUT_FILE_BANCO)  

Bancos/regex_bancos.cpp: Bancos/regex_bancos.l
	$(FLEX) $<
	mv lex.yy.cc Bancos/regex_bancos.cpp

# ----------------------------------------------
dni: 



# Regla para compilar el código C++ generado por flex++
%_exe: %.cpp
	$(COMPILER) $(FLAGS) $< -o $@ -lfl 

# Limpiar los archivos generados
clean:
	rm -rf */*_exe */*.cpp

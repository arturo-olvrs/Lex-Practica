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
INPUT_FILE_DNI-NIE = DNI-NIE/dni-nie.txt  # Archivo de entrada

# Regla para ejecutar flex++ y generar el código C++ (lex.yy.cc)
dni-nie: DNI-NIE/regex_dni-nie_exe
	./$< $(INPUT_FILE_DNI-NIE)  

DNI-NIE/regex_dni-nie.cpp: DNI-NIE/regex_dni-nie.l
	$(FLEX) $<
	mv lex.yy.cc DNI-NIE/regex_dni-nie.cpp

# ----------------------------------------------
INPUT_FILE_TFNO = Telefonos/telefonos.txt  # Archivo de entrada

# Regla para ejecutar flex++ y generar el código C++ (lex.yy.cc)
telefonos: Telefonos/regex_tfno_exe
	./$< $(INPUT_FILE_TFNO)  

Telefonos/regex_tfno.cpp: Telefonos/regex_tfno.l
	$(FLEX) $<
	mv lex.yy.cc Telefonos/regex_tfno.cpp



# Regla para compilar el código C++ generado por flex++
%_exe: %.cpp
	$(COMPILER) $(FLAGS) $< -o $@ -lfl 

# Limpiar los archivos generados
clean:
	rm -rf */*_exe */*.cpp

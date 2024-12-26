# Variables
FLEX = flex++  # Usa flex++ para generar código C++
COMPILER = g++  # Compilador C++
FLAGS = -std=c++11 -g -Wall  # Flags para el compilador

# ----------------------------------------------
INPUT_FILE_BANCO = Bancos/cuentas.txt  # Archivo de entrada
INPUT_FILE_BANCO-MENU = Bancos/cuentas-menu.txt  # Archivo de entrada

INFO_FILE_BANCO = Bancos/Cods_Bancos.csv  # Archivo de información

# Regla para ejecutar flex++ y generar el código C++ (lex.yy.cc)
bancos: Bancos/regex_bancos_exe	$(INFO_FILE_BANCO)
	./$< $(INFO_FILE_BANCO) $(INPUT_FILE_BANCO)  

bancos-menu: Bancos/regex_bancos_exe	$(INFO_FILE_BANCO)
	./$< $(INFO_FILE_BANCO) $(INPUT_FILE_BANCO-MENU)  

Bancos/regex_bancos.cpp: Bancos/regex_bancos.l
	$(FLEX) $<
	mv lex.yy.cc Bancos/regex_bancos.cpp

Bancos/regex_bancos-menu.cpp: Bancos/regex_bancos.l
	$(FLEX) $<
	mv lex.yy.cc Bancos/regex_bancos-menu.cpp

# ----------------------------------------------
INPUT_FILE_DNI-NIE = DNI-NIE/dni-nie.txt  # Archivo de entrada
INPUT_FILE_DNI-NIE-MENU = DNI-NIE/dni-nie-menu.txt 

# Regla para ejecutar flex++ y generar el código C++ (lex.yy.cc)
dni-nie: DNI-NIE/regex_dni-nie_exe
	./$< $(INPUT_FILE_DNI-NIE)  

dni-nie-menu: DNI-NIE/regex_dni-nie-menu_exe
	./$< $(INPUT_FILE_DNI-NIE-MENU) 

DNI-NIE/regex_dni-nie.cpp: DNI-NIE/regex_dni-nie.l
	$(FLEX) $<
	mv lex.yy.cc DNI-NIE/regex_dni-nie.cpp

DNI-NIE/regex_dni-nie-menu.cpp: DNI-NIE/regex_dni-nie.l
	$(FLEX) $<
	mv lex.yy.cc DNI-NIE/regex_dni-nie-menu.cpp

# ----------------------------------------------
INPUT_FILE_TFNO = Telefonos/telefonos.txt  # Archivo de entrada
INPUT_FILE_TFNO-MENU = Telefonos/telefonos-menu.txt  # Archivo de entrada


# Regla para ejecutar flex++ y generar el código C++ (lex.yy.cc)
telefonos: Telefonos/regex_tfno_exe
	./$< $(INPUT_FILE_TFNO) 

telefonos-menu: Telefonos/regex_tfno-menu_exe
	./$< $(INPUT_FILE_TFNO-MENU)   

Telefonos/regex_tfno.cpp: Telefonos/regex_tfno.l
	$(FLEX) $<
	mv lex.yy.cc Telefonos/regex_tfno.cpp

Telefonos/regex_tfno-menu.cpp: Telefonos/regex_tfno.l
	$(FLEX) $<
	mv lex.yy.cc Telefonos/regex_tfno-menu.cpp


# ----------------------------------------------
INPUT_FILE_EMAIL = EMAIL/email.txt  # Archivo de entrada
INPUT_FILE_EMAIL-MENU = EMAIL/email-menu.txt  # Archivo de entrada


# Regla para ejecutar flex++ y generar el código C++ (lex.yy.cc)
email: EMAIL/regex_email_exe
	./$< $(INPUT_FILE_EMAIL) 

email-menu: EMAIL/regex_email-menu_exe
	./$< $(INPUT_FILE_EMAIL-MENU)   

EMAIL/regex_email.cpp: EMAIL/regex_email.l
	$(FLEX) $<
	mv lex.yy.cc EMAIL/regex_email.cpp

EMAIL/regex_email-menu.cpp: EMAIL/regex_email.l
	$(FLEX) $<
	mv lex.yy.cc EMAIL/regex_email-menu.cpp

# ----------------------------------------------

menu: menu_exe
	./$<

menu.cpp: menu.l
	$(FLEX) $<
	mv lex.yy.cc menu.cpp

# ----------------------------------------------

# Regla para compilar el código C++ generado por flex++
%_exe: %.cpp
	$(COMPILER) $(FLAGS) $< -o $@ -lfl 

# Limpiar los archivos generados
clean:
	rm -rf */*_exe */*.cpp
	rm -rf *_exe *.cpp

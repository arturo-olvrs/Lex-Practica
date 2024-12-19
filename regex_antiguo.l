/**
 * @file regex.l
 * @brief Menu que:
 * 
 * @note
 *      Compilación:
 *          1. flex++ -o regex.cpp regex.l
 *          2. g++ -Wall -o regex regex.cpp
 *      Ejecución:
 *          1. ./regex
 * 
 * @author Arturo Olivares Martos
 * @author Joaquín Avilés de la Fuente
 * @date 18 de diciembre de 2024
 */

    /*---------------DECLARACIONES---------------*/
%{
#include <iostream>
#include <sstream>
#include <string>

using namespace std;

int nl;
%}

%option noyywrap

linea   \n

%%
    /*---------------REGLAS---------------*/
\n  { nl++;}

%%
    /*---------------PROCEDIMIENTOS---------------*/

void imprime_menu(){
    cout << "Menú:" << endl;
    cout << "\t1. Dado un teléfono, comprobar en qué países es válido." << endl;
    cout << "\t2. Dado un correo electrónico, comprobar si es válido." << endl;
    cout << "\t3. Dado un DNI, comprobar si es válido." << endl;
    cout << "\t4. Dado un número de tarjeta de crédito, indicar de qué entidad bancaria es." << endl;
    cout << "Introduce el número de la opción elegida:" << endl;
}


int main (int argc, char *argv[]){

    nl = 0;
    string input;
    string line;
    stringstream ss;

    string opcion_elegida;


    cout << "En el siguiente programa, encontrarás un menú que te permitirá trabajar con distintas expresiones regulares." << endl;
    imprime_menu();
    getline(cin, opcion_elegida);

    if (opcion_elegida == "1"){
        cout << "Has elegido la opción 1" << endl;
    } else if (opcion_elegida == "2"){
        cout << "Has elegido la opción 2" << endl;
    } else if (opcion_elegida == "3"){
        cout << "Has elegido la opción 3" << endl;
    } else if (opcion_elegida == "4"){
        cout << "Has elegido la opción 4" << endl;
    } else {
        cout << "Opción no válida" << endl;
    }


    cout << "Introduce texto (termina con -1 en una línea nueva):" << endl;

    // Leer entrada hasta que se introduzca -1
    while (getline(cin, line)) {
        if (line == "-1") {
            break;
        }
        ss << line << '\n';
    }

    // Pasar el contenido del stringstream al analizador léxico
    string input_data = ss.str();
    istringstream input_stream(input_data);
    yyFlexLexer flujo(&input_stream, 0);
    flujo.yylex();

    cout << "Número de líneas: " << nl << endl;
    return 0;
}
/**
 * @file regex.l
 * @brief Menu que:
 * 
 * @note
 *      Compilación:
 *          1. flex++ -o regex_bancos.cpp regex_bancos.l
 *          2. g++ -Wall -o regex_bancos regex_bancos.cpp
 *      Ejecución:
 *          1. ./regex_bancos
 * 
 * @author Arturo Olivares Martos
 * @author Joaquín Avilés de la Fuente
 * @date 18 de diciembre de 2024
 */

    /*---------------DECLARACIONES---------------*/
%{
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <set>
#include <map>
#include <vector>
#include <algorithm>

using namespace std;

ifstream fichero;

// Conjunto en el que almacenaremos las cuentas bancarias
set<string> cuentas_espanolas;
map<string, set<string>> cuentas_banco;

// Relacion: Código -> Nombre Banco
map<string, string> codigos_bancos;


%}

%option noyywrap

cuentaEspanola   ES[0-9]{2}( [0-9]{4}){5}

%%
    /* ---------------REGLAS--------------- */

ES[0-9]{2}(" "[0-9]{4}){5}    {cuentas_espanolas.insert(yytext);}

%%
    /*---------------PROCEDIMIENTOS---------------*/

/**
 * @brief Función que divide una cadena en función de un delimitador.
 * 
 * Si el delimitador se encuentra entre comillas, se considera que el campo está entre comillas (no se divide).
 * 
 * @param str Cadena a dividir
 * @param delimiter Delimitador
 * 
 * @return vector<string> Vector con las cadenas resultantes
 */
vector<string> split(const string& str, char delimiter) {
    vector<string> tokens;
    string token;
    istringstream tokenStream(str);
    bool entre_comillas = false;
    string campo;
    while (getline(tokenStream, token, delimiter)){
        if (token[0] == '"' && token[token.size()-1] != '"'){   // Inicio de campo entre comillas, pero no fin
            campo = token;
            entre_comillas = true;
        }
        else if (token[token.size()-1] == '"' && entre_comillas){   // Fin de campo entre comillas, pero no inicio
            campo += delimiter + token;
            entre_comillas = false;
            campo = campo.substr(1, campo.size()-2);
            tokens.push_back(campo);
        }
        else if (entre_comillas)    // Campo entre comillas, pero no inicio ni fin
            campo += delimiter + token;
        else{   // Campo normal
            if (token[0] == '"')    // Campo entre comillas
                token = token.substr(1, token.size()-2);
            
            tokens.push_back(token);
        }
    }
    return tokens;
}

int calcularRestoPor97(const std::string& numero) {
    long long resto = 0;
    
    // Iteramos sobre cada carácter de la cadena
    for (char c : numero) {
        // Convertimos el carácter a su valor numérico
        int digito = c - '0';
        
        // Actualizamos el resto utilizando la aritmética modular
        resto = (resto * 10 + digito) % 97;
    }
    
    return resto;
}

/**
 * @brief Función que comprueba si una cuenta bancaria española es válida.
 * 
 * @param cuenta Cuenta bancaria española
 * 
 * @return true Si la cuenta es válida
 * @return false Si la cuenta no es válida
 * 
 * @pre La cuenta debe ser con un formato español correcto
 */
bool cuenta_espanola_valida(const string &cuenta){
    // Eliminamos los espacios
    string cuenta_sin_espacios = cuenta;
    cuenta_sin_espacios.erase(remove(cuenta_sin_espacios.begin(), cuenta_sin_espacios.end(), ' '), cuenta_sin_espacios.end());

    // Obtenemos el código de seguridad, los dígitos 2 y 3 (empezando desde 0)
    int codigo_seguridad = stoi(cuenta_sin_espacios.substr(2, 2));

    string CCC_str = cuenta_sin_espacios.substr(4);
    string aux = CCC_str + "1428" + + "00";
    
    int resto=calcularRestoPor97(aux);
    int codigo_calculado = 98 - resto;

    return codigo_seguridad == codigo_calculado;
}



int main (int argc, char *argv[]){
    // Comprobamos que se ha introducido un archivo
    if (argc == 2){
        fichero.open (argv[1]);
        if (!fichero){
            cerr << "Error de lecura del archivo a analizar." << endl;
            exit (1);
        }
    }
    else{
        cerr << "Error en la introducción de argumentos." << endl;
        exit (1);
    }


    string archivo_bancos = "Cods_Bancos.csv";
    ifstream f_bancos;
    f_bancos.open(archivo_bancos);
    if (!f_bancos){
        cerr << "Error de lectura del archivo de códigos de bancos." << endl;
        exit(1);
    }


    string linea;
    // Obtenemos en qué posición se encuentran los campos "CÓDIGO EUROPEO" y "NOMBRE"
    int pos_codigo=0, pos_nombre=0;
    getline(f_bancos, linea);
    vector<string> campos= split(linea, ',');

    // El static_cast<int> es necesario para evitar un warning
    // pues se trabaja con tipo size_type comparado con int

    for (int i = 0; i < static_cast<int>(campos.size()); i++){
        if (campos[i] == "CÓDIGO EUROPEO")
            pos_codigo = i;
        else if (campos[i] == "NOMBRE")
            pos_nombre = i;
    }
    // Guardamos los códigos y nombres de los bancos
    while (getline(f_bancos, linea)){
        campos = split(linea, ',');
        codigos_bancos[campos[pos_codigo]] = campos[pos_nombre];
    }
    f_bancos.close();

    yyFlexLexer flujo (&fichero,0);
    flujo.yylex();

    cout << "Cuentas leidas: " << endl;
    set<string> cuentas_espanolas_no_validas;

    // Cada cuenta española, vemos si es válida

    // Lo haremos con un bucle while, ya que tenemos que tener en cuenta que al eliminar un elemento
    // la función .erase(iterator) devuelve el iterador apuntando al siguiente elemento, por lo que
    // no debemos sumar nada a it. Solo se suma si no se elimina elemento.

    auto it = cuentas_espanolas.begin();
    while (it != cuentas_espanolas.end()){
        cout << *it << " " << endl;

        if (!cuenta_espanola_valida(*it)){
            // No es válida. La eliminamos de cuentas españolas, y la añadimos al conjunto de cuentas no válidas
            cuentas_espanolas_no_validas.insert(*it);
            it=cuentas_espanolas.erase(it);
        }
        else
            it++;
    }

    // Cada cuenta española, la asignamos a un banco
    for (auto it = cuentas_espanolas.begin(); it != cuentas_espanolas.end(); it++){

        string nombre_banco = "Banco Desconocido";
        string codigo_banco = "ES"+it->substr(5, 4);

        if (codigos_bancos.find(codigo_banco) != codigos_bancos.end())
            nombre_banco = codigos_bancos[codigo_banco];
       
        cuentas_banco[nombre_banco].insert(*it);
    }

    cout << endl;
    // Mostramos los resultados
    cout << "Cuentas españolas no válidas: " << endl;
    for (auto it = cuentas_espanolas_no_validas.begin(); it != cuentas_espanolas_no_validas.end(); it++)
        cout << *it << endl;
    cout << endl;
    cout << "Cuentas por banco: " << endl;
    for (auto it = cuentas_banco.begin(); it != cuentas_banco.end(); it++){
        cout << it->first << ": " << endl;
        for (auto it2 = it->second.begin(); it2 != it->second.end(); it2++)
            cout << *it2 << endl;
        cout << endl;
    }

    fichero.close();
    return 0;
}
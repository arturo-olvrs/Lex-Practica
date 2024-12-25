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

DNI   [0-9]{8}[" "]?[A-Z]
NIE   [XYZ][0-9]{7}[" "]?[A-Z]

%%
    /* ---------------REGLAS--------------- */

ES[0-9]{2}(" "[0-9]{4}){5}    {cuentas_espanolas.insert(yytext);}

%%
    /*---------------PROCEDIMIENTOS---------------*/

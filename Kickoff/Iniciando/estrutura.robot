*** Settings ***
Library  SeleniumLibrary

*** Variables ***


*** Keywords ***
abrir site da google
    Open Browser  https://www.google.com  chrome
    Maximize Browser Window

abrir site da php travels
    Open Browser  https://www.phptravels.net/  chrome
    Maximize Browser Window

fechar navegador
    Close Browser



*** Test Cases ***
Cenário 1: testes de abrir navegador
    abrir site da google
    fechar navegador

Cenário 2: testes de abrir site php travels
    abrir site da php travels
    fechar navegador
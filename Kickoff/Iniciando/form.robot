*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${input_firstName}   xpath://input[@id='firstName']
${input_lastName}    xpath://input[@id='lastName']
${input_userEmail}   xpath://input[@id='userEmail']
${radio_btnGender}   xpath://label[@for='gender-radio-1']
${input_userNumber}  xpath://input[@id='userNumber']
${click_btnSubmit}   xpath://button[@id='submit']


*** Keywords ***

abrir navegador e acessar site
    Open Browser  https://demoqa.com/automation-practice-form  chrome
    Maximize Browser Window

preencher campos do formulário
    Input Text     ${input_firstName}   Volt
    Input Text     ${input_lastName}    Campos
    Input Text     ${input_userEmail}   volt.campos@example.com
    Click Element  ${radio_btnGender}
    Input Text     ${input_userNumber}  1234567890

clicar em submit
    Execute JavaScript    ${click_btnSubmit}

fechar navegador
    Close Browser

*** Test Cases ***
Cenário 1: preencher formulário
    abrir navegador e acessar site
    preencher campos do formulário
    clicar em submit
    fechar navegador
*** Settings ***

Resource    ../../Resource/Settings.resource
Resource    ../../Elements/Main_Elements.resource

*** Keywords ***

Dado que eu acesse o php travels
    Open Browser  ${URL}  ${Browser}
    Maximize Browser Window

E realize o cadastro
    Wait Until Element Is Visible      ${Home.A_Signup}            10
    Click Element                      ${Home.A_Signup}
    Wait Until Element Is Visible      ${Home.A_Register}           10 
    Click Element                      ${Home.A_Register}  
    Wait Until Element Is Visible      ${Login.Input_PrimeiroNome}  10
    Input Text                         ${Login.Input_PrimeiroNome}  ${PrimeiroNome}
    Wait Until Element Is Visible      ${Login.Input_UltimoNome}    10
    Input Text                         ${Login.Input_UltimoNome}    ${UltimoNome}  
    Wait Until Element Is Visible      ${Login.Input_Pais}          10  
    Click Element                      ${Login.Input_Pais}    
    Wait Until Element Is Visible      ${Login.Input_Option_Pais}   10 
    Input Text                         ${Login.Input_Option_Pais}   Brazil   
    Wait Until Element Is Visible      ${Login.Option_Brasil}       10 
    Click Element                      ${Login.Option_Brasil}   
    Wait Until Element Is Visible      ${Login.Input_Telefone}      10
    Input Text                         ${Login.Input_Telefone}      ${Telefone}  
    Wait Until Element Is Visible      ${Login.Input_Email}         10
    Input Text                         ${Login.Input_Email}         ${Email}  
    Wait Until Element Is Visible      ${Login.Input_Senha}         10 
    Input Text                         ${Login.Input_Senha}         ${Senha}
    Wait Until Element Is Visible      ${Login.Iframe_reCAPTCHA}    30
    Select Frame                       ${Login.Iframe_reCAPTCHA} 
    Wait Until Element Is Visible      ${Login.Not_Robot}            30
    Click Element                      ${Login.Not_Robot}  
    Unselect Frame
    #Wait Until Element Is Visible      ${Login.Button_Cookie}       10
    #Click Element                      ${Login.Button_Cookie}          
    Wait Until Element Is Visible      ${Login.Button_Signup}       10 
    Sleep                              2s
    Run Keyword And Ignore Error       Click Element                      ${Login.Button_Signup}    
    Click Element                      ${Login.Button_Signup}

E faça o Login
    Wait Until Element Is Visible  ${Login.A_OpcaoLogin}      10
    Click Element                  ${Login.A_OpcaoLogin} 
    Wait Until Element Is Visible  ${Login.Input_EmailLogin}  10
    Input Text                     ${Login.Input_EmailLogin}  ${Email}
    Wait Until Element Is Visible  ${Login.Input_SenhaLogin}  10
    Input Text                     ${Login.Input_SenhaLogin}  ${Senha}
    Run Keyword And Ignore Error   Wait Until Element Is Visible  ${Button_Cookie}     5
    Run Keyword And Ignore Error   Click Element                  ${Button_Cookie}
    Wait Until Element Is Visible  ${Login.Button_Logar}      10
    Click Element                  ${Login.Button_Logar}

E fecho o navegador
    Close Browser
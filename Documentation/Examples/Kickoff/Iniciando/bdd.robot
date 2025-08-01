*** Settings ***
Library  SeleniumLibrary


*** Variables ***
#Dados do meu teste
${nome_musica}  Never Gonna Give You Up

#Variaveis de configuração
${url}      https://www.youtube.com
${browser}  chrome

#Elementos do site
${input_pesquisa}  xpath://input[@name='search_query']
${botao_buscar}    xpath:(//button[@aria-label='Search'])[1]
${primeira_opcao}  xpath:(//yt-formatted-string[@class='style-scope ytd-video-renderer'])[1]
${prova_video}   xpath:(//video[@class='video-stream html5-main-video'])[1]

*** Keywords ***
Dado que eu acesso o site do youtube
    Open Browser  ${url}  ${browser}
    Maximize Browser Window

Quando digito o nome da musica
    Input Text  ${input_pesquisa}  ${nome_musica}

E clico no botão buscar
    Click Button  ${botao_buscar}

E clico na primeira opção da lista
    Wait Until Element Is Visible  ${primeira_opcao}  10
    Click Element  ${primeira_opcao}

Então o video é executado
    Wait Until Element Is Visible  ${prova_video}  10
    Element Should Be Visible  ${prova_video}
    Sleep  5s  # Espera o video carregar por 5 segundos
    Close Browser


*** Test Cases ***
Cenário 1: Executar video no site do YouTube
    Dado que eu acesso o site do youtube
    Quando digito o nome da musica
    E clico no botão buscar
    E clico na primeira opção da lista
    Então o video é executado


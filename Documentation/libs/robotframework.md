# Robot Framework

## Visão Geral

Robot Framework é um framework de automação genérico para testes de aceitação e RPA (Robotic Process Automation). É uma tecnologia de código aberto que pode ser usada para testes de aceitação orientados por dados e desenvolvimento de automação robótica de processos.

## Características Principais

- **Linguagem de fácil utilização**: Sintaxe tabular que é fácil de ler e escrever
- **Independente de plataforma**: Funciona em Windows, Linux, macOS e outros sistemas
- **Extensível**: Suporta bibliotecas externas em Python, Java e outras linguagens
- **Orientado por dados**: Permite a criação de testes parametrizados
- **Relatórios detalhados**: Gera logs e relatórios HTML automaticamente
- **Suporte a BDD**: Permite o uso de sintaxe Gherkin (Given/When/Then)

## Estrutura Básica

### Seções do Arquivo

Um arquivo Robot Framework é organizado em seções:

```
*** Settings ***
# Configurações do teste

*** Variables ***
# Variáveis utilizadas nos testes

*** Test Cases ***
# Casos de teste

*** Keywords ***
# Palavras-chave customizadas

*** Comments ***
# Comentários
```

### Configurações (Settings)

As configurações mais comuns incluem:

```robotframework
*** Settings ***
Documentation    Descrição do suite de testes
Suite Setup      Configuração inicial do suite
Suite Teardown   Finalização do suite
Test Setup       Configuração inicial de cada teste
Test Teardown    Finalização de cada teste
Library          SeleniumLibrary
Resource         recursos/resource.resource
Variables        variaveis/vars.py
```

### Variáveis

Robot Framework suporta diferentes tipos de variáveis:

```robotframework
*** Variables ***
${SCALAR}        Valor escalar
@{LIST}          Item 1    Item 2    Item 3
&{DICT}          key1=value1    key2=value2
```

### Casos de Teste

Estrutura básica de um caso de teste:

```robotframework
*** Test Cases ***
Login com sucesso
    [Documentation]    Testa o login com credenciais válidas
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Name      ${USERNAME}
    Input Password  ${PASSWORD}
    Click Button    login_button
    Page Should Contain    Bem-vindo
    [Teardown]      Close Browser
```

### Palavras-chave (Keywords)

Keywords personalizadas para reutilização de código:

```robotframework
*** Keywords ***
Open Login Page
    [Documentation]    Abre a página de login
    [Arguments]    ${url}    ${browser}
    Open Browser    ${url}    ${browser}
    Title Should Be    Login Page

Input Name
    [Arguments]    ${name}
    Input Text    username_field    ${name}

Input Password
    [Arguments]    ${password}
    Input Text    password_field    ${password}
```

## Estruturas de Controle

### FOR Loops

```robotframework
*** Test Cases ***
Exemplo de FOR Loop
    FOR    ${animal}    IN    cat    dog    cow
        Log    ${animal}
    END

Exemplo com Enumerate
    FOR    ${index}    ${item}    IN ENUMERATE    @{LIST}
        Log    Índice: ${index} - Item: ${item}
    END
```

### IF/ELSE

```robotframework
*** Test Cases ***
Exemplo de IF/ELSE
    IF    ${rc} > 0
        Log    Resultado positivo
    ELSE
        Log    Resultado negativo
    END
```

### TRY/EXCEPT

```robotframework
*** Test Cases ***
Exemplo de TRY/EXCEPT
    TRY
        Some Keyword
    EXCEPT    Error message
        Error Handler Keyword
    END
```

## Bibliotecas

### Bibliotecas Padrão

Robot Framework vem com várias bibliotecas padrão:

- **BuiltIn**: Funções básicas do framework
- **Collections**: Operações com listas e dicionários
- **DateTime**: Manipulação de datas e horas
- **OperatingSystem**: Interação com o sistema operacional
- **String**: Manipulação de strings
- **XML**: Manipulação de XML

### Bibliotecas Externas

Bibliotecas populares para automação:

- **SeleniumLibrary**: Automação web
- **RequestsLibrary**: Testes de API REST
- **AppiumLibrary**: Automação mobile
- **DatabaseLibrary**: Interação com bancos de dados

## Execução de Testes

### Linha de Comando

```bash
# Executar todos os testes em um diretório
robot tests/

# Executar com opções específicas
robot --include smoke --exclude regression tests/

# Executar com variáveis
robot --variable BROWSER:chrome --variable URL:https://example.com tests/

# Executar usando Python
python -m robot tests/
```

### Opções Comuns

- `--include`: Executar apenas testes com tags específicas
- `--exclude`: Excluir testes com tags específicas
- `--variable`: Definir variáveis na linha de comando
- `--outputdir`: Diretório para salvar relatórios e logs
- `--loglevel`: Nível de detalhamento do log (TRACE, DEBUG, INFO, WARN)

## Boas Práticas

### Organização de Arquivos

```
project/
├── tests/
│   ├── api/
│   ├── web/
│   └── mobile/
├── resources/
│   ├── pages/
│   ├── apis/
│   └── common/
├── libraries/
├── data/
└── results/
```

### Nomenclatura

- Use nomes descritivos para testes e keywords
- Siga convenção BDD quando aplicável
- Mantenha consistência na nomenclatura

### Reutilização

- Crie keywords reutilizáveis
- Use arquivos de recurso para compartilhar keywords
- Implemente Page Object Model para testes web

## Integração com CI/CD

Robot Framework pode ser facilmente integrado com pipelines de CI/CD:

```yaml
# Exemplo de integração com GitHub Actions
- name: Run Robot Framework Tests
  run: |
    pip install robotframework
    robot --outputdir results tests/
  
- name: Upload test results
  uses: actions/upload-artifact@v2
  with:
    name: test-results
    path: results/
```

## Recursos Adicionais

- **Documentação oficial**: https://robotframework.org/
- **GitHub**: https://github.com/robotframework/robotframework
- **Fórum da comunidade**: https://forum.robotframework.org/
- **Bibliotecas**: https://robotframework.org/#libraries

## Versão

A versão atual do Robot Framework é 7.0 ou superior, com suporte a Python 3.6+.
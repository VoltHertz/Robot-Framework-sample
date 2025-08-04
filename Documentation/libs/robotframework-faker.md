# RobotFramework-Faker Library Documentation

## Overview

RobotFramework-Faker é uma biblioteca wrapper do Robot Framework para a biblioteca Python Faker, que permite a geração de dados de teste falsos e realistas. Esta biblioteca é essencial para implementar o Factory Pattern no projeto, fornecendo uma ampla variedade de dados de teste dinâmicos e diversificados.

## Instalação

```bash
pip install robotframework-faker
```

**Versão Atual:** 5.0.0

## Importação

```robot
*** Settings ***
Library    FakerLibrary
# Para localização brasileira
Library    FakerLibrary    locale=pt_BR
```

## Principais Providers Disponíveis

### Dados Pessoais
- `first_name` - Primeiro nome
- `last_name` - Sobrenome  
- `name` - Nome completo
- `email` - Email
- `safe_email` - Email seguro (usando example.com)
- `phone_number` - Número de telefone
- `ssn` - Número de segurança social

### Dados Geográficos
- `address` - Endereço completo
- `street_address` - Endereço da rua
- `city` - Cidade
- `state` - Estado
- `country` - País
- `postcode` - CEP (formato local)

### Dados de Internet
- `url` - URL
- `domain_name` - Nome de domínio
- `ipv4` - Endereço IPv4
- `ipv6` - Endereço IPv6
- `mac_address` - Endereço MAC
- `user_agent` - User Agent de navegador

### Dados Brasileiros (locale=pt_BR)
- `cpf` - CPF brasileiro
- `name` - Nomes brasileiros
- `postcode` - CEP no formato brasileiro (ex: 41224-212)
- `state_abbr` - Siglas dos estados brasileiros

## Exemplos Práticos

### Exemplo Básico
```robot
*** Settings ***
Library    FakerLibrary

*** Test Cases ***
Gerar Dados Básicos
    ${nome}=    FakerLibrary.first_name
    ${email}=   FakerLibrary.email
    ${telefone}=    FakerLibrary.phone_number
    Log    Nome: ${nome}, Email: ${email}, Telefone: ${telefone}
```

### Exemplo com Localização Brasileira
```robot
*** Settings ***
Library    FakerLibrary    locale=pt_BR

*** Test Cases ***
Gerar Dados Brasileiros
    ${cpf}=         FakerLibrary.cpf
    ${nome}=        FakerLibrary.name
    ${cep}=         FakerLibrary.postcode
    ${estado}=      FakerLibrary.state_abbr
    Log    CPF: ${cpf}, Nome: ${nome}, CEP: ${cep}, Estado: ${estado}
```

### Exemplo Completo de Perfil de Usuário
```robot
*** Test Cases ***
Criar Perfil Completo
    ${endereco}=        FakerLibrary.address
    ${pais}=           FakerLibrary.country
    ${email}=          FakerLibrary.email
    ${primeiro_nome}=   FakerLibrary.first_name
    ${sobrenome}=      FakerLibrary.last_name
    ${telefone}=       FakerLibrary.phone_number
    ${url}=            FakerLibrary.url
    
    # Criando um dicionário com os dados
    &{perfil}=    Create Dictionary
    ...    nome=${primeiro_nome}
    ...    sobrenome=${sobrenome}
    ...    email=${email}
    ...    telefone=${telefone}
    ...    endereco=${endereco}
    ...    pais=${pais}
    ...    website=${url}
```

### Geração com Seed para Reprodutibilidade
```robot
*** Test Cases ***
Dados Reproduziveis
    # Definindo seed para resultados consistentes
    FakerLibrary.Seed    ${5}
    ${email1}=    FakerLibrary.email
    
    # Mesmo seed, mesmo resultado
    FakerLibrary.Seed    ${5}
    ${email2}=    FakerLibrary.email
    
    Should Be Equal As Strings    ${email1}    ${email2}
```

## Integração com Factory Pattern

### Resource File: data_factory.resource
```robot
*** Settings ***
Library    FakerLibrary    locale=pt_BR

*** Keywords ***
Gerar Usuario Brasileiro
    [Documentation]    Gera dados de usuário brasileiro usando Factory Pattern
    [Arguments]    ${tipo_usuario}=padrao
    
    # Dados básicos
    ${dados_usuario}=    Create Dictionary
    ...    nome=${EMPTY}
    ...    email=${EMPTY}
    ...    cpf=${EMPTY}
    ...    telefone=${EMPTY}
    ...    endereco=${EMPTY}
    
    # Geração baseada no tipo
    IF    '${tipo_usuario}' == 'admin'
        ${nome}=        Set Variable    Admin ${FakerLibrary.first_name}
        ${email}=       Set Variable    admin.${FakerLibrary.user_name}@empresa.com
    ELSE IF    '${tipo_usuario}' == 'cliente'
        ${nome}=        FakerLibrary.name
        ${email}=       FakerLibrary.email
    ELSE
        ${nome}=        FakerLibrary.name
        ${email}=       FakerLibrary.safe_email
    END
    
    # Dados brasileiros
    ${cpf}=           FakerLibrary.cpf
    ${telefone}=      FakerLibrary.phone_number
    ${endereco}=      FakerLibrary.address
    
    # Atualizar dicionário
    Set To Dictionary    ${dados_usuario}
    ...    nome=${nome}
    ...    email=${email}
    ...    cpf=${cpf}
    ...    telefone=${telefone}
    ...    endereco=${endereco}
    
    [Return]    ${dados_usuario}

Gerar Lista Usuarios
    [Documentation]    Gera lista de usuários para testes em massa
    [Arguments]    ${quantidade}=5    ${tipos}=@{EMPTY}
    
    @{usuarios}=    Create List
    
    FOR    ${i}    IN RANGE    ${quantidade}
        ${tipo}=    Run Keyword If    ${tipos}    Get From List    ${tipos}    ${i % len(${tipos})}
        ...    ELSE    Set Variable    padrao
        ${usuario}=    Gerar Usuario Brasileiro    ${tipo}
        Append To List    ${usuarios}    ${usuario}
    END
    
    [Return]    ${usuarios}
```

### Uso em Testes
```robot
*** Settings ***
Resource    ../resources/data/data_factory.resource

*** Test Cases ***
Teste Com Usuario Faker
    ${usuario}=    Gerar Usuario Brasileiro    cliente
    Log    Testando com usuário: ${usuario['nome']} - ${usuario['email']}
    
    # Usar os dados no teste
    Input Text    id=nome        ${usuario['nome']}
    Input Text    id=email       ${usuario['email']}
    Input Text    id=cpf         ${usuario['cpf']}

Teste Com Multiplos Usuarios
    @{tipos_usuario}=    Create List    cliente    admin    cliente
    @{usuarios}=    Gerar Lista Usuarios    3    ${tipos_usuario}
    
    FOR    ${usuario}    IN    @{usuarios}
        Log    Processando: ${usuario['nome']} (${usuario['email']})
        # Lógica do teste aqui
    END
```

## Dados Brasileiros Específicos

### Tratamento de CPF
```robot
*** Keywords ***
Obter CPF Sem Mascara
    [Documentation]    Remove a máscara do CPF gerado
    ${cpf_com_mascara}=    FakerLibrary.cpf
    ${cpf_limpo}=    Remove String    ${cpf_com_mascara}    .    -
    [Return]    ${cpf_limpo}

Validar Formato CPF
    [Arguments]    ${cpf}
    # CPF com máscara: 109.694.257-94
    # CPF sem máscara: 10969425794
    ${tem_pontos}=    Get Regexp Matches    ${cpf}    \\d{3}\\.\\d{3}\\.\\d{3}-\\d{2}
    ${sem_pontos}=    Get Regexp Matches    ${cpf}    \\d{11}
    
    Should Be True    ${tem_pontos} or ${sem_pontos}    CPF deve ter formato válido
```

### Endereços Brasileiros
```robot
*** Test Cases ***
Gerar Endereco Brasileiro Completo
    Library    FakerLibrary    locale=pt_BR
    
    ${endereco}=      FakerLibrary.address
    ${cep}=          FakerLibrary.postcode
    ${cidade}=       FakerLibrary.city  
    ${estado}=       FakerLibrary.state
    ${estado_sigla}= FakerLibrary.state_abbr
    
    Log    Endereço: ${endereco}
    Log    CEP: ${cep}
    Log    Cidade: ${cidade}
    Log    Estado: ${estado} (${estado_sigla})
```

## Melhores Práticas

### 1. Usar Seeds para Testes Determinísticos
```robot
*** Keywords ***
Setup Dados Deterministas
    [Documentation]    Configura seed para dados reproduzíveis em testes
    FakerLibrary.Seed    ${SUITE_SEED}
```

### 2. Criar Factories Específicas por Domínio
```robot
*** Keywords ***
Gerar Produto E-commerce
    [Documentation]    Factory específica para produtos de e-commerce
    &{produto}=    Create Dictionary
    ...    nome=Produto ${FakerLibrary.word}
    ...    descricao=${FakerLibrary.text}
    ...    preco=${FakerLibrary.random_int    min=10    max=1000}
    ...    categoria=${FakerLibrary.word}
    ...    sku=${FakerLibrary.random_number    digits=8}
    
    [Return]    ${produto}
```

### 3. Validação de Dados Gerados
```robot
*** Keywords ***
Validar Email Faker
    [Arguments]    ${email}
    Should Match Regexp    ${email}    ^[\\w\\.-]+@[\\w\\.-]+\\.[a-zA-Z]+$
    Should Not Be Empty    ${email}
```

### 4. Geração de Dados em Lote
```robot
*** Keywords ***
Gerar Dados Em Lote
    [Documentation]    Gera múltiplos registros de uma vez
    [Arguments]    ${quantidade}=10    ${tipo}=usuario
    
    @{dados}=    Create List
    FOR    ${i}    IN RANGE    ${quantidade}
        ${item}=    Run Keyword    Gerar ${tipo.title()}
        Append To List    ${dados}    ${item}
    END
    
    [Return]    ${dados}
```

## Problemas Conhecidos e Soluções

### 1. Erro de União Vazia (Robot Framework 7.0+)
**Problema:** `Union cannot be empty` error
**Solução:** Verificar compatibilidade de versões e usar versão específica se necessário

### 2. Encoding de Caracteres Brasileiros
**Problema:** Caracteres com acento podem causar problemas
**Solução:** 
```robot
*** Settings ***
Library    FakerLibrary    locale=pt_BR
Test Setup    Set Test Variable    ${OUTPUT ENCODING}    UTF-8
```

### 3. CPF com Máscara
**Problema:** CPF gerado com pontos e hífen
**Solução:** Usar keyword personalizada para remover máscara

## Integração com Outras Bibliotecas

### Com DatabaseLibrary
```robot
*** Keywords ***
Inserir Usuario Fake No Banco
    ${usuario}=    Gerar Usuario Brasileiro
    
    Connect To Database    pymysql    database    user    password    host
    Execute Sql String    
    ...    INSERT INTO usuarios (nome, email, cpf) 
    ...    VALUES ('${usuario['nome']}', '${usuario['email']}', '${usuario['cpf']}')
    
    Disconnect From Database
```

### Com RequestsLibrary para APIs
```robot
*** Keywords ***
Criar Usuario Via API
    ${usuario}=    Gerar Usuario Brasileiro
    
    ${response}=    POST    ${API_URL}/users
    ...    json=${usuario}
    ...    headers=${HEADERS}
    
    Should Be Equal As Strings    ${response.status_code}    201
    [Return]    ${response.json()}
```

## Recursos Avançados

### 1. Providers Customizados
Para casos específicos, pode ser necessário estender o Faker com providers customizados em Python.

### 2. Localização Múltipla
```robot
*** Settings ***
Library    FakerLibrary    locale=pt_BR,en_US
```

### 3. Dados Únicos
```robot
*** Keywords ***
Gerar Email Unico
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${email_base}=   FakerLibrary.email
    ${email_unico}=  Replace String    ${email_base}    @    +${timestamp}@
    [Return]    ${email_unico}
```

## Versionamento e Compatibilidade

- **Robot Framework:** 7.0+
- **Python:** 3.8+
- **Faker:** 37.0+
- **Encoding:** UTF-8 recomendado para caracteres brasileiros

## Documentação Adicional

- Documentação oficial: https://faker.readthedocs.io/
- Repositório GitHub: https://github.com/MarketSquare/robotframework-faker
- Exemplos: https://github.com/laurentbristiel/robotframework-faker-example

Esta biblioteca é fundamental para implementar o Factory Pattern no projeto, fornecendo dados de teste diversificados e realistas, especialmente importantes em ambientes de CI/CD com centenas de testes funcionais.
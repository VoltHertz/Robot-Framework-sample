# JSONLibrary - Robot Framework JSON Manipulation Library

## Visão Geral

A JSONLibrary é uma biblioteca do Robot Framework especializada na manipulação de objetos JSON. Utiliza JSONPath para navegar, consultar e modificar estruturas JSON complexas, sendo fundamental para testes de API REST onde JSON é o formato predominante de dados.

## Instalação

### Instalação via pip
```bash
pip install robotframework-jsonlibrary
```

### Instalação com versão específica
```bash
pip install robotframework-jsonlibrary>=0.5.0
```

### Verificação da instalação
```bash
pip list | grep robotframework-jsonlibrary
```

## Importação no Robot Framework

```robotframework
*** Settings ***
Library    JSONLibrary
```

## Principais Características

- **Manipulação JSON**: Adicionar, obter, atualizar e excluir objetos JSON
- **JSONPath**: Utiliza expressões JSONPath para navegação precisa em estruturas complexas
- **Validação de Schema**: Validação de JSON contra schemas definidos
- **Operações de Arquivo**: Carregar JSON de arquivos e salvar modificações
- **Integração com API Testing**: Ideal para validação de respostas de APIs REST

## Keywords Principais

### 1. Load Json From File
Carrega um objeto JSON de um arquivo.

**Sintaxe:**
```robotframework
${json_object}=    Load Json From File    ${file_path}
```

**Exemplo:**
```robotframework
*** Test Cases ***
Carregar JSON de Arquivo
    ${json_data}=    Load Json From File    ${CURDIR}/data/sample.json
    Log    ${json_data}
```

### 2. Get Value From Json
Extrai valores de um objeto JSON usando JSONPath.

**Sintaxe:**
```robotframework
${values}=    Get Value From Json    ${json_object}    ${json_path}
```

**Exemplos:**
```robotframework
*** Test Cases ***
Extrair Valores do JSON
    ${json_response}=    Convert String to JSON    {"users":[{"id":1,"name":"João"},{"id":2,"name":"Maria"}]}
    
    # Obter todos os nomes de usuários
    ${names}=    Get Value From Json    ${json_response}    $..name
    Should Contain    ${names}    João
    Should Contain    ${names}    Maria
    
    # Obter ID específico
    ${first_id}=    Get Value From Json    ${json_response}    $.users[0].id
    Should Be Equal As Numbers    ${first_id[0]}    1
```

### 3. Add Object To Json
Adiciona um objeto a um JSON existente em um caminho específico.

**Sintaxe:**
```robotframework
${updated_json}=    Add Object To Json    ${json_object}    ${json_path}    ${object_to_add}
```

**Exemplo:**
```robotframework
*** Test Cases ***
Adicionar Objeto ao JSON
    ${json_base}=    Convert String to JSON    {"users": []}
    ${new_user}=    Create Dictionary    id=3    name=Pedro    active=True
    
    ${updated_json}=    Add Object To Json    ${json_base}    $.users    ${new_user}
    ${users_count}=    Get Value From Json    ${updated_json}    $.users.length
    Should Be Equal As Numbers    ${users_count[0]}    1
```

### 4. Update Value To Json
Atualiza valores específicos em um objeto JSON.

**Sintaxe:**
```robotframework
${updated_json}=    Update Value To Json    ${json_object}    ${json_path}    ${new_value}
```

**Exemplo:**
```robotframework
*** Test Cases ***
Atualizar Valor JSON
    ${json_data}=    Convert String to JSON    {"user":{"name":"João","status":"inactive"}}
    
    ${updated_json}=    Update Value To Json    ${json_data}    $.user.status    active
    ${status}=    Get Value From Json    ${updated_json}    $.user.status
    Should Be Equal    ${status[0]}    active
```

### 5. Delete Object From Json
Remove objetos ou elementos de array de um JSON.

**Sintaxe:**
```robotframework
${updated_json}=    Delete Object From Json    ${json_object}    ${json_path}
```

**Exemplo:**
```robotframework
*** Test Cases ***
Remover Objeto do JSON
    ${json_data}=    Convert String to JSON    {"user":{"name":"João","temp_field":"remover","status":"active"}}
    
    ${cleaned_json}=    Delete Object From Json    ${json_data}    $.user.temp_field
    Should Not Have Value In Json    ${cleaned_json}    $.user.temp_field
```

### 6. Should Have Value In Json / Should Not Have Value In Json
Validações para verificar presença ou ausência de valores no JSON.

**Sintaxe:**
```robotframework
Should Have Value In Json        ${json_object}    ${json_path}
Should Not Have Value In Json    ${json_object}    ${json_path}
```

**Exemplo:**
```robotframework
*** Test Cases ***
Validar Presença de Valores
    ${api_response}=    Convert String to JSON    {"success":true,"data":{"id":123},"errors":null}
    
    Should Have Value In Json        ${api_response}    $.success
    Should Have Value In Json        ${api_response}    $.data.id
    Should Not Have Value In Json    ${api_response}    $.errors
    Should Not Have Value In Json    ${api_response}    $.data.invalid_field
```

### 7. Validate Json By Schema File
Valida um objeto JSON contra um schema definido em arquivo.

**Sintaxe:**
```robotframework
Validate Json By Schema File    ${json_object}    ${schema_file_path}
```

**Exemplo:**
```robotframework
*** Test Cases ***
Validar JSON com Schema
    ${api_response}=    Get Request Response JSON    # Resposta de uma API
    Validate Json By Schema File    ${api_response}    ${CURDIR}/schemas/user_schema.json
```

### 8. Convert Json To String
Converte objeto JSON para string formatada.

**Sintaxe:**
```robotframework
${json_string}=    Convert Json To String    ${json_object}
```

**Exemplo:**
```robotframework
*** Test Cases ***
Converter JSON para String
    ${json_obj}=    Create Dictionary    name=Test    value=123
    ${json_str}=    Convert Json To String    ${json_obj}
    Log    ${json_str}
    Should Contain    ${json_str}    "name": "Test"
```

### 9. Dump Json To File
Salva objeto JSON em arquivo.

**Sintaxe:**
```robotframework
Dump Json To File    ${file_path}    ${json_object}
```

**Exemplo:**
```robotframework
*** Test Cases ***
Salvar JSON em Arquivo
    ${test_data}=    Create Dictionary    test_id=001    timestamp=${CURDIR}
    Dump Json To File    ${TEMPDIR}/test_result.json    ${test_data}
    File Should Exist    ${TEMPDIR}/test_result.json
```

## JSONPath - Sintaxe e Exemplos

### Operadores Básicos

| Operador | Descrição | Exemplo |
|----------|-----------|---------|
| `$` | Objeto/elemento raiz | `$.user.name` |
| `@` | Objeto/elemento atual | `@.length` |
| `.` ou `[]` | Operador filho | `$.users[0]` |
| `*` | Wildcard para todos os objetos | `$.users[*].name` |
| `..` | Busca recursiva | `$..name` |
| `?()` | Expressão de filtro | `$.users[?(@.active==true)]` |

### Exemplos Práticos de JSONPath

```robotframework
*** Test Cases ***
Exemplos JSONPath Avançados
    ${complex_json}=    Convert String to JSON    
    ...    {
    ...        "store": {
    ...            "book": [
    ...                {"category": "reference", "author": "Nigel Rees", "title": "Sayings of the Century", "price": 8.95},
    ...                {"category": "fiction", "author": "Evelyn Waugh", "title": "Sword of Honour", "price": 12.99},
    ...                {"category": "fiction", "author": "Herman Melville", "title": "Moby Dick", "price": 8.99}
    ...            ],
    ...            "bicycle": {"color": "red", "price": 19.95}
    ...        }
    ...    }
    
    # Todos os autores
    ${authors}=    Get Value From Json    ${complex_json}    $.store.book[*].author
    Length Should Be    ${authors}    3
    
    # Livros com preço menor que 10
    ${cheap_books}=    Get Value From Json    ${complex_json}    $.store.book[?(@.price < 10)]
    Length Should Be    ${cheap_books}    2
    
    # Todos os preços (livros e bicicleta)
    ${all_prices}=    Get Value From Json    ${complex_json}    $..price
    Length Should Be    ${all_prices}    4
    
    # Primeiro livro de ficção
    ${fiction_book}=    Get Value From Json    ${complex_json}    $.store.book[?(@.category=='fiction')][0]
    Should Be Equal    ${fiction_book[0]['author']}    Evelyn Waugh
```

## Casos de Uso em Testes de API

### 1. Validação de Resposta de API

```robotframework
*** Keywords ***
Validar Resposta de API de Usuário
    [Arguments]    ${response_json}
    [Documentation]    Valida estrutura completa de resposta da API de usuários
    
    # Verificar campos obrigatórios
    Should Have Value In Json    ${response_json}    $.id
    Should Have Value In Json    ${response_json}    $.name
    Should Have Value In Json    ${response_json}    $.email
    
    # Validar tipos de dados
    ${user_id}=    Get Value From Json    ${response_json}    $.id
    Should Be True    isinstance(${user_id[0]}, (int, float))
    
    # Validar formato de email
    ${email}=    Get Value From Json    ${response_json}    $.email
    Should Match Regexp    ${email[0]}    ^[\\w\\.-]+@[\\w\\.-]+\\.[a-zA-Z]{2,}$

*** Test Cases ***
Teste API Buscar Usuário
    ${response}=    GET    https://jsonplaceholder.typicode.com/users/1
    ${user_data}=    Set Variable    ${response.json()}
    Validar Resposta de API de Usuário    ${user_data}
```

### 2. Manipulação de Dados para Testes

```robotframework
*** Keywords ***
Preparar Dados de Teste
    [Documentation]    Cria massa de dados customizada para testes
    
    # Carregar template base
    ${base_data}=    Load Json From File    ${CURDIR}/data/user_template.json
    
    # Personalizar dados para o teste
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${updated_data}=    Update Value To Json    ${base_data}    $.email    test_${timestamp}@example.com
    ${updated_data}=    Update Value To Json    ${updated_data}    $.username    user_${timestamp}
    
    # Adicionar dados específicos do teste
    ${test_config}=    Create Dictionary    test_run=automated    environment=staging
    ${final_data}=    Add Object To Json    ${updated_data}    $.metadata    ${test_config}
    
    RETURN    ${final_data}

*** Test Cases ***
Teste Criação de Usuário com Dados Dinâmicos
    ${user_data}=    Preparar Dados de Teste
    ${response}=    POST    https://api.example.com/users    json=${user_data}
    Should Be Equal As Numbers    ${response.status_code}    201
```

### 3. Validação de Schema JSON

```robotframework
*** Test Cases ***
Validação de Schema API
    [Documentation]    Valida se resposta da API está conforme schema definido
    
    ${response}=    GET    https://api.example.com/products/1
    ${product_data}=    Set Variable    ${response.json()}
    
    # Validar com schema arquivo
    Validate Json By Schema File    ${product_data}    ${CURDIR}/schemas/product_schema.json
    
    # Validações específicas adicionais
    Should Have Value In Json    ${product_data}    $.id
    Should Have Value In Json    ${product_data}    $.name
    Should Have Value In Json    ${product_data}    $.price
    
    # Validar estrutura de arrays
    ${categories}=    Get Value From Json    ${product_data}    $.categories
    Should Not Be Empty    ${categories}
```

## Melhores Práticas

### 1. Organização de Keywords

```robotframework
*** Keywords ***
# Keywords específicas para JSON
Validar JSON Response Padrão
    [Arguments]    ${json_response}
    Should Have Value In Json    ${json_response}    $.success
    Should Have Value In Json    ${json_response}    $.data
    Should Not Have Value In Json    ${json_response}    $.errors

Extrair Campo Específico
    [Arguments]    ${json_object}    ${field_path}
    ${value}=    Get Value From Json    ${json_object}    ${field_path}
    Should Not Be Empty    ${value}
    RETURN    ${value[0]}

# Keywords para manipulação de dados
Criar Usuário JSON
    [Arguments]    ${name}    ${email}    ${active}=True
    ${user}=    Create Dictionary    name=${name}    email=${email}    active=${active}
    RETURN    ${user}
```

### 2. Tratamento de Erros

```robotframework
*** Keywords ***
Buscar Valor JSON Seguro
    [Arguments]    ${json_object}    ${json_path}    ${default_value}=${None}
    ${status}    ${value}=    Run Keyword And Ignore Error    Get Value From Json    ${json_object}    ${json_path}
    IF    '${status}' == 'PASS'
        RETURN    ${value[0]}
    ELSE
        RETURN    ${default_value}
    END

*** Test Cases ***
Teste com Tratamento de Erro
    ${api_response}=    Convert String to JSON    {"user": {"name": "João"}}
    
    ${name}=    Buscar Valor JSON Seguro    ${api_response}    $.user.name    Nome não encontrado
    Should Be Equal    ${name}    João
    
    ${age}=    Buscar Valor JSON Seguro    ${api_response}    $.user.age    0
    Should Be Equal As Numbers    ${age}    0
```

### 3. Validação Robusta

```robotframework
*** Keywords ***
Validar Estrutura Completa Usuario
    [Arguments]    ${user_json}
    [Documentation]    Validação completa de estrutura de usuário
    
    # Campos obrigatórios
    @{required_fields}=    Create List    id    name    email    active
    FOR    ${field}    IN    @{required_fields}
        Should Have Value In Json    ${user_json}    $.${field}
    END
    
    # Validações de tipo
    ${user_id}=    Get Value From Json    ${user_json}    $.id
    Should Be True    isinstance(${user_id[0]}, int)
    
    ${active_status}=    Get Value From Json    ${user_json}    $.active
    Should Be True    isinstance(${active_status[0]}, bool)
    
    # Validações de negócio
    ${email}=    Get Value From Json    ${user_json}    $.email
    Should Match Regexp    ${email[0]}    ^[\\w\\.-]+@[\\w\\.-]+\\.[a-zA-Z]{2,}$
```

### 4. Reutilização com Factory Pattern

```robotframework
*** Keywords ***
# Factory para criação de dados JSON
Criar Produto JSON
    [Arguments]    ${name}    ${price}    ${category}=general
    ${timestamp}=    Get Current Date    result_format=epoch
    ${product}=    Create Dictionary    
    ...    id=${timestamp}
    ...    name=${name}
    ...    price=${price}
    ...    category=${category}
    ...    created_at=${CURDIR}
    ...    active=True
    RETURN    ${product}

# Validador genérico
Validar Objeto Produto
    [Arguments]    ${product_json}
    Should Have Value In Json    ${product_json}    $.id
    Should Have Value In Json    ${product_json}    $.name
    Should Have Value In Json    ${product_json}    $.price
    
    ${price}=    Get Value From Json    ${product_json}    $.price
    Should Be True    ${price[0]} > 0
```

## Integração com Outras Libraries

### Com RequestsLibrary

```robotframework
*** Test Cases ***
Teste Integrado API com JSON
    # Fazer requisição
    ${response}=    GET    https://api.example.com/users/1
    
    # Processar JSON da resposta
    ${user_data}=    Set Variable    ${response.json()}
    
    # Validar com JSONLibrary
    Should Have Value In Json    ${user_data}    $.id
    ${user_name}=    Get Value From Json    ${user_data}    $.name
    
    # Usar dados para próxima requisição
    ${update_data}=    Create Dictionary    last_access=${CURDIR}
    ${updated_user}=    Add Object To Json    ${user_data}    $    ${update_data}
    
    ${update_response}=    PUT    https://api.example.com/users/1    json=${updated_user}
    Should Be Equal As Numbers    ${update_response.status_code}    200
```

## Troubleshooting

### Problemas Comuns

1. **JSONPath não encontra valor**
   - Verificar a estrutura JSON com `Log    ${json_object}`
   - Usar JSONPath online validators para testar expressões

2. **Erro de tipo ao comparar valores**
   - Valores extraídos vêm em listas: usar `${value[0]}`
   - Converter tipos quando necessário: `Convert To Integer`, `Convert To String`

3. **Performance com JSONs grandes**
   - Usar JSONPath específicos ao invés de wildcards quando possível
   - Evitar buscas recursivas `..` desnecessárias

### Debug e Logging

```robotframework
*** Keywords ***
Debug JSON Structure
    [Arguments]    ${json_object}    ${description}=JSON Object
    Log    ${description}:    level=INFO
    ${json_string}=    Convert Json To String    ${json_object}
    Log    ${json_string}    level=INFO

*** Test Cases ***
Teste com Debug
    ${api_response}=    GET    https://api.example.com/data
    ${json_data}=    Set Variable    ${api_response.json()}
    
    Debug JSON Structure    ${json_data}    API Response
    
    ${specific_value}=    Get Value From Json    ${json_data}    $.target.field
    Log    Valor extraído: ${specific_value}
```

## Exemplos Avançados

### 1. Processamento de Arrays Complexos

```robotframework
*** Test Cases ***
Processar Lista de Usuários
    ${users_response}=    Convert String to JSON
    ...    {
    ...        "users": [
    ...            {"id": 1, "name": "João", "active": true, "roles": ["user", "admin"]},
    ...            {"id": 2, "name": "Maria", "active": false, "roles": ["user"]},
    ...            {"id": 3, "name": "Pedro", "active": true, "roles": ["user", "manager"]}
    ...        ],
    ...        "total": 3
    ...    }
    
    # Contar usuários ativos
    ${active_users}=    Get Value From Json    ${users_response}    $.users[?(@.active==true)]
    Length Should Be    ${active_users}    2
    
    # Obter todos os usuários com role admin
    ${admins}=    Get Value From Json    ${users_response}    $.users[?('admin' in @.roles)]
    Length Should Be    ${admins}    1
    
    # Somar todos os IDs
    ${all_ids}=    Get Value From Json    ${users_response}    $.users[*].id
    ${sum_ids}=    Evaluate    sum(${all_ids})
    Should Be Equal As Numbers    ${sum_ids}    6
```

### 2. Manipulação Dinâmica de Estruturas

```robotframework
*** Keywords ***
Construir JSON Dinamicamente
    [Arguments]    @{fields_and_values}
    ${json_obj}=    Create Dictionary
    
    FOR    ${index}    IN RANGE    0    len(${fields_and_values})    2
        ${field}=    Set Variable    ${fields_and_values}[${index}]
        ${value}=    Set Variable    ${fields_and_values}[${index + 1}]
        ${json_obj}=    Add Object To Json    ${json_obj}    $.${field}    ${value}
    END
    
    RETURN    ${json_obj}

*** Test Cases ***
Teste Construção Dinâmica
    ${dynamic_json}=    Construir JSON Dinamicamente    
    ...    name    João Silva    
    ...    email    joao@example.com    
    ...    active    ${True}    
    ...    age    ${30}
    
    Should Have Value In Json    ${dynamic_json}    $.name
    Should Have Value In Json    ${dynamic_json}    $.email
    Should Have Value In Json    ${dynamic_json}    $.active
    Should Have Value In Json    ${dynamic_json}    $.age
```

## Considerações de Performance

- **Use JSONPath específicos**: Evite wildcards desnecessários
- **Cache objetos JSON**: Não recarregue o mesmo arquivo múltiplas vezes
- **Valide estruturas grandes por partes**: Divida validações complexas
- **Use Should Have/Should Not Have**: Mais eficiente para verificações simples

## Compatibilidade

- **Python**: 3.6+
- **Robot Framework**: 4.0+
- **Dependências**: jsonpath-ng
- **Sistemas**: Windows, Linux, macOS

## Links Úteis

- **Documentação oficial**: https://robotframework-thailand.github.io/robotframework-jsonlibrary/
- **Repositório GitHub**: https://github.com/robotframework-thailand/robotframework-jsonlibrary
- **JSONPath Online Tool**: https://jsonpath.com/
- **JSON Schema Validator**: https://www.jsonschemavalidator.net/

Esta documentação abrange os aspectos essenciais da JSONLibrary para uso efetivo em projetos de automação de testes com Robot Framework, especialmente no contexto de testes de API REST.
# DatabaseLibrary - Robot Framework Database Testing

## Visão Geral

A DatabaseLibrary é uma biblioteca oficial do Robot Framework que permite interação completa com bancos de dados, oferecendo keywords para consultas, validações e gerenciamento de transações. Suporta múltiplos SGBDs através de módulos Python compatíveis com DB API 2.0.

## Instalação

```bash
# Instalação da biblioteca principal
pip install robotframework-databaselibrary

# Módulos específicos por SGBD
pip install psycopg2          # PostgreSQL
pip install pymysql           # MySQL
pip install sqlite3           # SQLite (já incluído no Python)
pip install pyodbc            # SQL Server
```

## Configuração de Conexões

### PostgreSQL
```robotframework
*** Settings ***
Library    DatabaseLibrary

*** Keywords ***
Connect To PostgreSQL
    Connect To Database
    ...    psycopg2
    ...    db_name=${DB_NAME}
    ...    db_user=${DB_USER}
    ...    db_password=${DB_PASSWORD}
    ...    db_host=${DB_HOST}
    ...    db_port=5432
    ...    alias=postgres
```

### MySQL
```robotframework
Connect To MySQL
    Connect To Database
    ...    pymysql
    ...    db_name=${DB_NAME}
    ...    db_user=${DB_USER}
    ...    db_password=${DB_PASSWORD}
    ...    db_host=${DB_HOST}
    ...    db_port=3306
    ...    alias=mysql
```

### SQLite
```robotframework
Connect To SQLite
    Connect To Database
    ...    sqlite3
    ...    database=./data/testdata.db
    ...    isolation_level=${None}
    ...    alias=sqlite
```

### SQL Server
```robotframework
Connect To SQL Server
    Connect To Database Using Custom Params
    ...    pyodbc
    ...    'Driver={ODBC Driver 17 for SQL Server};Server=${DB_HOST};Database=${DB_NAME};UID=${DB_USER};PWD=${DB_PASSWORD}'
    ...    alias=sqlserver
```

## Keywords Principais

### Conexão e Desconexão
- **Connect To Database**: Estabelece conexão com o banco
- **Connect To Database Using Custom Params**: Conexão com parâmetros customizados
- **Disconnect From Database**: Encerra conexão específica
- **Disconnect From All Databases**: Encerra todas as conexões

### Execução de Consultas
- **Query**: Executa SELECT e retorna resultados
- **Execute SQL String**: Executa comandos SQL (INSERT, UPDATE, DELETE)
- **Execute SQL Script**: Executa script SQL de arquivo
- **Row Count**: Retorna número de linhas de uma consulta

### Validações e Verificações
- **Check If Exists In Database**: Verifica existência de dados
- **Check Query Result**: Valida resultado de consulta
- **Row Count Should Be**: Verifica número específico de linhas
- **Row Count Should Be Equal To X**: Alias para verificação de contagem
- **Table Must Exist**: Verifica existência de tabela

## Exemplos Práticos

### Teste Básico de Validação
```robotframework
*** Test Cases ***
Validar Usuario Existente
    [Documentation]    Valida se usuário existe na base
    Connect To PostgreSQL
    ${result}=    Query    SELECT id, name FROM users WHERE email='test@example.com'
    Should Not Be Empty    ${result}
    Should Be Equal    ${result}[0][1]    Test User
    Disconnect From Database
```

### Teste de Inserção e Validação
```robotframework
*** Test Cases ***
Inserir e Validar Produto
    [Documentation]    Insere produto e valida inserção
    Connect To MySQL
    
    # Inserir dados
    Execute SQL String    
    ...    INSERT INTO products (name, price, category_id) 
    ...    VALUES ('Produto Teste', 29.99, 1)
    
    # Validar inserção
    ${count}=    Row Count    SELECT * FROM products WHERE name='Produto Teste'
    Should Be Equal As Numbers    ${count}    1
    
    # Cleanup
    Execute SQL String    DELETE FROM products WHERE name='Produto Teste'
    Disconnect From Database
```

### Múltiplas Conexões
```robotframework
*** Test Cases ***
Sincronizar Dados Entre Bancos
    [Documentation]    Sincroniza dados entre PostgreSQL e MySQL
    
    # Conectar aos dois bancos
    Connect To Database    psycopg2    ${PG_DB}    alias=source
    Connect To Database    pymysql     ${MY_DB}    alias=target
    
    # Buscar dados da origem
    ${users}=    Query    SELECT * FROM users WHERE active=true    alias=source
    
    # Validar dados no destino
    FOR    ${user}    IN    @{users}
        ${exists}=    Check If Exists In Database    
        ...    SELECT id FROM users WHERE email='${user}[2]'    alias=target
        Should Be True    ${exists}
    END
    
    Disconnect From All Databases
```

## Integração com Factory Pattern

### Biblioteca Python para Geração de Dados
```python
# libraries/database_factory.py
import random
from datetime import datetime, timedelta
from robot.api.deco import keyword

class DatabaseFactory:
    
    @keyword
    def generate_user_data(self, count=1):
        """Gera dados de usuários para inserção em massa"""
        users = []
        for i in range(count):
            user = {
                'name': f'User Test {i+1}',
                'email': f'user{i+1}@test.com',
                'age': random.randint(18, 65),
                'created_at': datetime.now() - timedelta(days=random.randint(1, 365))
            }
            users.append(user)
        return users
    
    @keyword
    def generate_product_data(self, category_id, count=1):
        """Gera dados de produtos para categoria específica"""
        products = []
        for i in range(count):
            product = {
                'name': f'Product {category_id}-{i+1}',
                'price': round(random.uniform(10.0, 999.99), 2),
                'category_id': category_id,
                'stock': random.randint(0, 100)
            }
            products.append(product)
        return products
    
    @keyword
    def create_bulk_insert_sql(self, table_name, data_list):
        """Cria SQL para inserção em massa"""
        if not data_list:
            return ""
        
        columns = list(data_list[0].keys())
        columns_str = ', '.join(columns)
        
        values_list = []
        for item in data_list:
            values = [f"'{item[col]}'" if isinstance(item[col], str) 
                     else str(item[col]) for col in columns]
            values_list.append(f"({', '.join(values)})")
        
        values_str = ', '.join(values_list)
        return f"INSERT INTO {table_name} ({columns_str}) VALUES {values_str}"
```

### Resource com Keywords de Alto Nível
```robotframework
# resources/data/database_data_factory.resource
*** Settings ***
Library    DatabaseLibrary
Library    ../../libraries/database_factory.py

*** Keywords ***
Setup Test Database
    [Documentation]    Configura banco com dados de teste
    [Arguments]    ${alias}=default
    
    # Limpar dados existentes
    Execute SQL String    TRUNCATE TABLE users CASCADE    alias=${alias}
    Execute SQL String    TRUNCATE TABLE products CASCADE    alias=${alias}
    Execute SQL String    TRUNCATE TABLE categories CASCADE    alias=${alias}
    
    # Inserir categorias base
    Execute SQL String    
    ...    INSERT INTO categories (id, name) VALUES 
    ...    (1, 'Electronics'), (2, 'Books'), (3, 'Clothing')    
    ...    alias=${alias}

Create Mass Test Users
    [Documentation]    Cria usuários em massa para testes
    [Arguments]    ${count}=100    ${alias}=default
    
    ${users}=    Generate User Data    ${count}
    ${sql}=    Create Bulk Insert SQL    users    ${users}
    Execute SQL String    ${sql}    alias=${alias}
    
    # Validar inserção
    ${actual_count}=    Row Count    SELECT * FROM users    alias=${alias}
    Should Be Equal As Numbers    ${actual_count}    ${count}

Create Mass Test Products
    [Documentation]    Cria produtos em massa para testes
    [Arguments]    ${category_id}    ${count}=50    ${alias}=default
    
    ${products}=    Generate Product Data    ${category_id}    ${count}
    ${sql}=    Create Bulk Insert SQL    products    ${products}
    Execute SQL String    ${sql}    alias=${alias}
    
    # Validar inserção
    ${actual_count}=    Row Count    
    ...    SELECT * FROM products WHERE category_id=${category_id}    
    ...    alias=${alias}
    Should Be Equal As Numbers    ${actual_count}    ${count}
```

### Uso em Testes
```robotframework
*** Settings ***
Resource    ../resources/data/database_data_factory.resource

*** Test Cases ***
Teste Performance Com Massa De Dados
    [Documentation]    Testa performance com grande volume de dados
    [Tags]    performance    database
    
    Connect To PostgreSQL
    
    # Setup com dados em massa
    Setup Test Database
    Create Mass Test Users    count=1000
    Create Mass Test Products    category_id=1    count=500
    Create Mass Test Products    category_id=2    count=300
    
    # Teste de performance
    ${start_time}=    Get Time    epoch
    ${results}=    Query    
    ...    SELECT u.name, p.name, p.price 
    ...    FROM users u 
    ...    JOIN orders o ON u.id = o.user_id 
    ...    JOIN products p ON o.product_id = p.id 
    ...    WHERE p.category_id = 1
    ${end_time}=    Get Time    epoch
    
    # Validações
    ${execution_time}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${execution_time} < 5    Query muito lenta: ${execution_time}s
    
    Disconnect From Database
```

## Configuração via Arquivo

### arquivo resources/db.cfg
```ini
[DEFAULT]
host = 127.0.0.1
port = 5432
user = testuser
password = testpass

[postgres_test]
module = psycopg2
database = test_db
host = ${DEFAULT:host}
port = ${DEFAULT:port}
user = ${DEFAULT:user}
password = ${DEFAULT:password}

[mysql_test]
module = pymysql
database = test_db
host = ${DEFAULT:host}
port = 3306
user = ${DEFAULT:user}
password = ${DEFAULT:password}
```

### Uso da Configuração
```robotframework
*** Keywords ***
Connect Using Config
    [Arguments]    ${config_file}=./resources/db.cfg    ${alias}=postgres_test
    Connect To Database    configfile=${config_file}    alias=${alias}
```

## Estratégias de Teste com Strategy Pattern

### Biblioteca de Estratégias
```python
# libraries/database_strategy.py
from abc import ABC, abstractmethod
from robot.api.deco import keyword

class DatabaseTestStrategy(ABC):
    @abstractmethod
    def setup_test_data(self, connection_alias):
        pass
    
    @abstractmethod
    def cleanup_test_data(self, connection_alias):
        pass

class PostgreSQLStrategy(DatabaseTestStrategy):
    def setup_test_data(self, connection_alias):
        # Implementação específica PostgreSQL
        return f"TRUNCATE TABLE users RESTART IDENTITY CASCADE"
    
    def cleanup_test_data(self, connection_alias):
        return f"DELETE FROM users WHERE email LIKE '%test%'"

class MySQLStrategy(DatabaseTestStrategy):
    def setup_test_data(self, connection_alias):
        # Implementação específica MySQL
        return f"TRUNCATE TABLE users"
    
    def cleanup_test_data(self, connection_alias):
        return f"DELETE FROM users WHERE email LIKE '%test%'"

class DatabaseTestContext:
    def __init__(self):
        self.strategies = {
            'postgresql': PostgreSQLStrategy(),
            'mysql': MySQLStrategy()
        }
    
    @keyword
    def execute_database_strategy(self, db_type, operation, connection_alias='default'):
        """Executa estratégia específica por tipo de banco"""
        strategy = self.strategies.get(db_type.lower())
        if not strategy:
            raise ValueError(f"Estratégia não encontrada para {db_type}")
        
        if operation == 'setup':
            return strategy.setup_test_data(connection_alias)
        elif operation == 'cleanup':
            return strategy.cleanup_test_data(connection_alias)
        else:
            raise ValueError(f"Operação inválida: {operation}")
```

## Melhores Práticas

### 1. Gerenciamento de Conexões
```robotframework
*** Keywords ***
Database Test Setup
    [Arguments]    ${db_type}=postgresql
    Run Keyword If    '${db_type}' == 'postgresql'    Connect To PostgreSQL
    Run Keyword If    '${db_type}' == 'mysql'        Connect To MySQL
    Run Keyword If    '${db_type}' == 'sqlite'       Connect To SQLite

Database Test Teardown
    [Documentation]    Cleanup após testes
    Run Keyword And Ignore Error    Disconnect From All Databases
```

### 2. Tratamento de Transações
```robotframework
*** Keywords ***
Execute With Transaction Rollback
    [Documentation]    Executa operação com rollback automático
    [Arguments]    ${sql_commands}
    
    Execute SQL String    BEGIN TRANSACTION
    Run Keyword And Return Status    Execute SQL String    ${sql_commands}
    Execute SQL String    ROLLBACK
```

### 3. Validações Robustas
```robotframework
*** Keywords ***
Validate Data Integrity
    [Documentation]    Valida integridade dos dados
    [Arguments]    ${table}    ${expected_count}
    
    ${actual_count}=    Row Count    SELECT * FROM ${table}
    Should Be Equal As Numbers    ${actual_count}    ${expected_count}
    
    # Verificar dados órfãos
    ${orphan_count}=    Row Count    
    ...    SELECT * FROM ${table} WHERE parent_id NOT IN (SELECT id FROM parent_table)
    Should Be Equal As Numbers    ${orphan_count}    0
```

### 4. Logging e Debugging
```robotframework
*** Settings ***
Library    DatabaseLibrary    log_query_results=True    log_query_results_head=10

*** Keywords ***
Execute Query With Logging
    [Documentation]    Executa query com log detalhado
    [Arguments]    ${query}    ${alias}=default
    
    Log    Executando query: ${query}    WARN
    ${result}=    Query    ${query}    alias=${alias}
    Log Many    @{result}
    [Return]    ${result}
```

### 5. Testes Parametrizados
```robotframework
*** Test Cases ***
Teste Multiplataforma Database
    [Template]    Test Database Operations
    postgresql    SELECT version()
    mysql         SELECT VERSION()
    sqlite        SELECT sqlite_version()

*** Keywords ***
Test Database Operations
    [Arguments]    ${db_type}    ${version_query}
    Database Test Setup    ${db_type}
    ${version}=    Query    ${version_query}
    Should Not Be Empty    ${version}
    Database Test Teardown
```

## Integração com CI/CD

### Configuração de Ambiente
```robotframework
*** Variables ***
${DB_HOST}         %{DB_HOST=localhost}
${DB_USER}         %{DB_USER=testuser}
${DB_PASSWORD}     %{DB_PASSWORD=testpass}
${DB_NAME}         %{DB_NAME=testdb}

*** Keywords ***
Setup CI Database Environment
    [Documentation]    Configura ambiente para CI/CD
    
    # Aguardar banco estar disponível
    Wait Until Keyword Succeeds    30s    2s    Connect To PostgreSQL
    
    # Verificar se estrutura existe
    ${tables_exist}=    Run Keyword And Return Status    
    ...    Table Must Exist    users
    
    Run Keyword If    not ${tables_exist}    Setup Database Schema
```

## Monitoramento e Métricas

### Keywords de Performance
```robotframework
*** Keywords ***
Measure Query Performance
    [Documentation]    Mede performance de query
    [Arguments]    ${query}    ${max_time_seconds}=5
    
    ${start}=    Get Time    epoch
    ${result}=    Query    ${query}
    ${end}=    Get Time    epoch
    ${duration}=    Evaluate    ${end} - ${start}
    
    Should Be True    ${duration} <= ${max_time_seconds}    
    ...    Query muito lenta: ${duration}s > ${max_time_seconds}s
    
    Log    Query executada em ${duration}s    INFO
    [Return]    ${result}
```

A DatabaseLibrary oferece uma solução robusta e flexível para testes de banco de dados no Robot Framework, permitindo implementação de padrões avançados como Factory e Strategy para gerenciamento eficiente de dados de teste em ambientes complexos de CI/CD.
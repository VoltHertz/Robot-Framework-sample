# robotframework-datadriver - Documentação Completa

## Visão Geral

A **robotframework-datadriver** é uma biblioteca poderosa para criação de testes data-driven no Robot Framework. Ela permite gerar múltiplos casos de teste baseados em um template e dados externos provenientes de arquivos CSV, Excel, ou fontes customizadas como bancos de dados.

### Principais Características

- **Geração Dinâmica**: Cria casos de teste automaticamente baseados em dados externos
- **Múltiplos Formatos**: Suporte nativo para CSV, Excel (.xls, .xlsx)
- **Extensibilidade**: Permite criação de readers customizados para qualquer fonte de dados
- **Tipos Complexos**: Suporte para variáveis escalares, listas, dicionários e avaliações Python
- **Integração CI/CD**: Otimizado para execução paralela com Pabot
- **Factory Pattern**: Implementação natural do padrão Factory para geração de dados de teste

## Instalação

### Instalação Básica
```bash
pip install --upgrade robotframework-datadriver
```

### Com Suporte ao Excel
```bash
pip install --upgrade robotframework-datadriver[XLS]
```

### Dependências
- Robot Framework >= 3.1
- Python >= 3.6
- Para Excel: pandas, numpy, xlrd (incluídos com [XLS])

## Configuração Básica

### Estrutura Mínima
```robotframework
*** Settings ***
Library    DataDriver
Test Template    Login With User And Password

*** Test Cases ***
Login with user ${username} and password ${password}
    [Documentation]    Template for data-driven login tests
    Default UserData

*** Keywords ***
Login With User And Password
    [Arguments]    ${username}    ${password}
    Log Many    ${username}    ${password}
    # Implementar lógica de login aqui
```

## Fontes de Dados Suportadas

### 1. Arquivos CSV

#### Configuração Padrão
```robotframework
*** Settings ***
Library    DataDriver    file=test_data.csv
```

#### Configurações Avançadas CSV
```robotframework
*** Settings ***
Library    DataDriver
...    file=test_data.csv
...    encoding=utf-8
...    dialect=excel
...    delimiter=;
...    quotechar="
...    escapechar=\\
```

#### Exemplo de Arquivo CSV
```csv
*** Test Cases ***,${username},${password},[Tags],[Documentation]
Valid Login,demo,mode,smoke,Test with valid credentials
Invalid Login,demo,wrong,negative,Test with invalid password
Empty Password,demo,,edge_case,Test with empty password
```

### 2. Arquivos Excel

#### Configuração Excel
```robotframework
*** Settings ***
Library    DataDriver
...    file=test_data.xlsx
...    sheet_name=TestData
...    reader_class=xlsx_reader
```

#### Exemplo de Estrutura Excel
| *** Test Cases *** | ${username} | ${password} | [Tags] | [Documentation] |
|---------------------|-------------|-------------|---------|-----------------|
| Valid Login         | demo        | mode        | smoke   | Valid test      |
| Invalid Login       | demo        | wrong       | negative| Invalid test    |

### 3. Fontes Customizadas (Banco de Dados)

#### Implementação de Custom Reader
```python
# sql_reader.py
from DataDriver.AbstractReaderClass import AbstractReaderClass
from DataDriver.ReaderConfig import TestCaseData
import sqlite3

class sql_reader(AbstractReaderClass):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.database = kwargs.get('database', 'test.db')
        self.query = kwargs.get('query', 'SELECT * FROM test_data')
        self.connection = None

    def get_data_from_source(self):
        test_data = []
        
        try:
            # Conectar ao banco de dados
            self.connection = sqlite3.connect(self.database)
            cursor = self.connection.cursor()
            
            # Executar query
            cursor.execute(self.query)
            rows = cursor.fetchall()
            
            # Obter nomes das colunas
            column_names = [description[0] for description in cursor.description]
            
            # Converter dados para TestCaseData
            for i, row in enumerate(rows):
                test_case_name = f"Test Case {i+1}"
                arguments = {}
                tags = []
                documentation = ""
                
                for j, value in enumerate(row):
                    column_name = column_names[j]
                    if column_name == 'test_name':
                        test_case_name = value
                    elif column_name == 'tags':
                        tags = value.split(',') if value else []
                    elif column_name == 'documentation':
                        documentation = value or ""
                    else:
                        arguments[f'${{{column_name}}}'] = value
                
                test_data.append(TestCaseData(
                    test_case_name, 
                    arguments, 
                    tags, 
                    documentation
                ))
                
        except Exception as e:
            self.logger.error(f"Erro ao conectar ao banco: {e}")
            raise
        finally:
            if self.connection:
                self.connection.close()
                
        return test_data
```

#### Uso do Custom Reader
```robotframework
*** Settings ***
Library    DataDriver
...    reader_class=sql_reader
...    database=test_database.db
...    query=SELECT username, password, test_name, tags FROM user_tests
```

## Factory Pattern Integration

### Implementação com Factory Pattern
```python
# data_factory.py
from DataDriver.AbstractReaderClass import AbstractReaderClass
from DataDriver.ReaderConfig import TestCaseData
import random
import string

class DataFactory(AbstractReaderClass):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.test_count = int(kwargs.get('test_count', 10))
        self.test_type = kwargs.get('test_type', 'login')

    def generate_user_data(self):
        """Gera dados de usuário usando Factory Pattern"""
        return {
            'username': ''.join(random.choices(string.ascii_lowercase, k=8)),
            'password': ''.join(random.choices(string.ascii_letters + string.digits, k=12)),
            'email': f"test{random.randint(1000, 9999)}@example.com"
        }

    def generate_product_data(self):
        """Gera dados de produto usando Factory Pattern"""
        return {
            'product_id': random.randint(1, 1000),
            'product_name': f"Product {random.randint(1, 100)}",
            'price': round(random.uniform(10.0, 1000.0), 2)
        }

    def get_data_from_source(self):
        test_data = []
        
        for i in range(self.test_count):
            if self.test_type == 'login':
                data = self.generate_user_data()
            elif self.test_type == 'product':
                data = self.generate_product_data()
            else:
                raise ValueError(f"Tipo de teste não suportado: {self.test_type}")
            
            # Converter dados para formato DataDriver
            arguments = {f'${{{k}}}': v for k, v in data.items()}
            
            test_data.append(TestCaseData(
                f"{self.test_type.title()} Test {i+1}",
                arguments,
                [self.test_type, 'generated'],
                f"Teste gerado automaticamente para {self.test_type}"
            ))
        
        return test_data
```

### Uso da Factory
```robotframework
*** Settings ***
Library    DataDriver
...    reader_class=DataFactory
...    test_count=50
...    test_type=login
```

## Recursos Avançados

### 1. Tipos de Dados Complexos

#### Listas e Dicionários
```csv
*** Test Cases ***,${user_data},${permissions},${config}
Admin Test,"{'name': 'admin', 'role': 'administrator'}","['read', 'write', 'delete']","{'timeout': 30, 'retry': 3}"
```

#### Avaliação Literal Python
```csv
*** Test Cases ***,${number},${calculation}
Math Test,42,"${number} * 2"
```

### 2. Variáveis de Suite

O DataDriver disponibiliza variáveis automáticas:
- `@{DataDriver_DATA_LIST}`: Lista com todos os dados carregados
- `${DataDriver_TEST_DATA}`: Dados do teste atual
- `${DataDriver_DATA_FILE}`: Caminho do arquivo de dados

### 3. Execução Seletiva

#### Teste Específico
```bash
robot --variable DYNAMICTEST:TestSuite.SpecificTest test_suite.robot
```

#### Múltiplos Testes
```bash
robot --variable DYNAMICTESTS:"Test1|Test2|Test3" test_suite.robot
```

### 4. Integração com Pabot (Execução Paralela)

```bash
pabot --processes 4 --testlevelsplit test_suite.robot
```

O DataDriver otimiza automaticamente a divisão de testes para execução paralela.

## Melhores Práticas para CI/CD

### 1. Estrutura de Projeto
```
tests/
├── data/
│   ├── users.csv
│   ├── products.xlsx
│   └── test_config.json
├── resources/
│   ├── data_readers/
│   │   ├── database_reader.py
│   │   └── api_reader.py
│   └── keywords/
└── suites/
    ├── api_tests.robot
    └── ui_tests.robot
```

### 2. Configuração de Ambiente
```robotframework
*** Settings ***
Library    DataDriver
...    file=${DATA_DIR}/test_data.csv
...    encoding=utf-8
...    file_search_strategy=PATH
...    file_regex=.*\\.csv$

*** Variables ***
${DATA_DIR}    %{DATA_DIR=/default/path}
```

### 3. Gestão de Dados Sensíveis
```python
# secure_reader.py
import os
from DataDriver.AbstractReaderClass import AbstractReaderClass

class SecureReader(AbstractReaderClass):
    def get_data_from_source(self):
        # Usar variáveis de ambiente para dados sensíveis
        db_password = os.getenv('DB_PASSWORD')
        # Implementar lógica segura
```

### 4. Logging e Monitoramento
```robotframework
*** Keywords ***
Login With User And Password
    [Arguments]    ${username}    ${password}
    Log    Executando teste para usuário: ${username}    # Não logar senha
    Set Test Documentation    Teste data-driven para ${username}
```

### 5. Validação de Dados
```python
# validated_reader.py
from DataDriver.AbstractReaderClass import AbstractReaderClass
from DataDriver.ReaderConfig import TestCaseData
import jsonschema

class ValidatedReader(AbstractReaderClass):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.schema = kwargs.get('schema', {})

    def validate_data(self, data):
        if self.schema:
            jsonschema.validate(data, self.schema)
        return data

    def get_data_from_source(self):
        # Implementar validação de dados antes de retornar
        pass
```

## Grandes Volumes de Dados

### 1. Otimização de Performance
```python
# optimized_reader.py
from DataDriver.AbstractReaderClass import AbstractReaderClass
import pandas as pd

class OptimizedReader(AbstractReaderClass):
    def get_data_from_source(self):
        # Usar pandas para grandes volumes
        df = pd.read_csv(self.file, chunksize=1000)
        test_data = []
        
        for chunk in df:
            # Processar em chunks para economizar memória
            for _, row in chunk.iterrows():
                # Converter para TestCaseData
                pass
        
        return test_data
```

### 2. Filtros e Condições
```robotframework
*** Settings ***
Library    DataDriver
...    reader_class=FilteredReader
...    filter_condition=status='active'
...    limit=100
```

### 3. Cache de Dados
```python
# cached_reader.py
import pickle
from DataDriver.AbstractReaderClass import AbstractReaderClass

class CachedReader(AbstractReaderClass):
    def get_data_from_source(self):
        cache_file = f"{self.file}.cache"
        
        if os.path.exists(cache_file):
            with open(cache_file, 'rb') as f:
                return pickle.load(f)
        
        # Gerar dados se não houver cache
        data = self._generate_data()
        
        with open(cache_file, 'wb') as f:
            pickle.dump(data, f)
        
        return data
```

## Exemplos Práticos Completos

### 1. Teste de API com Dados de Banco
```robotframework
*** Settings ***
Library    DataDriver
...    reader_class=api_database_reader
...    database_url=${DB_URL}
...    query=SELECT endpoint, method, payload, expected_status FROM api_tests
Test Template    Execute API Test

*** Test Cases ***
API Test ${endpoint} ${method}
    [Documentation]    Data-driven API test
    Default UserData

*** Keywords ***
Execute API Test
    [Arguments]    ${endpoint}    ${method}    ${payload}    ${expected_status}
    ${response}=    Run Keyword    ${method} Request    ${endpoint}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
```

### 2. Teste de UI com Factory Pattern
```robotframework
*** Settings ***
Library    DataDriver
...    reader_class=ui_data_factory
...    test_count=20
...    browser=chrome
Test Template    UI Registration Test

*** Test Cases ***
Registration Test ${username}
    [Documentation]    Data-driven UI registration test
    Default UserData

*** Keywords ***
UI Registration Test
    [Arguments]    ${username}    ${email}    ${password}
    Open Browser    ${BASE_URL}/register    ${BROWSER}
    Input Text    username_field    ${username}
    Input Text    email_field    ${email}
    Input Text    password_field    ${password}
    Click Button    register_button
    Page Should Contain    Registration Successful
    Close Browser
```

## Troubleshooting

### Problemas Comuns

1. **Encoding Issues**: Sempre especificar encoding correto
2. **Performance**: Usar chunks para grandes volumes
3. **Memory**: Implementar cache quando necessário
4. **Parallel Execution**: Configurar Pabot adequadamente

### Debug
```robotframework
*** Settings ***
Library    DataDriver    
...    file=debug_data.csv
...    file_search_strategy=PATH
...    config_keyword=Configure Debug

*** Keywords ***
Configure Debug
    Log    DataDriver configurado com: ${DataDriver_DATA_FILE}
    Log Many    @{DataDriver_DATA_LIST}
```

## Integração com Design Patterns

### Service Object Pattern
```python
# service_data_reader.py
class ServiceDataReader(AbstractReaderClass):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.service = kwargs.get('service_class')()

    def get_data_from_source(self):
        return self.service.get_test_data()
```

### Strategy Pattern
```python
# strategy_reader.py
class StrategyDataReader(AbstractReaderClass):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.strategy = self._get_strategy(kwargs.get('strategy'))

    def _get_strategy(self, strategy_name):
        strategies = {
            'database': DatabaseStrategy(),
            'api': ApiStrategy(),
            'file': FileStrategy()
        }
        return strategies.get(strategy_name)

    def get_data_from_source(self):
        return self.strategy.get_data()
```

## Conclusão

A robotframework-datadriver é uma ferramenta poderosa para implementação de padrões data-driven em projetos Robot Framework de grande escala. Sua flexibilidade permite integração com diversas fontes de dados e implementação natural de Design Patterns como Factory e Strategy, sendo ideal para ambientes CI/CD com centenas de casos de teste.

### Benefícios Principais

- **Escalabilidade**: Suporte a grandes volumes de dados
- **Flexibilidade**: Múltiplas fontes de dados
- **Manutenibilidade**: Separação clara entre lógica e dados
- **Performance**: Otimizado para execução paralela
- **Extensibilidade**: Facilidade para criar readers customizados

### Considerações para Projetos Grandes

- Implementar cache para dados estáticos
- Usar validação de schema para dados complexos
- Configurar execução paralela adequadamente
- Monitorar uso de memória em grandes volumes
- Implementar retry e error handling robustos
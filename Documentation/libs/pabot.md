# Pabot - Parallel Executor for Robot Framework

## Overview

Pabot é um executor paralelo para testes Robot Framework que permite dividir uma execução em múltiplas execuções paralelas, economizando tempo significativo na execução de testes. É especialmente útil em ambientes CI/CD com centenas ou milhares de testes funcionais.

**Repositório Oficial:** https://github.com/mkorpela/pabot  
**Site Oficial:** https://pabot.org/  
**PyPI:** https://pypi.org/project/robotframework-pabot/

## Instalação

### Instalação via pip (Recomendada)
```bash
pip install -U robotframework-pabot
```

### Instalação via requirements.txt
```bash
# Em requirements.txt
robotframework-pabot>=2.17.0

# Instalação
pip install -r requirements.txt
```

### Verificação da Instalação
```bash
# Verificar se foi instalada corretamente
pip show robotframework-pabot

# Verificar versão
pabot --version
```

## Conceitos Fundamentais

### Níveis de Paralelização

#### 1. Suite Level (Padrão)
- Cada processo executa uma suite completa
- Testes dentro da mesma suite executam sequencialmente
- Melhor para suites bem organizadas e independentes

#### 2. Test Level
- Cada processo executa um único caso de teste
- Máxima granularidade de paralelização
- Útil para suites com muitos testes independentes

### Estratégias de Distribuição

#### 1. Execução Local Paralela
- Múltiplos processos na mesma máquina
- Compartilham recursos do sistema

#### 2. Sharding (Fragmentação)
- Distribuição não centralizada
- Cada runner trabalha independentemente
- Ideal para CI/CD com múltiplos runners

## Comandos e Configurações

### Sintaxe Básica
```bash
pabot [opções] [opções do robot] [caminho dos testes]
```

### Comandos Principais

#### Execução Básica
```bash
# Execução padrão (suite level)
pabot tests/

# Execução com split por teste
pabot --testlevelsplit tests/

# Especificar número de processos
pabot --processes 4 tests/

# Execução com sharding (para CI/CD distribuído)
pabot --shard 1/4 tests/
pabot --shard 2/4 tests/
pabot --shard 3/4 tests/
pabot --shard 4/4 tests/
```

### Opções de Configuração Avançada

#### Controle de Processos
```bash
# Definir número específico de processos
pabot --processes 8 tests/

# Desabilitar PabotLib (sem compartilhamento de recursos)
pabot --no-pabotlib tests/

# Timeout para processos
pabot --processtimeout 300 tests/
```

#### Gestão de Recursos e Arquivos
```bash
# Especificar arquivos de recursos
pabot --resourcefile resource.txt tests/

# Gerenciar artefatos
pabot --artifacts png,log,html tests/

# Artefatos em subpastas
pabot --artifactsinsubfolders tests/
```

#### Ordenação e Agrupamento
```bash
# Arquivo de ordenação personalizada
pabot --ordering order.txt tests/

# Agrupamento de testes (chunking)
pabot --chunk tests/

# Executar apenas suites específicas
pabot --suitesfrom suites.txt tests/
```

### Configurações Múltiplas
```bash
# Executar com diferentes configurações de argumentos
pabot --argumentfile1 config1.args --argumentfile2 config2.args tests/
```

## Configurações para CI/CD

### GitHub Actions Example
```yaml
name: Robot Framework Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        shard: [1, 2, 3, 4]
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'
    
    - name: Install dependencies
      run: |
        pip install -r requirements.txt
    
    - name: Run tests
      run: |
        pabot --shard ${{ matrix.shard }}/4 \
              --processes 2 \
              --artifacts xml,html,png,log \
              --outputdir results/shard-${{ matrix.shard }} \
              tests/
    
    - name: Upload results
      uses: actions/upload-artifact@v4
      if: always()
      with:
        name: test-results-${{ matrix.shard }}
        path: results/shard-${{ matrix.shard }}/
```

### Jenkins Pipeline Example
```groovy
pipeline {
    agent any
    
    stages {
        stage('Test Parallel') {
            parallel {
                stage('Shard 1') {
                    steps {
                        sh 'pabot --shard 1/4 --processes 2 tests/'
                    }
                }
                stage('Shard 2') {
                    steps {
                        sh 'pabot --shard 2/4 --processes 2 tests/'
                    }
                }
                stage('Shard 3') {
                    steps {
                        sh 'pabot --shard 3/4 --processes 2 tests/'
                    }
                }
                stage('Shard 4') {
                    steps {
                        sh 'pabot --shard 4/4 --processes 2 tests/'
                    }
                }
            }
        }
        
        stage('Merge Results') {
            steps {
                sh 'rebot --outputdir merged_results --merge *.xml'
            }
        }
    }
    
    post {
        always {
            publishHTML([
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'merged_results',
                reportFiles: 'report.html',
                reportName: 'Robot Framework Report'
            ])
        }
    }
}
```

### Azure DevOps Example
```yaml
trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

strategy:
  matrix:
    shard1:
      SHARD: '1/4'
    shard2:
      SHARD: '2/4'
    shard3:
      SHARD: '3/4'
    shard4:
      SHARD: '4/4'

steps:
- task: UsePythonVersion@0
  inputs:
    versionSpec: '3.11'

- script: |
    pip install -r requirements.txt
  displayName: 'Install dependencies'

- script: |
    pabot --shard $(SHARD) \
          --processes 2 \
          --outputdir $(Agent.TempDirectory)/results \
          tests/
  displayName: 'Run Robot Tests'

- task: PublishTestResults@2
  condition: always()
  inputs:
    testResultsFiles: '$(Agent.TempDirectory)/results/output.xml'
    testRunTitle: 'Robot Framework Tests - Shard $(SHARD)'
```

## PabotLib - Compartilhamento de Recursos

### Importação e Uso
```robot
*** Settings ***
Library    pabot.PabotLib

*** Test Cases ***
Test With Shared Resource
    ${value}=    Acquire Value Set    shared_data    key1
    Log    Acquired value: ${value}
    
    # Usar o recurso
    Some Keyword Using    ${value}
    
    # Liberar o recurso
    Release Value Set    shared_data
```

### Métodos Disponíveis

#### Acquire e Release Value Sets
```robot
*** Keywords ***
Use Shared Database Connection
    # Adquirir conexão exclusiva
    ${db_config}=    Acquire Value Set    database_connections    prod_db
    
    # Usar a conexão
    Connect To Database Using Config    ${db_config}
    Execute Sql String    SELECT * FROM users;
    
    # Liberar para outros processos
    Release Value Set    database_connections
```

#### Acquire e Release Locks
```robot
*** Keywords ***
Update Configuration File
    # Adquirir lock exclusivo
    Acquire Lock    config_file_update
    
    # Operações críticas
    ${config}=    Load Configuration
    Set Configuration Value    last_update    ${current_time}
    Save Configuration    ${config}
    
    # Liberar lock
    Release Lock    config_file_update
```

### Variáveis de Ambiente Pabot

```robot
*** Test Cases ***
Get Process Information
    ${process_index}=    Get Environment Variable    PABOTQUEUEINDEX
    ${total_processes}=    Get Environment Variable    PABOTNUMBEROFPROCESSES
    
    Log    Running in process ${process_index} of ${total_processes}
```

## Otimização de Performance

### Determinação do Número de Processos

#### Por CPU Cores
```bash
# Padrão: 2 processos por core CPU
# Para 4 cores = 8 processos padrão

# Personalizar baseado em recursos
pabot --processes $(nproc) tests/           # Linux
pabot --processes %NUMBER_OF_PROCESSORS% tests/  # Windows
```

#### Por Tipo de Teste
```bash
# Testes de API (mais leves) - mais processos
pabot --processes 16 tests/api/

# Testes de UI (mais pesados) - menos processos  
pabot --processes 4 tests/ui/

# Testes de integração - balanceado
pabot --processes 8 tests/integration/
```

### Estratégias de Agrupamento

#### Chunking para Balanceamento
```bash
# Agrupar testes pequenos para melhor distribuição
pabot --chunk --processes 8 tests/
```

#### Ordenação Customizada
```txt
# order.txt - executar testes críticos primeiro
--suite tests.critical
--suite tests.smoke
--suite tests.regression
```

```bash
pabot --ordering order.txt --processes 4 tests/
```

### Configurações de Timeout
```bash
# Timeout para processos individuais (em segundos)
pabot --processtimeout 600 --processes 4 tests/
```

## Melhores Práticas

### 1. Design de Testes para Paralelismo

#### Independência de Testes
```robot
*** Settings ***
Suite Setup       Setup Isolated Environment
Suite Teardown     Cleanup Isolated Environment

*** Keywords ***
Setup Isolated Environment
    # Criar dados únicos por processo
    ${process_id}=    Get Environment Variable    PABOTQUEUEINDEX    0
    Set Suite Variable    ${UNIQUE_ID}    ${process_id}_${SUITE_NAME}
    
    # Setup com dados únicos
    Create Test User    test_user_${UNIQUE_ID}
    Create Test Data    test_data_${UNIQUE_ID}
```

#### Gestão de Recursos Compartilhados
```robot
*** Keywords ***
Use Shared API Endpoint
    # Evitar conflitos em endpoints limitados
    Acquire Lock    api_rate_limit
    
    # Fazer chamada API
    ${response}=    GET    /api/users
    
    # Aguardar rate limit se necessário
    Sleep    0.1s
    
    Release Lock    api_rate_limit
    [Return]    ${response}
```

### 2. Estruturação de Suites

#### Organização por Funcionalidade
```
tests/
├── auth/                 # Suite independente
│   ├── login_tests.robot
│   └── logout_tests.robot
├── products/             # Suite independente  
│   ├── crud_tests.robot
│   └── search_tests.robot
├── orders/               # Suite independente
│   ├── create_tests.robot
│   └── workflow_tests.robot
└── integration/          # Testes end-to-end
    └── full_workflow.robot
```

#### Testes com Dependências
```robot
*** Settings ***
# Para testes com dependências, manter na mesma suite
Suite Setup    Create Base Data For Suite
Test Setup     Reset Test State

*** Test Cases ***
Create User
    [Tags]    dependency
    Create User    john_doe
    Set Suite Variable    ${CREATED_USER}    john_doe

Update User Depends On Create
    [Tags]    depends:Create User
    Should Not Be Empty    ${CREATED_USER}
    Update User    ${CREATED_USER}    new_email=john@example.com

Delete User Depends On Update  
    [Tags]    depends:Update User Depends On Create
    Delete User    ${CREATED_USER}
```

### 3. Configuração de Ambientes CI/CD

#### Requirements.txt Otimizado
```txt
# requirements.txt
robotframework>=7.0
robotframework-pabot>=2.17.0
robotframework-seleniumlibrary>=6.7.0
robotframework-requests>=0.9.7
robotframework-jsonlibrary>=0.5.0

# Dependências para paralelismo
psutil>=5.9.0  # Para monitoramento de recursos
```

#### Script de Execução Inteligente
```bash
#!/bin/bash
# run_tests.sh

# Detectar recursos disponíveis
CPU_CORES=$(nproc)
MEMORY_GB=$(free -g | awk 'NR==2{print $2}')

# Calcular processos ótimos baseado em recursos
if [ $MEMORY_GB -lt 4 ]; then
    PROCESSES=$((CPU_CORES / 2))
elif [ $MEMORY_GB -lt 8 ]; then
    PROCESSES=$CPU_CORES
else
    PROCESSES=$((CPU_CORES * 2))
fi

echo "Executando com $PROCESSES processos (CPU: $CPU_CORES, RAM: ${MEMORY_GB}GB)"

# Executar testes
if [ "$CI" = "true" ]; then
    # Em CI, usar sharding se disponível
    if [ -n "$SHARD" ]; then
        pabot --shard "$SHARD" --processes $PROCESSES tests/
    else
        pabot --processes $PROCESSES tests/
    fi
else
    # Local, execução normal
    pabot --processes $PROCESSES tests/
fi
```

### 4. Monitoramento e Debugging

#### Logs Detalhados
```bash
# Executar com logs verbosos para debugging
pabot --verbose --processes 4 tests/

# Salvar logs de cada processo separadamente
pabot --processes 4 --outputdir results tests/
```

#### Análise de Performance
```python
# analyze_results.py
import xml.etree.ElementTree as ET
from datetime import datetime

def analyze_pabot_results(output_xml):
    tree = ET.parse(output_xml)
    root = tree.getroot()
    
    suites = []
    for suite in root.findall('.//suite'):
        name = suite.get('name')
        start = suite.find('status').get('starttime')
        end = suite.find('status').get('endtime')
        
        # Calcular duração
        start_dt = datetime.strptime(start, '%Y%m%d %H:%M:%S.%f')
        end_dt = datetime.strptime(end, '%Y%m%d %H:%M:%S.%f')
        duration = (end_dt - start_dt).total_seconds()
        
        suites.append({
            'name': name,
            'duration': duration,
            'start': start,
            'end': end
        })
    
    # Análise de balanceamento
    durations = [s['duration'] for s in suites]
    avg_duration = sum(durations) / len(durations)
    
    print(f"Duração média das suites: {avg_duration:.2f}s")
    print(f"Suite mais longa: {max(durations):.2f}s")
    print(f"Suite mais curta: {min(durations):.2f}s")
    
    # Identificar desbalanceamento
    unbalanced = [s for s in suites if abs(s['duration'] - avg_duration) > avg_duration * 0.5]
    if unbalanced:
        print("Suites desbalanceadas:")
        for suite in unbalanced:
            print(f"  {suite['name']}: {suite['duration']:.2f}s")

if __name__ == "__main__":
    analyze_pabot_results("results/output.xml")
```

## Troubleshooting

### Problemas Comuns

#### 1. Processos Travados
```bash
# Adicionar timeout para processos
pabot --processtimeout 300 tests/

# Monitorar processos em execução
ps aux | grep pabot
```

#### 2. Conflitos de Recursos
```robot
*** Settings ***
Library    pabot.PabotLib

*** Keywords ***
Safe Database Operation
    # Usar locks para operações críticas
    Acquire Lock    database_operations
    
    TRY
        # Operação no banco
        Execute Database Operation
    FINALLY
        Release Lock    database_operations
    END
```

#### 3. Problemas de Memória
```bash
# Reduzir processos em ambientes com pouca memória
pabot --processes 2 tests/

# Monitorar uso de memória
pabot --verbose tests/ 2>&1 | grep -i memory
```

#### 4. Falhas de Comunicação entre Processos
```robot
*** Settings ***
Library    pabot.PabotLib    host=127.0.0.1    port=8270

*** Keywords ***
Robust Resource Acquisition
    # Retry em caso de falha de comunicação
    FOR    ${i}    IN RANGE    3
        TRY
            ${value}=    Acquire Value Set    shared_resource    key1
            BREAK
        EXCEPT
            Log    Tentativa ${i+1} falhou, tentando novamente...
            Sleep    1s
        END
    END
    [Return]    ${value}
```

### Debug e Análise

#### Verificar Distribuição de Testes
```bash
# Executar com verbose para ver distribuição
pabot --verbose --testlevelsplit tests/ 2>&1 | grep "ASSIGNED"
```

#### Análise de Logs por Processo
```bash
# Cada processo gera logs separados
ls -la results/
# Output: log-1.html, log-2.html, log-3.html, etc.
```

## Casos de Uso Específicos

### 1. Ambiente com 500+ Testes
```bash
# Configuração otimizada para grandes volumes
pabot --testlevelsplit \
      --processes 16 \
      --chunk \
      --processtimeout 900 \
      --artifacts xml,log \
      --outputdir results \
      tests/
```

### 2. Testes Cross-Browser Paralelos
```bash
# Executar diferentes browsers em paralelo
pabot --argumentfile1 chrome.args \
      --argumentfile2 firefox.args \
      --argumentfile3 edge.args \
      tests/ui/
```

```txt
# chrome.args
--variable BROWSER:Chrome
--variable SELENIUM_HUB:http://selenium-hub:4444/wd/hub

# firefox.args  
--variable BROWSER:Firefox
--variable SELENIUM_HUB:http://selenium-hub:4444/wd/hub

# edge.args
--variable BROWSER:Edge
--variable SELENIUM_HUB:http://selenium-hub:4444/wd/hub
```

### 3. Testes de API com Rate Limiting
```robot
*** Settings ***
Library    pabot.PabotLib
Library    Collections

*** Keywords ***
API Call With Rate Limiting
    [Arguments]    ${endpoint}    ${method}=GET    ${data}=${None}
    
    # Adquirir slot de rate limiting
    Acquire Lock    api_rate_limit
    
    TRY
        # Fazer chamada API
        ${response}=    Run Keyword    ${method} Request    ${endpoint}    ${data}
        
        # Aguardar para respeitar rate limit
        Sleep    0.2s
        
    FINALLY
        Release Lock    api_rate_limit
    END
    
    [Return]    ${response}
```

### 4. Integração com Ferramentas de Monitoramento
```python
# pabot_monitor.py - Script para monitorar execução Pabot
import time
import psutil
import json
from datetime import datetime

class PabotMonitor:
    def __init__(self):
        self.start_time = datetime.now()
        self.metrics = []
    
    def monitor_execution(self, duration=300):
        """Monitora execução por duração especificada (segundos)"""
        end_time = time.time() + duration
        
        while time.time() < end_time:
            # Coletar métricas do sistema
            cpu_percent = psutil.cpu_percent(interval=1)
            memory = psutil.virtual_memory()
            
            # Contar processos pabot
            pabot_processes = len([p for p in psutil.process_iter(['name']) 
                                 if 'pabot' in p.info['name']])
            
            metric = {
                'timestamp': datetime.now().isoformat(),
                'cpu_percent': cpu_percent,
                'memory_percent': memory.percent,
                'memory_available_gb': memory.available / (1024**3),
                'pabot_processes': pabot_processes
            }
            
            self.metrics.append(metric)
            
            # Log crítico se recursos estão altos
            if cpu_percent > 90 or memory.percent > 90:
                print(f"ALERTA: Recursos altos - CPU: {cpu_percent}%, RAM: {memory.percent}%")
            
            time.sleep(5)
    
    def save_metrics(self, filename='pabot_metrics.json'):
        """Salvar métricas em arquivo JSON"""
        with open(filename, 'w') as f:
            json.dump(self.metrics, f, indent=2)
        
        print(f"Métricas salvas em {filename}")

if __name__ == "__main__":
    monitor = PabotMonitor()
    monitor.monitor_execution(duration=600)  # 10 minutos
    monitor.save_metrics()
```

## Conclusão

O Pabot é uma ferramenta essencial para otimização de performance em projetos Robot Framework de grande escala. Com configurações adequadas e seguindo as melhores práticas documentadas, é possível alcançar reduções significativas no tempo de execução de testes, especialmente em ambientes CI/CD com centenas ou milhares de casos de teste.

**Principais benefícios:**
- Redução drástica no tempo de execução de testes
- Melhor utilização de recursos do sistema
- Integração nativa com pipelines CI/CD
- Flexibilidade na estratégia de paralelização
- Suporte robusto para ambientes distribuídos

**Recomendações gerais:**
- Começar com paralelização por suite, evoluir para test-level se necessário
- Monitorar recursos do sistema para otimizar número de processos
- Implementar locks para recursos compartilhados críticos
- Usar sharding em ambientes CI/CD distribuídos
- Manter independência entre testes para máximo paralelismo
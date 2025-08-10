# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Robot Framework test automation project focused on implementing Design Patterns for large-scale functional testing. The project demonstrates best practices for CI/CD environments with hundreds of functional tests across different platforms.

## Development Guidelines

- Always add explanatory comments for complex or non-trivial code sections
- Never delete existing comments unless they are irrelevant or incorrect
- When debugging, add comments indicating debug-only code and remove unnecessary files/comments when finished
- Include filename and line number in log messages
- Execute strictly what is requested; ask permission for additional changes
- Keep `CLAUDE.md` updated with code changes and project updates
- Sempre coloque o nome do arquivo e o número da linha na mensagem de log.

## Architecture & Design Patterns

The project implements several key design patterns:

- **Library-keyword Patterns / Object Service**: Abstraction layer for business logic reuse in API Tests
- **Factory Pattern**: Data generation and management for tests in general
- **Strategy Pattern**: Different testing strategies implementation
- **Page Object Model (POM)**: Classic pattern for use in WEB UI.
- **Facade Pattern**: Interface group tests simplification

## Project Structure

```
Design Patterns ROBOT/
├── README.md                     # Informações do repositório para humanos
├── .gitignore
├── CLAUDE.md                     # Arquivo de instruções do Claude                    
├── Documentation/
│   ├── Examples/Kickoff/         # Exemplos para referência humana (ignorar)
│   ├── Patterns/                 # Documentação dos Design Patterns
│   └── Use_Cases/                # Casos de uso DummyJSON
│   └── libs/                     # Documentação atualizada das libs usadas no projeto (foco atual)
├── tests/
│   ├── api/                      # Testes de APIs organizados por serviço
│   │   ├── products/             # Testes da API de produtos
│   │   ├── carts/                # Testes da API de carrinho
│   │   ├── users/                # Testes da API de usuários
│   │   └── auth/                 # Testes de autenticação
│   ├── ui/                       # Testes de interface web
│   │   ├── login/                # Testes de login web
│   │   ├── navigation/           # Testes de navegação
│   │   └── forms/                # Testes de formulários
│   └── integration/              # Testes end-to-end (opcional)
├── resources/
│   ├── apis/                     # Service Objects para APIs (Library-Keyword Pattern)
│   │   ├── products_service.resource
│   │   ├── users_service.resource
│   │   └── auth_service.resource
│   ├── pages/                    # Page Objects para UI (POM Pattern)
│   │   ├── login_page.resource
│   │   └── home_page.resource
│   ├── keywords/                 # Keywords genéricas e comuns
│   │   └── common_keywords.resource
│   ├── facades/                  # Keywords de alto nível (Facade Pattern)
│   │   └── business_workflows.resource
│   └── data/                     # Dados de teste não sensíveis
├── libraries/                    # Bibliotecas Python customizadas
│   ├── data_factory.py           # Factory Pattern para geração de dados
│   ├── config_strategy.py        # Strategy Pattern para configurações
│   └── service_objects/          # Service Objects em Python
├── data/
│   ├── testdata/                 # Massa de dados para testes
│   ├── Full_API_Data/            # Massa completa das apis para montagem dos testes
│   └── fixtures/                 # Dados de setup/teardown
├── results/                      # Resultados dos testes (logs, reports)
└── .claude/                      # Instruções de utilização do Claude Code
└── .github/
    └── workflows/                # Configurações CI/CD
    └── instructions/             # Instruções para utilização do Projeto para o copilot (ignorar)
    └── copilot-instructions.md   # Instruções para utilização pessoal do copilot (ignorar)
```

## Commands

### Running Tests - Authentication API Suite (Implementado)

**Método Recomendado - Scripts de Execução:**
```bash
# Modo interativo - seleciona opção do menu
python run_auth_tests.py

# Execução direta
python run_auth_tests.py 1    # Todos os testes de autenticação
python run_auth_tests.py 2    # Somente testes de login
python run_auth_tests.py 6    # Somente smoke tests
python run_auth_tests.py 7    # Somente testes de erro
```

**Scripts Alternativos:**
```cmd
# Windows Batch
run_auth_tests.bat 1

# PowerShell  
.\run_auth_tests.ps1 1
```

**Execução Direta Robot Framework:**
```bash
# Todos os testes de autenticação
python -m robot --outputdir results/api/auth_api/$(date +%Y%m%d_%H%M%S) tests/api/auth/

# Testes específicos por tags
python -m robot --outputdir results/api/auth_api/$(date +%Y%m%d_%H%M%S) --include smoke tests/api/auth/
```

### Running Tests - Users API Suite (Implementado)

**Método Recomendado - Scripts de Execução:**
```bash
# Modo interativo - seleciona opção do menu
python run_users_tests.py

# Execução direta
python run_users_tests.py 1     # Todos os testes de usuários
python run_users_tests.py 2     # Somente testes de login
python run_users_tests.py 3     # Somente testes de get all users
python run_users_tests.py 4     # Somente testes de get by ID
python run_users_tests.py 5     # Somente testes de search
python run_users_tests.py 6     # Somente testes de add user
python run_users_tests.py 7     # Somente testes de update user
python run_users_tests.py 8     # Somente testes de delete user
python run_users_tests.py 9     # Somente smoke tests
python run_users_tests.py 12    # Somente testes simulados (CRUD)
```

**Scripts Alternativos:**
```cmd
# Windows Batch
run_users_tests.bat 1

# PowerShell  
.\run_users_tests.ps1 9
```

**Execução Direta Robot Framework:**
```bash
# Todos os testes de usuários
python -m robot --outputdir results/api/users_api/$(date +%Y%m%d_%H%M%S) tests/api/users/

# Testes específicos por tags
python -m robot --outputdir results/api/users_api/$(date +%Y%m%d_%H%M%S) --include smoke tests/api/users/
python -m robot --outputdir results/api/users_api/$(date +%Y%m%d_%H%M%S) --include simulated tests/api/users/
```

### Running Tests - Products API Suite (Implementado)

**Método Recomendado - Scripts de Execução:**
```bash
# Modo interativo - seleciona opção do menu
python run_products_tests.py

# Execução direta
python run_products_tests.py 1     # Todos os testes de produtos
python run_products_tests.py 2     # Somente testes de get all products
python run_products_tests.py 3     # Somente testes de get by ID
python run_products_tests.py 4     # Somente testes de search
python run_products_tests.py 5     # Somente testes de categorias
python run_products_tests.py 6     # Somente testes de products by category
python run_products_tests.py 7     # Somente testes de add product
python run_products_tests.py 8     # Somente testes de update product
python run_products_tests.py 9     # Somente testes de delete product
python run_products_tests.py 10    # Somente smoke tests
python run_products_tests.py 13    # Somente testes simulados (CRUD)
```

**Scripts Alternativos:**
```cmd
# Windows Batch
run_products_tests.bat 1

# PowerShell  
.\run_products_tests.ps1 10
```

**Execução Direta Robot Framework:**
```bash
# Todos os testes de produtos
python -m robot --outputdir results/api/products_api/$(date +%Y%m%d_%H%M%S) tests/api/products/

# Testes específicos por tags
python -m robot --outputdir results/api/products_api/$(date +%Y%m%d_%H%M%S) --include smoke tests/api/products/
python -m robot --outputdir results/api/products_api/$(date +%Y%m%d_%H%M%S) --include simulated tests/api/products/
```

### Dependencies
Core dependencies are defined in `requirements.txt` (root):
- Robot Framework 7.0+
- RequestsLibrary 0.9.7+
- JSONLibrary 0.5.0+
- Pabot 2.17.0+ (parallel execution)

### Results Organization
Resultados organizados automaticamente em:
- `results/api/auth_api/[YYYYMMDD_HHMMSS]/`
- `results/api/users_api/[YYYYMMDD_HHMMSS]/`
- `results/api/products_api/[YYYYMMDD_HHMMSS]/`
- Cada execução cria pasta única com timestamp
- Relatórios: log.html, report.html, output.xml

## Test Development

### Robot testing for API (Implementado - Authentication)

**Suite de Autenticação Completa:**
- **UC-AUTH-001**: Login de usuário (8 casos de teste)
- **UC-AUTH-002**: Informações do usuário autenticado (4 casos de teste)
- **UC-AUTH-003**: Refresh de tokens (4 casos de teste)
- **Testes de Integração**: Workflows end-to-end (4 casos de teste)

**Design Patterns Aplicados:**
- **Library-Keyword Pattern**: `resources/apis/auth_service.resource`
- **Data Organization**: `data/testdata/auth_api/*.json`
- **Facade Pattern**: Keywords de alto nível para workflows completos
- **Factory Pattern**: Dados estruturados para diferentes cenários

### Robot testing for API (Implementado - Products)

**Suite de Products Completa:**
- **UC-PROD-001**: Lista de produtos com paginação (15+ casos de teste)
- **UC-PROD-002**: Produto por ID com validações (18+ casos de teste)
- **UC-PROD-003**: Busca de produtos com filtros (22+ casos de teste)
- **UC-PROD-004**: Categorias de produtos (15+ casos de teste)
- **UC-PROD-005**: Produtos por categoria (20+ casos de teste)
- **UC-PROD-006**: Adição de produtos simulada (18+ casos de teste)
- **UC-PROD-007**: Atualização de produtos simulada (25+ casos de teste)
- **UC-PROD-008**: Exclusão de produtos simulada (22+ casos de teste)

**Design Patterns Aplicados:**
- **Library-Keyword Pattern**: `resources/apis/products_service.resource`
- **Data Organization**: `data/testdata/products_api/*.json`
- **Facade Pattern**: Keywords de alto nível para workflows CRUD
- **Factory Pattern**: Dados estruturados para todos os cenários

### Robot testing for web ui
(- Use BDD-style keywords (Dado/Given, Quando/When, Então/Then) for Portuguese test cases
(em construção)
- Follow the established project structure pattern for consistency)

# Instruções gerais de codificação do projeto Design Patterns Robot

- O projeto utiliza Robot Framework para automação de testes em centenas de cenários, APIs e Interfaces em diferentes plataformas e ambientes.
- O contexto do projeto envolve CI/CD e testes funcionais (robot), portanto, o código deve ser robusto e eficiente.
- O ambiente possuirá conexão com o banco de dados para validação e geração de massa de dados atemporal. No momento iremos manter a massa de dados diretamente nos arquivos. Para depois transportarmos para um .csv e depois um sqlite.
- O principio DRY (Don't Repeat Yourself) deve ser aplicado para evitar duplicação de código em todo o projeto.
- O foco principal é a aplicação de Padrões de Projeto (Design Patterns) em testes automatizados:
    - Library-keyword Patterns / Object Service, para abstrair a lógica de negócios e facilitar a reutilização de código em APIs.
    - Factory Pattern, para gerenciar a criação de massa de dados.
    - Strategy Pattern, para definir diferentes estratégias de teste.
    - Page Object Model, para organizar o código relacionado a navegação em páginas HTML.
    - Facade Pattern, para simplificar um grupo de interfaces.
- Manter uma estrutura clara, separando Casos de Teste, Palavras-chave (Keywords), Recursos e Variáveis.
- As palavras-chave devem ser reutilizáveis e modulares.

## Pontos de Referência (Baselines)
- **v0.1.0-baseline** / **baseline/auth-implementation-ready**: Estado completo da documentação e estrutura base
  - Documentação completa dos Design Patterns em Documentation/Patterns/
  - Estrutura de pastas definida conforme Documentation/Infra_de_pastas.md
  - Libraries documentadas em Documentation/libs/
  - Casos de uso definidos em Documentation/Use_Cases/
  - Massa da aplicação baixada em data/Full_API_Data/*
  - CLAUDE.md atualizado com próximo prompt para implementação
  - Preparado para implementação dos testes de autenticação
  - **Como retornar**: `git checkout v0.1.0-baseline` ou `git checkout baseline/auth-implementation-ready`

## Backlog de atividades
Aqui são descritas as condições atuais do projeto e objetivos de longo prazo:

- Implementar os casos de testes desenvolvidos na pasta Documentation/Use_Cases utilizando os dados da aplicação que estão completamente baixados na pasta data/Full_API_Data/*. Respeitando a infra de pastas, a massa de dados deverá inicialmente ser implementados na pasta data/testdata/* e utilizando jsons. Somente mais tarde iremos implementar um modelo que irá consultar um banco sqlite. A seguir os testes a serem implementados:
    - ✅ **Teste completo do caso de uso Auth_Use_Cases.md incluindo possíveis fluxos alternativos e de erro** (IMPLEMENTADO)
    - ✅ **Teste completo do caso de uso Users_Use_Cases.md incluindo possíveis fluxos alternativos e de erro** (IMPLEMENTADO)
    - ✅ **Teste completo do caso de uso Products_Use_Cases.md incluindo possíveis fluxos alternativos e de erro** (IMPLEMENTADO)
    - Teste completo do caso de uso Carts_Use_Cases.md incluindo possíveis fluxos alternativos e de erro.

## Foco atual
- **PRÓXIMA IMPLEMENTAÇÃO**: Implementar os casos de testes completos do arquivo Documentation/Use_Cases/Carts_Use_Cases.md seguindo o mesmo padrão estabelecido na implementação de Auth, Users e Products:
  - Dados organizados em data/testdata/carts_api/
  - Service Objects em resources/apis/carts_service.resource
  - Suite executável em tests/api/carts/
  - Scripts de execução com saída dinâmica em results/api/carts_api/[timestamp]
- **PADRÃO CONSOLIDADO**: Aplicar o template estabelecido baseado nas três implementações completas (Auth, Users, Products)
- **CONSISTÊNCIA GARANTIDA**: Manter os mesmos Design Patterns e estrutura em todas as APIs



## Atividades finalizadas

### Fase de Documentação e Planejamento (Concluída)
- ✅ Documentação atualizada sobre as libraries em Documentation/libs para que a IA use sempre as melhores práticas mais atuais. As libs utilizadas estão descritas em "Documentation/libs/All_library_resume.md". A documentação das seguintes libs já foi produzida:
    - browserlibrary.md (Robot Framework Browser Library powered by Playwright)
    - robotframework.md (Robot Framework 7.0+ core documentation)
    - requestslibrary.md (RequestsLibrary for HTTP/REST API testing)
    - robotframework-faker.md (Faker library for test data generation with Brazilian localization)
    - jsonlibrary.md
    - pabot.md
    - databaselibrary.md
- ✅ Casos de uso da aplicação desenvolvidos na pasta Documentation/Use_Cases/*
- ✅ Definidos os patterns a serem usados na aplicação na pasta Documentation/Patterns/
- ✅ Estrutura de pastas do projeto desenvolvido a partir do documento Documentation/Infra_de_pastas.md

### Fase de Implementação - Authentication API (Concluída)
- ✅ **Suite Completa de Autenticação DummyJSON API**:
  - **Dados de Teste Organizados**: `data/testdata/auth_api/`
    - `valid_users.json` - Credenciais válidas estruturadas
    - `invalid_credentials.json` - Cenários de erro organizados
    - `auth_endpoints.json` - Configuração centralizada de endpoints
  
  - **Service Objects (Library-Keyword Pattern)**: `resources/apis/auth_service.resource`
    - Keywords de operações API (login, user info, token refresh)
    - Keywords de validação de resposta
    - Gerenciamento de tokens e utilidades
    - Tratamento completo de erros
  
  - **Suite de Testes Completa**: `tests/api/auth/`
    - `auth_login_tests.robot` - UC-AUTH-001 (8 casos de teste)
    - `auth_user_info_tests.robot` - UC-AUTH-002 (4 casos de teste)
    - `auth_refresh_token_tests.robot` - UC-AUTH-003 (4 casos de teste)  
    - `auth_integration_tests.robot` - Workflows end-to-end (4 casos de teste)
    - `auth_test_suite.robot` - Suite principal e validações
    - `README.md` - Documentação completa de execução
  
  - **Scripts de Execução**: Sistema de execução automatizada
    - `run_auth_tests.py` - Script Python cross-platform com 10 modos de execução
    - `run_auth_tests.bat` - Script Windows Batch
    - `run_auth_tests.ps1` - Script PowerShell avançado
  
  - **Organização de Resultados**: Sistema de saída dinâmica
    - Resultados salvos em `results/api/auth_api/[YYYYMMDD_HHMMSS]/`
    - Nunca sobrescreve execuções anteriores
    - Relatórios completos: log.html, report.html, output.xml
  
  - **Dependências e Configuração**:
    - `requirements.txt` - Dependências Python atualizadas
    - `EXECUTION_GUIDE.md` - Guia completo de execução
  
  - **Validação Completa**:
    - ✅ Testes de sintaxe (dry-run) aprovados
    - ✅ Testes de conectividade API aprovados  
    - ✅ Execução real com dados válidos aprovados
    - ✅ Sistema de resultados dinâmicos funcionando
    - ✅ Todos os design patterns aplicados corretamente

### Cobertura de Testes Implementada - Authentication API
- **20+ casos de teste** cobrindo todos os cenários definidos em Auth_Use_Cases.md
- **Cenários de Sucesso**: Login válido, obtenção de user info, refresh de tokens
- **Cenários de Erro**: Credenciais inválidas, tokens expirados, campos vazios
- **Testes de Integração**: Workflows completos end-to-end
- **Testes de Segurança**: Validação de tokens, replay attacks

### Fase de Implementação - Users API (Concluída)
- ✅ **Suite Completa de Users DummyJSON API**:
  - **Dados de Teste Organizados**: `data/testdata/users_api/`
    - `valid_users.json` - Dados de usuários válidos estruturados
    - `invalid_users.json` - Cenários de erro organizados por categoria
    - `users_endpoints.json` - Configuração centralizada de endpoints
  
  - **Service Objects (Library-Keyword Pattern)**: `resources/apis/users_service.resource`
    - Keywords de operações API (login, CRUD completo, search)
    - Keywords de validação de resposta
    - Gerenciamento completo de sessões e utilidades
    - Tratamento robusto de erros e edge cases
  
  - **Suite de Testes Completa**: `tests/api/users/`
    - `users_login_tests.robot` - UC-USER-001 (8 casos de teste)
    - `users_get_all_tests.robot` - UC-USER-002 (13 casos de teste)
    - `users_get_by_id_tests.robot` - UC-USER-003 (15 casos de teste)
    - `users_search_tests.robot` - UC-USER-004 (18 casos de teste)
    - `users_add_tests.robot` - UC-USER-005 (16 casos de teste)
    - `users_update_tests.robot` - UC-USER-006 (18 casos de teste)
    - `users_delete_tests.robot` - UC-USER-007 (19 casos de teste)
    - `users_test_suite.robot` - Suite principal e validações
    - `README.md` - Documentação completa de execução
  
  - **Scripts de Execução**: Sistema de execução automatizada
    - `run_users_tests.py` - Script Python cross-platform com 20 modos de execução
    - `run_users_tests.bat` - Script Windows Batch
    - `run_users_tests.ps1` - Script PowerShell avançado
  
  - **Organização de Resultados**: Sistema de saída dinâmica
    - Resultados salvos em `results/api/users_api/[YYYYMMDD_HHMMSS]/`
    - Nunca sobrescreve execuções anteriores
    - Relatórios completos: log.html, report.html, output.xml
  
  - **Validação Completa**:
    - ✅ Testes de sintaxe (dry-run) aprovados
    - ✅ Testes de conectividade API aprovados  
    - ✅ Execução real com dados válidos aprovados
    - ✅ Sistema de resultados dinâmicos funcionando
    - ✅ Todos os design patterns aplicados corretamente

### Cobertura de Testes Implementada - Users API
- **107+ casos de teste** cobrindo todos os cenários definidos em Users_Use_Cases.md
- **Cenários de Sucesso**: CRUD completo, pesquisa, paginação, ordenação
- **Cenários de Erro**: IDs inválidos, dados mal formatados, recursos não encontrados
- **Testes de Edge Cases**: Valores extremos, caracteres especiais, dados duplicados
- **Testes de Performance**: Tempo de resposta, operações em lote
- **Validação Completa**: Estrutura de resposta, tipos de dados, integridade

### Fase de Implementação - Products API (Concluída)
- ✅ **Suite Completa de Products DummyJSON API**:
  - **Dados de Teste Organizados**: `data/testdata/products_api/`
    - `valid_products.json` - Dados de produtos válidos estruturados
    - `invalid_products.json` - Cenários de erro organizados por categoria
    - `products_endpoints.json` - Configuração centralizada de endpoints
  
  - **Service Objects (Library-Keyword Pattern)**: `resources/apis/products_service.resource`
    - Keywords de operações API (CRUD completo, search, categorias)
    - Keywords de validação de resposta
    - Gerenciamento completo de sessões e utilidades
    - Tratamento robusto de erros e edge cases
  
  - **Suite de Testes Completa**: `tests/api/products/`
    - `products_get_all_tests.robot` - UC-PROD-001 (15+ casos de teste)
    - `products_get_by_id_tests.robot` - UC-PROD-002 (18+ casos de teste)
    - `products_search_tests.robot` - UC-PROD-003 (22+ casos de teste)
    - `products_categories_tests.robot` - UC-PROD-004 (15+ casos de teste)
    - `products_by_category_tests.robot` - UC-PROD-005 (20+ casos de teste)
    - `products_add_tests.robot` - UC-PROD-006 (18+ casos de teste)
    - `products_update_tests.robot` - UC-PROD-007 (25+ casos de teste)
    - `products_delete_tests.robot` - UC-PROD-008 (22+ casos de teste)
    - `products_test_suite.robot` - Suite principal e validações
    - `README.md` - Documentação completa de execução
  
  - **Scripts de Execução**: Sistema de execução automatizada
    - `run_products_tests.py` - Script Python cross-platform com 20 modos de execução
    - `run_products_tests.bat` - Script Windows Batch
    - `run_products_tests.ps1` - Script PowerShell avançado
  
  - **Organização de Resultados**: Sistema de saída dinâmica
    - Resultados salvos em `results/api/products_api/[YYYYMMDD_HHMMSS]/`
    - Nunca sobrescreve execuções anteriores
    - Relatórios completos: log.html, report.html, output.xml
  
  - **Validação Completa**:
    - ✅ Testes de sintaxe (dry-run) aprovados
    - ✅ Testes de conectividade API aprovados  
    - ✅ Execução real com dados válidos aprovados
    - ✅ Sistema de resultados dinâmicos funcionando
    - ✅ Todos os design patterns aplicados corretamente

### Cobertura de Testes Implementada - Products API
- **155+ casos de teste** cobrindo todos os cenários definidos em Products_Use_Cases.md
- **Cenários de Sucesso**: CRUD completo, pesquisa, categorias, paginação, ordenação
- **Cenários de Erro**: IDs inválidos, dados mal formatados, recursos não encontrados
- **Testes de Edge Cases**: Valores extremos, caracteres especiais, dados duplicados
- **Testes de Performance**: Tempo de resposta, operações em lote
- **Testes de Segurança**: SQL injection, XSS, validação de entrada
- **Validação Completa**: Estrutura de resposta, tipos de dados, integridade

## Template/Padrão Consolidado para Implementações

Com base na implementação completa das suites de Authentication, Users e Products, foi estabelecido e consolidado o seguinte template que deve ser seguido para as demais APIs (Carts):

### Estrutura de Pastas Padrão:
```
data/testdata/[api_name]_api/        # Dados de teste organizados
├── valid_[entity].json              # Dados válidos estruturados
├── invalid_[entity].json            # Cenários de erro
└── [api_name]_endpoints.json        # Configuração de endpoints

resources/apis/                      # Service Objects
└── [api_name]_service.resource      # Library-Keyword Pattern

tests/api/[api_name]/               # Suite de testes
├── [api_name]_[operation]_tests.robot  # Testes por operação
├── [api_name]_integration_tests.robot  # Testes de integração
├── [api_name]_test_suite.robot         # Suite principal
└── README.md                           # Documentação de execução

results/api/[api_name]_api/[timestamp]/ # Resultados organizados
```

### Scripts de Execução Padrão:
- Script Python cross-platform com múltiplos modos (10-20 opções)
- Scripts Windows (batch e PowerShell)
- Saída dinâmica com timestamp
- Modos padrão: todos, por operação, por tag, smoke, error, validation, performance

### Design Patterns Obrigatórios:
- **Library-Keyword Pattern**: Service Objects com keywords reutilizáveis
- **Factory Pattern**: Dados estruturados e organizados
- **Facade Pattern**: Keywords de alto nível para workflows
- **DRY Principle**: Máxima reutilização, zero duplicação

### Validação Obrigatória:
- Testes de sintaxe (dry-run)
- Testes de conectividade
- Execução real com validação
- Sistema de resultados funcionando

Este template garante consistência e qualidade em todas as implementações futuras.

## Status Atual do Projeto

### 🏆 **Implementações Concluídas**
- ✅ **Authentication API** - 20+ casos de teste
- ✅ **Users API** - 107+ casos de teste  
- ✅ **Products API** - 155+ casos de teste

**Cobertura Total Atual**: **282+ casos de teste** em 3 APIs completas

### 🛠️ **Próximas Implementações**
- 🔄 **Carts API** - Próxima na fila (estimativa: 100+ casos de teste)

### 🎯 **Meta Final do Projeto**
- **Cobertura Estimada**: 400+ casos de teste em 4 APIs principais
- **Padrões Consolidados**: Library-Keyword, Factory, Strategy, Facade
- **Execução Unificada**: Scripts cross-platform para todas as APIs
- **Organização Consistente**: Resultados dinâmicos timestamp-based

## Objetivo final
- Criar um repositório de testes automatizados com diversos casos de testes funcionais, aplicando os princípios de Padrões de Projeto (Design Patterns) e boas práticas de codificação.
- Garantir que o código seja reutilizável, modular e fácil de manter.
- O projeto visará ser uma referência para a aplicação de Padrões de Projeto em testes automatizados, especialmente no contexto de CI/CD e testes funcionais com Robot Framework pensando na situação em que temos centenas de cenários, APIs e Interfaces em diferentes plataformas e ambientes em um mesmo repositório.

This is a reference implementation for applying Design Patterns in Robot Framework test automation.
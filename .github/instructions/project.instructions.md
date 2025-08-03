---
applyTo: "**"
---

## Project Overview

This is a Robot Framework test automation project focused on implementing Design Patterns for large-scale functional testing. The project demonstrates best practices for CI/CD environments with hundreds of functional tests across different platforms.

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

### Running Tests
```bash
```
(em construção)

### Dependencies
Exemple Core dependencies are defined in `Documentation/Examples/Kickoff/Modelo Estrutura/requirements.txt`:
- Robot Framework 7.0+
- SeleniumLibrary 6.7.0+
- RequestsLibrary 0.9.7+
- JSONLibrary 0.5.0+
- Pabot 2.17.0+ (parallel execution)

## Test Development

### Robot testing for API
(em construção)


### Robot testing for web ui
(- Use BDD-style keywords (Dado/Given, Quando/When, Então/Then) for Portuguese test cases
(em construção)
- Follow the established project structure pattern for consistency)

# Instruções gerais de codificação do projeto Design Patterns Robot

- O projeto utiliza Robot Framework para automação de testes em centenas de cenários, APIs e Interfaces em diferentes plataformas e ambientes.
- O contexto do projeto envolve CI/CD e testes funcionais (robot), portanto, o código deve ser robusto e eficiente.
- O ambiente possuirá conexão com o banco de dados para validação e geração de massa de dados atemporal.
- O principio DRY (Don't Repeat Yourself) deve ser aplicado para evitar duplicação de código em todo o projeto.
- O foco principal é a aplicação de Padrões de Projeto (Design Patterns) em testes automatizados:
    - Library-keyword Patterns / Object Service, para abstrair a lógica de negócios e facilitar a reutilização de código em APIs.
    - Factory Pattern, para gerenciar a criação de massa de dados.
    - Strategy Pattern, para definir diferentes estratégias de teste.
    - Page Object Model, para organizar o código relacionado a navegação em páginas HTML.
    - Facade Pattern, para simplificar um grupo de interfaces.
- Manter uma estrutura clara, separando Casos de Teste, Palavras-chave (Keywords), Recursos e Variáveis.
- As palavras-chave devem ser reutilizáveis e modulares.

## Backlog de atividades
Aqui são descritas as condições atuais do projeto e objetivos de longo prazo:

- Implementar os casos de testes desenvolvidos na pasta Documentation/Use_Cases utilizando os dados da aplicação que estão completamente baixados na pasta data/Full_API_Data/*

## Foco atual
- Desenvolver documentação atualizada sobre as libraries em Documentation/libs para que a IA use sempre as melhores praticas mais atuais. As libs utilizadas estão descritas em "Documentation/libs/All_library_resume.md". A documentação das seguintes libs já foi produzida:
    - browserlibrary.md
    - requestslibrary.md
    - robotframework.md
    - seleniumlibrary.md

## Atividades finalizas
- Casos de uso da aplicação desenvolvidos na pasta Documentation/Use_Cases/*
- Definidos os patterns a serem usados na aplicação na pasta Documentation/Patterns/
- Estrutura de pastas do projeto desenvolvido a partir do documento Documentation/Infra_de_pastas.md 

## Objetivo final
- Criar um repositório de testes automatizados com diversos casos de testes funcionais, aplicando os princípios de Padrões de Projeto (Design Patterns) e boas práticas de codificação.
- Garantir que o código seja reutilizável, modular e fácil de manter.
- O projeto visará ser uma referência para a aplicação de Padrões de Projeto em testes automatizados, especialmente no contexto de CI/CD e testes funcionais com Robot Framework pensando na situação em que temos centenas de cenários, APIs e Interfaces em diferentes plataformas e ambientes em um mesmo repositório.

This is a reference implementation for applying Design Patterns in Robot Framework test automation.
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Robot Framework test automation project focused on implementing Design Patterns for large-scale functional testing. The project demonstrates best practices for CI/CD environments with hundreds of functional tests across different platforms.

## Architecture & Design Patterns

The project implements several key design patterns:

- **Library-keyword Patterns / Object Service**: Abstraction layer for business logic reuse in API Tests
- **Factory Pattern**: Data generation and management for tests in general
- **Strategy Pattern**: Different testing strategies implementation
- **Page Object Model (POM)**: Classi pattern for use in WEB UI.
- **Facade Pattern**: Interface group tests simplification

## Project Structure

```
Documentation/
├── Examples/Kickoff/           # implementation examples for human use only, ignore this folder.
│   └── API/                   # API testing examples for human use only, ignore this folder.
└── Patterns/                   # Design pattern documentation (.md files)
(em construção)
```

## Key Architecture Concepts

### Robot testing for API
(em contrução)

### Robot testing for web ui
- **Elements**: Centralized locator management using .resource files
- **Steps**: Reusable test step implementations following BDD patterns
- **Tests**: Test case definitions that import and use Steps
- **Resource**: Shared configuration and utility files

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

## Development Guidelines

- Always add explanatory comments for complex or non-trivial code sections
- Never delete existing comments unless they are irrelevant or incorrect
- When debugging, add comments indicating debug-only code and remove unnecessary files/comments when finished
- Include filename and line number in log messages
- Execute strictly what is requested; ask permission for additional changes
- Keep `CLAUDE.md` updated with code changes and project updates

## Test Development

### Robot testing for API
(em construção)


### Robot testing for web ui
- Use BDD-style keywords (Dado/Given, Quando/When, Então/Then) for Portuguese test cases
- Organize test steps in separate .robot files under Steps/ directory
- Store page elements in .resource files under Elements/ directory
- Import necessary Steps and Elements in test files using Resource declarations
- Follow the established project structure pattern for consistency

# Instruções gerais de codificação do projeto Design Patterns Robot

- O projeto utiliza Robot Framework para automação de testes em centenas de cenários, APIs e Interfaces em diferentes plataformas e ambientes.
- O contexto do projeto envolve CI/CD e testes funcionais (robot), portanto, o código deve ser robusto e eficiente.
- O ambiente possui conexão com o banco de dados para validação e geração de massa de dados atemporal.
- O principio DRY (Don't Repeat Yourself) deve ser aplicado para evitar duplicação de código em todo o projeto.
- O foco principal é a aplicação de Padrões de Projeto (Design Patterns) em testes automatizados:
    - Library-keyword Patterns / Object Service, para abstrair a lógica de negócios e facilitar a reutilização de código em APIs.
    - Factory Pattern, para gerenciar a criação de massa de dados.
    - Strategy Pattern, para definir diferentes estratégias de teste.
    - Page Object Model, para organizar o código relacionado a navegação em páginas HTML.
    - Facade Pattern, para simplificar um grupo de interfaces.
- Manter uma estrutura clara, separando Casos de Teste, Palavras-chave (Keywords), Recursos e Variáveis.
- As palavras-chave devem ser reutilizáveis e modulares.

## Andamento do Projeto
Aqui são descritas as condições atuais do projeto e objetivos de longo prazo:

- O projeto está em andamento, ainda com definição de estrutura de pastas e organização de arquivos.
- A documentação está sendo atualizada conforme novas implementações e padrões são aplicados.

## Estrutura de Pastas
A estrutura de pastas do projeto é organizada da seguinte forma:

- Para paginas web: A definir.

- Para APIs: A definir.


## Foco atual
- Desevolver casos de uso de teste no portal https://dummyjson.com e escreve-los na pasta Documentation/Use_Cases/, usar os seguintes docs:
  - https://dummyjson.com/docs/products
  - https://dummyjson.com/docs/carts
  - https://dummyjson.com/docs/users
  - https://dummyjson.com/docs/auth




## Objetivo final
- Criar um repositório de testes automatizados com diversos casos de testes funcionais, aplicando os princípios de Padrões de Projeto (Design Patterns) e boas práticas de codificação.
- Garantir que o código seja reutilizável, modular e fácil de manter.
- O projeto visará ser uma referência para a aplicação de Padrões de Projeto em testes automatizados, especialmente no contexto de CI/CD e testes funcionais com Robot Framework pensando na situação em que temos centenas de cenários, APIs e Interfaces em diferentes plataformas e ambientes em um mesmo repositório.

This is a reference implementation for applying Design Patterns in Robot Framework test automation.
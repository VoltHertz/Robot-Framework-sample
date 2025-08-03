# Design Patterns Robot Framework

Projeto de automação de testes utilizando Robot Framework com aplicação de Design Patterns para testes funcionais em larga escala.

## 🎯 Objetivo

Criar um repositório de referência para testes automatizados aplicando Design Patterns e boas práticas de codificação, focado em cenários de CI/CD com centenas de testes funcionais em diferentes plataformas e ambientes.

## 🏗️ Design Patterns Implementados

- **Object Service**: Abstração da lógica de negócios para reutilização em APIs
- **Factory Pattern**: Gerenciamento da criação de massa de dados
- **Strategy Pattern**: Diferentes estratégias de teste
- **Page Object Model**: Organização de código para navegação em páginas HTML
- **Facade Pattern**: Simplificação de grupos de interfaces

## 📁 Estrutura do Projeto

```
Design Patterns ROBOT/
├── README.md                     # Informações do repositório para humanos
├── .gitignore
├── CLAUDE.md                     # Arquivo de instruções do Claude                    
├── Documentation/
│   ├── Examples/Kickoff/         # Exemplos para referência humana (ignorar)
│   ├── Patterns/                 # Documentação dos Design Patterns
│   └── Use_Cases/                # Casos de uso DummyJSON (foco atual)
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

## 🔧 Tecnologias

- **Robot Framework**: Framework principal para automação de testes
- **Python**: Linguagem de suporte
- **CI/CD**: Integração e entrega contínua
- **Banco de Dados**: Validação e geração de massa de dados (em construção)

## 🚀 Funcionalidades

- **Automação de testes em larga escala**: Suporte para centenas de cenários de teste
- **APIs e interfaces web**: Testes para múltiplas APIs e interfaces web
- **Design Patterns implementados**: Library-Keyword, Factory, Strategy, POM e Facade
- **Arquitetura em camadas**: Separação clara entre testes, negócio, serviços e dados
- **CI/CD integrado**: Configuração para GitHub Actions
- **Massa de dados dinâmica**: Geração de dados de teste usando Factory Pattern
- **Reutilização e modularidade**: Estrutura que promove DRY (Don't Repeat Yourself)

## 📋 Foco Atual

- Implementar os casos de testes desenvolvidos na pasta data/Full_API_Data/*

## 🏃‍♂️ Status do Projeto

✅ **Estrutura Definida** - Arquitetura em camadas implementada com Design Patterns

**Próximos Passos:**
- Implementação dos casos de uso DummyJSON
- Desenvolvimento das keywords e bibliotecas
- Configuração do CI/CD com GitHub Actions
- Implementar utilização de Banco de dados dinamico

### Branches de Desenvolvimento

- **main**: Branch principal com código base inicial do projeto.

- **feature/copilot-claude-sonnet-4.0-development**: Branch dedicado ao desenvolvimento com Copilot Claude Sonnet 4.0, IA de baixo custo para atividades de CI/CD, mas também para verificar nivel de qualidade que consegue atingir ao atuar com Boa documentação e MCP servers.
- **feature/claude-code-cli-development**: Branch para desenvolvimento com Claude Code CLI, IA lider de mercado no modelo Agent Coding(08/2025)
- **feature/zhipu-glm-4.5-development**: Branch para desenvolvimento com Zhipu GLM 4.5, IA chinesa, maior concorrente do Claude para Desenvolvimento em paralelo dos testes

## 📖 Documentação

A documentação é atualizada continuamente conforme novas implementações e padrões são aplicados. Consulte a pasta `Documentation/` para exemplos e guias detalhados.

---

*Este projeto visa ser uma referência para aplicação de Design Patterns em testes automatizados com Robot Framework.*
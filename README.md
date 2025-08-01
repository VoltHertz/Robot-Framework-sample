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
├── Documentation/
│   ├── Examples/        # Exemplos de implementação
│   │   └── Kickoff/     # Exemplos iniciais do projeto
│   └── Patterns/        # Documentação dos Design Patterns
└── .github/
    └── instructions/    # Instruções de desenvolvimento
```

## 🔧 Tecnologias

- **Robot Framework**: Framework principal para automação de testes
- **Python**: Linguagem de suporte
- **CI/CD**: Integração e entrega contínua
- **Banco de Dados**: Validação e geração de massa de dados

## 🚀 Funcionalidades

- Automação de testes para APIs e interfaces web
- Conexão com banco de dados para validação
- Geração de massa de dados atemporal
- Estrutura modular e reutilizável
- Aplicação do princípio DRY (Don't Repeat Yourself)

## 📋 Foco Atual

Desenvolvimento de casos de uso de teste utilizando a API [DummyJSON](https://dummyjson.com):

- Products: https://dummyjson.com/docs/products
- Carts: https://dummyjson.com/docs/carts
- Users: https://dummyjson.com/docs/users
- Auth: https://dummyjson.com/docs/auth

## 🏃‍♂️ Status do Projeto

⚠️ **Em Desenvolvimento** - Definição de estrutura de pastas e organização de arquivos em andamento.

### Branches de Desenvolvimento

- **main**: Branch principal com código estável
- **feature/copilot-claude-sonnet-4.0-development**: Branch dedicado ao desenvolvimento com Copilot Claude Sonnet 4.0 para implementação de casos de uso e Design Patterns
- **feature/claude-code-cli-development**: Branch para desenvolvimento com Claude Code CLI, focado em automação avançada e integração contínua
- **feature/zhipu-glm-4.5-development**: Branch para desenvolvimento com Zhipu GLM 4.5, focado em IA chinesa para análise de dados e testes inteligentes

## 📖 Documentação

A documentação é atualizada continuamente conforme novas implementações e padrões são aplicados. Consulte a pasta `Documentation/` para exemplos e guias detalhados.

---

*Este projeto visa ser uma referência para aplicação de Design Patterns em testes automatizados com Robot Framework.*
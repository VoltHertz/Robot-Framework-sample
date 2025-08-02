---
applyTo: "**"
---
# Instruções gerais de codificação do projeto Design Patterns Robot

- O projeto utiliza Robot Framework para automação de testes em centenas de cenários, APIs e Interfaces em diferentes plataformas e ambientes.
- O contexto do projeto envolve CI/CD e testes funcionais (robot), portanto, o código deve ser robusto e eficiente.
- O ambiente possui conexão com o banco de dados para validação e geração de massa de dados atemporal.
- O principio DRY (Don't Repeat Yourself) deve ser aplicado para evitar duplicação de código em todo o projeto.
- O foco principal é a aplicação de Padrões de Projeto (Design Patterns) em testes automatizados:
    - Object Service, para abstrair a lógica de negócios e facilitar a reutilização de código em APIs.
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

- Para paginas web:

- Para APIs:


## Foco atual
- Desevolver casos de uso de teste no portal https://dummyjson.com e escreve-los na pasta Documentation/Use_Cases/, usar os seguintes docs:
  - https://dummyjson.com/docs/products
  - https://dummyjson.com/docs/carts
  - https://dummyjson.com/docs/users
  - https://dummyjson.com/docs/auth

- Escrever os códigos baseado nos casos de uso gerados usando a seguinte infra estrutura:
  - Criar um arquivo de teste em Documentation/Use_Cases/Products.robot
  - Criar um arquivo de keywords em Documentation/Use_Cases/Products_Keywords.robot
  - Criar um arquivo de variables em Documentation/Use_Cases/Products_Variables.robot
  - Criar um arquivo de resources em Documentation/Use_Cases/Products_Resources.robot






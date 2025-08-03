# Robot Framework SeleniumLibrary

## Visão Geral

O Robot Framework SeleniumLibrary é uma biblioteca de testes web para o Robot Framework que utiliza o Selenium WebDriver por baixo dos panos. Ela fornece uma API robusta e de alto nível para automação de navegadores web, permitindo a interação com elementos HTML, simulação de ações do usuário e verificação de estados de páginas.

## Instalação

### Instalação da Última Versão
```bash
pip install --upgrade robotframework-seleniumlibrary
```

### Instalação de Versões Pré-lançamento
```bash
pip install --pre --upgrade robotframework-seleniumlibrary
```

### Instalação de Versões Específicas
```bash
pip install robotframework-seleniumlibrary==6.7.1
```

### Instalação de Dependências de Desenvolvimento
```bash
pip install -r requirements-dev.txt
```

## Configuração de Drivers

### Instalação e Link de Drivers usando WebdriverManager
```bash
pip install webdrivermanager
webdrivermanager firefox chrome --linkpath /usr/local/bin
```

## Estratégias de Localização de Elementos

A SeleniumLibrary suporta várias estratégias para localizar elementos na página:

### Estratégias Explícitas
```robotframework
Click Element | id:foo                      | # Elemento com id 'foo'
Click Element | css:div#foo h1              | # Elemento h1 sob div com id 'foo'
Click Element | xpath: //div[@id="foo"]//h1 | # Mesmo que acima usando XPath
Click Element | xpath: //*[contains(text(), "example")] | # Elemento contendo texto 'example'
```

### Estratégias Implícitas
```robotframework
Click Element | //div[@id="foo"]//h1 |  # XPath implícito (começa com //)
Click Element | (//div)[2]           |  # XPath implícito (começa com (//)
```

### Usando Prefixos Explícitos e Padrão
```robotframework
Click Element | name:foo         | # Encontra elemento com nome 'foo'
Click Element | default:name:foo | # Usa estratégia padrão com valor 'name:foo'
Click Element | //foo            | # Encontra elemento usando XPath '//foo'
Click Element | default: //foo   | # Usa estratégia padrão com valor '//foo'
```

### Usando Objetos WebElement como Localizadores
```robotframework
${elem} =       | Get WebElement | id:example
Click Element | ${elem}          |
```

## Exemplo de Teste Básico

```robotframework
*** Settings ***
    Documentation     Exemplo simples usando SeleniumLibrary.
    Library           SeleniumLibrary

*** Variables ***
    ${LOGIN URL}      http://localhost:7272
    ${BROWSER}        Chrome

*** Test Cases ***
Valid Login
    Open Browser To Login Page
    Input Username    demo
    Input Password    mode
    Submit Credentials
    Welcome Page Should Be Open
    [Teardown]    Close Browser

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Title Should Be    Login Page

Input Username
    [Arguments]    ${username}
    Input Text    username_field    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    password_field    ${password}

Submit Credentials
    Click Button    login_button

Welcome Page Should Be Open
    Title Should Be    Welcome Page
```

## Execução de Testes

### Executando Testes de Aceitação
```bash
python atest/run.py <browser>
```

### Exemplo: Executar com Chrome
```bash
run.py chrome
```

### Exemplo: Executar com Firefox e Suíte Específica
```bash
run.py --interpreter c:\Python38\python.exe firefox --suite javascript
```

### Exemplo: Executar em Modo Headless com Grid
```bash
run.py headlesschrome --nounit --grid true
```

### Executando Testes Unitários
```bash
python utest/run.py
```

## Configuração Avançada

### Importando Plugins
A SeleniumLibrary suporta plugins para estender sua funcionalidade:

```robotframework
| Library | SeleniumLibrary | plugins=${CURDIR}/MyPlugin.py   | # Importa plugin com caminho físico
| Library | SeleniumLibrary | plugins=plugins.MyPlugin, plugins.MyOtherPlugin | # Importa dois plugins com nome
| Library | SeleniumLibrary | plugins=plugins.Plugin;ArgOne;ArgTwo | # Importa plugin com argumentos
| Library | SeleniumLibrary | plugins=plugins.Plugin;argument1;varg1;varg2;kw1=kwarg1;kw2=kwarg2 |
```

### Definindo um Plugin em Python
```python
class Plugin(LibraryComponent):

    def __init__(self, ctx, arg, *varargs, **kwargs):
        # Código para implementar o plugin
```

### Exemplo de Plugin Completo
```python
class MyPlugin(LibraryComponent):

    def __init__(self, ctx):
        LibraryComponent.__init__(self, ctx)
        self.event_firing_webdriver  = WhatEverYouWant
```

### Argumentos de Serviço
```python
service_args=['--log-level=DEBUG']
```

## Funcionalidades Principais

### Gerenciamento de Navegadores
- Abrir e fechar navegadores
- Alternar entre janelas e frames
- Gerenciar cookies
- Executar em modo headless

### Interação com Elementos
- Clicar em elementos
- Preencher campos de texto
- Selecionar opções em dropdowns
- Arrastar e soltar elementos

### Validações
- Verificar títulos de página
- Validar textos e atributos
- Verificar visibilidade de elementos
- Aguardar condições específicas

### Captura de Informações
- Obter textos e atributos
- Capturar screenshots
- Extrair dados de tabelas

## Boas Práticas

### 1. Use Keywords de Alto Nível
Crie keywords personalizadas que encapsulem sequências de ações, tornando os testes mais legíveis e manuteníveis.

### 2. Estratégias de Localização Robustas
Prefira IDs e classes estáveis para localizar elementos, evitando seletores frágeis.

### 3. Esperas Explícitas
Use mecanismos de espera em vez de pausas fixas para lidar com carregamentos de página assíncronos.

### 4. Page Object Model
Organize seu código seguindo o padrão Page Object Model para melhor manutenção.

### 5. Configuração Adequada de Drivers
Mantenha os drivers dos navegadores atualizados e configurados corretamente.

## Integração com CI/CD

A SeleniumLibrary pode ser facilmente integrada em pipelines de CI/CD:

### Execução Headless
```bash
run.py headlesschrome
```

### Integração com Selenium Grid
```bash
run.py chrome --grid true
```

### Geração de Relatórios
A biblioteca gera relatórios e logs detalhados que podem ser integrados em pipelines de CI/CD.

## Extensibilidade

A SeleniumLibrary é altamente extensível através de:

1. **Plugins**: Adicione novas funcionalidades através de plugins Python
2. **Keywords Personalizadas**: Crie keywords específicas para seu domínio
3. **Listeners**: Implemente listeners para eventos de teste
4. **Locators Personalizados**: Adicione novas estratégias de localização

## Documentação Adicional

- [Documentação Oficial](https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)
- [Repositório GitHub](https://github.com/robotframework/SeleniumLibrary)
- [Exemplos de Testes](https://github.com/robotframework/SeleniumLibrary/tree/master/atest)

## Versões Compatíveis

- Robot Framework 3.0+
- Python 3.6+
- Selenium WebDriver 3.0+
- Navegadores modernos (Chrome, Firefox, Safari, Edge)

## Solução de Problemas Comuns

### 1. Problemas com Drivers
Certifique-se de que os drivers dos navegadores estão instalados e na versão correta.

### 2. Timeouts
Ajuste os timeouts de espera conforme necessário para seu ambiente.

### 3. Elementos Não Encontrados
Verifique se os elementos estão presentes no DOM e se os seletores estão corretos.

### 4. Problemas com Frames
Use as keywords específicas para trabalhar com frames e iframes.
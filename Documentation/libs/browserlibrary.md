# Robot Framework Browser Library

## Visão Geral

A Robot Framework Browser Library é uma biblioteca moderna de automação web para o Robot Framework, alimentada pelo Playwright. Ela oferece uma abordagem poderosa e eficiente para automação de navegadores, com suporte para múltiplos navegadores e recursos avançados de automação.

## Instalação

### Instalação Inicial

Para instalar a Browser Library pela primeira vez:

```bash
pip install robotframework-browser
rfbrowser init
```

### Atualização

Para atualizar uma instalação existente:

```bash
pip install --upgrade robotframework-browser
rfbrowser clean-node
rfbrowser init
```

### Instalação de Versão Específica

Para instalar uma versão específica:

```bash
pip install robotframework-browser==X.X.X
rfbrowser init
```

## Configuração

A Browser Library requer a inicialização do Playwright após a instalação. O comando `rfbrowser init` baixa os binários necessários dos navegadores suportados.

## Principais Recursos

### Suporte a Múltiplos Navegadores
- Chromium (Chrome, Edge)
- Firefox
- WebKit (Safari)

### Seletores Avançados

A biblioteca oferece um sistema de seletores poderoso e flexível:

#### Estratégias de Seleção
- **Text selectors**: `"Texto do elemento"`
- **CSS selectors**: `css=div.classe`
- **XPath selectors**: `xpath=//div[@class='exemplo']`
- **ID selectors**: `id=elemento-id`

#### Encadeamento de Seletores

A Browser Library permite encadear diferentes estratégias de seleção usando o operador `>>`:

```robotframework
# Seleciona elemento contendo "Login" e depois seu input pai
Click    "Login" >> xpath=../input

# Seleciona div com CSS e depois botão com texto
Click    div.dialog >> "Ok"
```

### Navegação e Interação

```robotframework
*** Settings ***
Library   Browser

*** Test Cases ***
Exemplo de Teste
    New Page    https://playwright.dev
    Get Text    h1    contains    Playwright
    Click    "Get Started"
```

### Manipulação de Elementos

```robotframework
# Obter referência de elemento
${ref}=    Get Element    h1

# Obter propriedade
Get Property    ${ref}    innerText    ==    Login Page

# Executar JavaScript
Evaluate JavaScript    ${ref}    (elem) => elem.innerText = "abc"
```

### Esperas Assíncronas

```robotframework
# Esperar por resposta HTTP
${promise}=    Promise To    Wait For Response    matcher=    timeout=3s
Click    \#delayed_request
${body}=    Wait For    ${promise}
```

### Requisições HTTP

```robotframework
# Enviar requisição HTTP
${response}=    HTTP    /api/post    POST    {"name": "John"}
Should Be Equal    ${response.status}    ${200}
```

## Extensões JavaScript

A Browser Library suporta extensões JavaScript personalizadas:

### Arquivo JavaScript (mymodule.js)
```javascript
async function myGoToKeyword(url, page, logger) {
    logger("Going to " + url)
    return await page.goto(url);
}
myGoToKeyword.rfdoc = "This is my own go to keyword";
exports.__esModule = true;
exports.myGoToKeyword = myGoToKeyword;
```

### Uso no Robot Framework
```robotframework
*** Settings ***
Library   Browser  jsextension=${CURDIR}/mymodule.js

*** Test Cases ***
Example Test
   New Page
   myGoToKeyword   https://www.robotframework.org
```

## Configuração de Estilos

A biblioteca permite configuração de estilos visuais para elementos:

```python
{'duration': datetime.timedelta(seconds=2), 'width': '2px', 'style': 'dotted', 'color': 'blue'}
```

## Docker

A Browser Library também está disponível como imagem Docker:

```bash
# Baixar imagem
docker pull marketsquare/robotframework-browser

# Executar testes
docker run --rm -v $(pwd)/atest/test/:/test --ipc=host --user pwuser --security-opt seccomp=seccomp_profile.json marketsquare/robotframework-browser:latest bash -c "robot --outputdir /test/output /test"
```

## Vantagens em Relação ao Selenium

1. **Performance**: Baseada no Playwright, oferece melhor performance
2. **Seletores mais intuitivos**: Sistema de seletores mais flexível e poderoso
3. **Esperas inteligentes**: Esperas automáticas e inteligentes
4. **Multi-navegador**: Suporte nativo a múltiplos navegadores
5. **Moderno**: Arquitetura moderna baseada em Node.js e Playwright

## Boas Práticas

1. Use seletores semânticos quando possível
2. Aproveite o encadeamento de seletores para elementos complexos
3. Utilize as esperas assíncronas para operações que dependem de respostas
4. Crie extensões JavaScript para funcionalidades customizadas
5. Mantenha a biblioteca atualizada para acessar os recursos mais recentes

## Integração com CI/CD

A Browser Library é ideal para ambientes de CI/CD devido à:
- Instalação simplificada via pip
- Suporte a Docker
- Execução headless por padrão
- Relatórios detalhados
- Compatibilidade com ferramentas de pipeline

## Conclusão

A Robot Framework Browser Library representa uma evolução significativa na automação web com Robot Framework, oferecendo uma abordagem moderna, eficiente e poderosa para testes de interface do usuário. Sua integração com o Playwright e sistema de seletores avançados a tornam uma excelente escolha para projetos de automação web modernos.
# Padrão de Projeto Facade no Robot Framework

## Visão Geral do Padrão Facade

O **Facade** é um padrão de design estrutural que fornece uma interface unificada e simples para um conjunto de interfaces ou operações mais complexas. Em outras palavras, ele atua como uma “fachada” que expõe métodos de alto nível enquanto esconde os detalhes internos. No contexto de testes automatizados, o padrão Facade é particularmente útil para **simplificar fluxos de testes complexos**, melhorar a **manutenibilidade** e promover **reutilização de código**.

No Robot Framework, podemos implementar o Facade por meio de **keywords de alto nível** (em arquivos de recurso) que agregam várias ações menores (como chamadas de API ou interações UI) em uma só. Essas keywords de fachada encapsulam a lógica de negócios de um fluxo completo, fornecendo aos casos de teste uma única chamada simples para executar todo o fluxo. Assim, os casos de teste ficam mais curtos e legíveis, e qualquer mudança nos passos internos do fluxo exige alteração apenas na keyword de fachada, e não em todos os testes individuais.

**Em projetos de automação modernos**, empresas de ponta combinam o padrão Facade com outros padrões (como Page Objects para UI e Service Objects para API) para organizar melhor o código de teste. O Facade atua como uma camada acima dessas abstrações: enquanto Page Objects e Service Objects definem ações atômicas (ex.: *clicar botão*, *fazer requisição*), a fachada oferece **métodos de negócio** que executam várias dessas ações em sequência, correspondendo a casos de uso do sistema. Isso permite que os testes foquem no **que** está sendo feito (fluxo de negócio) em vez de **como**, alinhando as etapas dos testes com a lógica do usuário final. A seguir, veremos como aplicar esse padrão na prática, tanto para testes de API quanto para testes de interface web (UI), incluindo exemplos de código Robot Framework passo a passo.

## Aplicando Facade em Testes de API (Service Facade)

Em testes de API, o padrão Facade pode unificar múltiplas chamadas de endpoints em uma única operação de alto nível. Por exemplo, em vez de um teste chamar diretamente várias requisições REST (autenticar, criar entidade, buscar dados, etc.), podemos criar uma **keyword de fachada** que internamente realiza todas essas chamadas na ordem correta. Isso **simplifica a complexidade** das interações com diversas APIs, expondo um fluxo único para o teste utilizar. Além de deixar os casos de teste mais limpos, essa abordagem facilita adaptações: se a sequência de chamadas mudar (por exemplo, um serviço adicional for requerido), basta ajustar a fachada em um só lugar.

Vamos supor um cenário simples de gerenciamento de usuários via API: precisamos criar um novo usuário e, em seguida, verificar seus dados. Sem o padrão Facade, um caso de teste Robot precisaria invocar separadamente a API de criação e depois a de busca, lidando com IDs e verificações manualmente. Com o Facade, podemos construir uma única keyword `Cadastrar e Verificar Usuário` que realiza todo o fluxo. Abaixo demonstramos como isso pode ser implementado:

```robotframework
*** Settings ***
Resource    ../apis/users_service.resource    # Importa palavras-chave de serviço de Usuários (API)

*** Keywords ***
Cadastrar e Verificar Usuário   ${nome}   ${email}   ${senha}
    [Documentation]  Cria um novo usuário via API e verifica se foi cadastrado com sucesso.
    ${user_id}=    Criar Usuário    ${nome}    ${email}    ${senha}
    ${dados_usuario}=    Obter Usuário Por ID    ${user_id}
    Should Be Equal    ${dados_usuario.nome}    ${nome}
    Should Be Equal    ${dados_usuario.email}   ${email}
```

> **Explicação passo a passo:**
>
> 1. **Criar Usuário:** a keyword de fachada primeiro chama a keyword `Criar Usuário` (fornecida pelo `users_service.resource`). Essa keyword encapsula a chamada POST para o endpoint de criação de usuário e retorna o `ID` do novo usuário criado. Por exemplo, internamente ela pode usar `RequestsLibrary` para enviar a requisição e validar que o status foi 200 (sucesso).
> 2. **Obter Usuário:** em seguida, a fachada chama `Obter Usuário Por ID`, passando o ID obtido. Essa, por sua vez, faz uma requisição GET para buscar os detalhes do usuário recém-criado e retorna os dados (por exemplo, um objeto/dicionário com campos como nome e email).
> 3. **Verificações:** a fachada então executa as asserções necessárias (`Should Be Equal`) para confirmar que os dados retornados correspondem aos dados de entrada (nome e email). Isso garante que o usuário foi criado corretamente.
> 4. **Retorno/Conclusão:** caso todas as etapas acima ocorram sem erros, a keyword de fachada termina com sucesso. (Se necessário, poderíamos retornar algum valor ou mensagem, mas neste caso as validações internas já asseguram o resultado do fluxo.)

Com essa abordagem, um caso de teste que necessite cadastrar um usuário novo pode simplesmente fazer:

```robotframework
*** Test Cases ***
Cadastro de um novo usuário com sucesso
    [Setup]    Configurar API    ${API_URL}
    Cadastrar e Verificar Usuário    John Doe    john.doe@example.com    senha123
    [Teardown]    Resetar Massa de Dados
```

No exemplo acima, `Cadastrar e Verificar Usuário` encapsula todas as ações de criação e verificação, permitindo que o teste em si seja escrito em **uma linha** referente ao fluxo principal. Isso não só deixa o teste mais **limpo e intuitivo**, mas também garante **reutilização** – a mesma fachada pode ser chamada em diversos testes que precisem criar usuários, evitando duplicação de código. Conforme destacam especialistas, o padrão Facade melhora a manutenibilidade centralizando a lógica de fluxo em um único local, útil especialmente quando há interações com múltiplos componentes (várias APIs).

Além deste cenário simples, poderíamos criar facades para fluxos de API mais complexos. Por exemplo, em um contexto de e-commerce, poderíamos ter uma keyword de fachada `Efetuar Compra via API` que realiza uma sequência de chamadas: autentica o usuário, adiciona produtos a um carrinho, cria um pedido e processa o pagamento. O teste final chamaria apenas `Efetuar Compra via API   <dados>` em vez de quatro ou cinco requisições separadas. Esse **“workflow” de API unificado** torna os testes mais robustos contra mudanças: se amanhã o processo de compra exigir um passo extra (por exemplo, aplicar um cupom), basta inserir esse passo na implementação da fachada, sem necessidade de alterar todos os testes relacionados.

**Melhores práticas para Facade em APIs:** ao implementar facades para testes de API, siga os princípios de design limpo:

* **Organização por serviço/domínio:** Centralize keywords de API relacionadas em arquivos de recursos específicos (como `users_service.resource`, `products_service.resource`, etc.) e tenha as facades orquestrando chamadas entre esses serviços conforme necessário. No nosso projeto de exemplo, colocamos keywords de alto nível em `resources/facades/business_workflows.resource` e importamos ali os recursos de API necessários.
* **Nomeclatura clara:** Nomeie as keywords de fachada de acordo com **casos de uso de negócio** (ex: `Cadastrar e Verificar Usuário`, `Efetuar Login API`, `Gerar Relatório X`), de forma que quem lê o caso de teste entenda a intenção do fluxo facilmente.
* **Validações embutidas:** É recomendável que a fachada já verifique condições de sucesso do fluxo (status HTTP esperados, conteúdo básico da resposta etc.), falhando se algo estiver errado. Isso simplifica o teste – muitas vezes não será necessário escrever asserts adicionais no caso de teste, pois a própria fachada garante o resultado esperado do fluxo.
* **Reutilização e DRY:** Aproveite as facades em todos os testes relevantes para evitar repetir sequências de chamadas. Caso note que diferentes fluxos compartilham sub-sequências comuns, você pode fatorar essas sub-sequências em keywords auxiliares (ou mesmo *facades* menores) e chamá-las dentro de outras facades, mantendo o código DRY (Don't Repeat Yourself).

## Aplicando Facade em Testes de UI (Web)

Em testes de interface gráfica web, o padrão Facade geralmente atua em conjunto com o **Page Object Model (POM)**. Cada página da aplicação web possui uma classe ou arquivo de recursos Robot com seus elementos e ações básicas (login\_page, home\_page, etc.). A fachada vem como uma camada acima das pages: definimos keywords que combinam interações de múltiplas páginas para realizar um fluxo de negócio completo na UI. O objetivo é semelhante ao das APIs: **simplificar casos de teste** e isolar a sequência de passos em um único ponto de manutenção.

Considere o caso clássico de **login** no sistema. Sem Facade, um teste para verificar login bem-sucedido precisaria chamar passo a passo: abrir o navegador, navegar para página de login, preencher usuário, preencher senha, clicar em entrar e depois verificar se entrou na página correta. Isso gera 5+ linhas de passos repetidas em vários testes. Com o padrão Facade, podemos criar uma keyword de alto nível `Efetuar Login no Sistema` que realiza todos esses passos internamente. Vejamos um exemplo de implementação:

```robotframework
*** Settings ***
Library    SeleniumLibrary
Resource   ../pages/login_page.resource    # Importa Page Object da página de Login

*** Keywords ***
Efetuar Login no Sistema    ${usuario}    ${senha}
    [Documentation]  Realiza login via UI utilizando as credenciais fornecidas.
    Open Browser    ${LOGIN_URL}    ${BROWSER}    # Abre o navegador na página de login
    Input Text    ${LOGIN_PAGE.USER_FIELD}    ${usuario}
    Input Text    ${LOGIN_PAGE.PASSWORD_FIELD}    ${senha}
    Click Button  ${LOGIN_PAGE.LOGIN_BUTTON}
    Page Should Contain    Bem-vindo, ${usuario}
```

*(No exemplo acima, assumimos que `login_page.resource` define variáveis/locators como `USER_FIELD`, `PASSWORD_FIELD` e `LOGIN_BUTTON` para os seletores da página de login. Poderíamos também ter keywords na page, como `Preencher Usuário`, `Preencher Senha`, etc., e chamá-las aqui, mantendo a fachada ainda mais desacoplada de detalhes de implementação.)*

**Como essa fachada de UI funciona, passo a passo:**

1. **Inicialização da página:** Abre o navegador na URL de login. (Observação: Em alguns frameworks, abrir o browser e navegar pode ser feito em uma configuração de suite ou caso de teste. Aqui incluímos na fachada para ilustrar o fluxo completo de login, mas poderíamos ter separado essa etapa conforme as necessidades do projeto.)
2. **Interações com Page Objects:** Em seguida, a keyword insere o nome de usuário e a senha nos campos apropriados, e clica no botão de login. Note que utilizamos seletores definidos no Page Object `login_page.resource` – isso segue o princípio do POM de centralizar os detalhes dos elementos na classe/página correspondente. A fachada, portanto, **reutiliza** esses elementos ou keywords da página de login ao invés de codificar seletores diretamente, o que facilita manutenção (se o ID ou XPath de um campo mudar, só o Page Object precisa ser atualizado, a fachada permanece válida).
3. **Validação pós-login:** Por fim, a fachada verifica se o login teve sucesso, buscando na página algum texto ou elemento indicativo (no caso, uma saudação "Bem-vindo, usuário" após logar). Esta asserção integrada garante que a operação atingiu o resultado esperado antes de prosseguir. Se essa verificação falhar, a própria keyword de fachada falhará, alertando que o fluxo não se completou como esperado.

Assim, um caso de teste para verificar a funcionalidade de login se resume a chamar a nossa única keyword de fachada, tornando o teste muito simples:

```robotframework
*** Test Cases ***
Login bem-sucedido exibe home page
    Efetuar Login no Sistema    user_teste    Senha@123
    [Teardown]    Close Browser
```

O teste acima não precisa saber quantos campos existem na tela de login, qual botão clicar ou como verificar o sucesso – todos esses detalhes estão escondidos atrás da fachada `Efetuar Login no Sistema`. Isso ilustra o poder do padrão Facade em UI: os testes passam a expressar **intenção de alto nível**, quase como frases em linguagem natural (ex.: "Efetuar login no sistema"), em vez de uma série de ações de baixo nível.

Podemos criar outras facades para fluxos de UI mais complexos. Por exemplo, no contexto de nossa aplicação Dummy (e-commerce fictício), poderíamos ter uma keyword `Realizar Compra Completa` que combina ações de diversas páginas: navega pela home, busca um produto, adiciona ao carrinho, vai para checkout, preenche endereço, seleciona pagamento e finaliza o pedido. Internamente, essa fachada instanciaria ou utilizaria vários Page Objects (HomePage, ProductPage, CartPage, CheckoutPage, etc.) chamando métodos de cada um na sequência correta. **O teste final chamaria apenas** `Realizar Compra Completa   <params>` e a fachada cuidaria de orquestrar todos os cliques e formulários em segundo plano. Esse padrão já é utilizado por grandes organizações: por exemplo, a BrowserStack demonstra uma classe Facade `PlaceOrderFacade` que encapsula todo o fluxo de compra, permitindo que o teste chame apenas um método `placeOrder()` ao invés de interagir com 5 páginas diferentes. A vantagem é clara: se amanhã o processo exigir um novo passo (por exemplo, confirmação de email), ajusta-se o método `placeOrder` (fachada) e **nenhum** caso de teste precisa ser modificado.

**Melhores práticas para Facade em UI:** ao projetar facades para testes web, leve em conta as seguintes recomendações:

* **Use Page Objects como base:** Mantenha os detalhes de UI (locators, pequenos passos) nos arquivos de página. A fachada deve preferencialmente chamar keywords desses Page Objects, em vez de chamar diretamente comandos do SeleniumLibrary em toda parte. Isso reforça a separação de camadas: Page Objects conhecem a estrutura da página, Facades conhecem o fluxo de negócio. No nosso exemplo de login, poderíamos facilmente substituir as linhas de `Input Text` e `Click Button` por chamadas a keywords definidas em `login_page.resource` (ex.: `Preencher Usuário ${usuario}`, `Preencher Senha ${senha}`, `Submeter Login`). A fachada se torna assim uma *orquestradora* pura, sem detalhes técnicos.
* **Isolar diferentes fluxos:** Crie uma keyword de fachada por fluxo **coeso** de negócio. Evite fazer uma fachada muito genérica que execute *tudo*, pois isso a tornaria menos reutilizável. Em vez disso, componha fluxos maiores a partir de facades menores se necessário. Ex: você pode ter `Adicionar Item ao Carrinho` (fluxo que engloba navegar até produto e adicionar), e outra fachada `Finalizar Compra` (que assume que itens já estão no carrinho). Assim, diferentes testes podem reutilizar partes do fluxo conforme contexto (um teste de carrinho usa só a primeira, um teste end-to-end usa ambas, etc.).
* **Verificação de sucesso dentro da fachada:** similar ao caso de APIs, é interessante que a fachada valide o resultado principal do fluxo (ex.: página atual é a esperada, mensagem de sucesso exibida, etc.). Isso serve como garantia de que o passo de negócio foi concluído com êxito antes do teste prosseguir para etapas subsequentes.
* **Fechamento de recursos:** Decida onde abrir/fechar o browser conforme a estratégia do framework. Muitas vezes, abrir o browser ocorre numa **Suite Setup** e fechar em **Suite Teardown**, especialmente se várias facades serão chamadas em sequência no mesmo navegador. Alternativamente, cada fluxo de fachada poderia iniciar e finalizar o browser se for autocontido. Em ambos os casos, documente e mantenha consistente. O importante é que o padrão Facade não conflita com isso – ele pode ser adaptado para tanto iniciar/terminar o navegador quanto assumir que já está aberto, conforme necessário.
* **Leiabilidade acima de tudo:** Nomeie as facades e escreva seus passos de forma que **reflitam o fluxo do usuário**. Idealmente, um não-desenvolvedor deveria conseguir ler a sequência dentro da keyword de fachada e entender o que está sendo realizado (ex.: *login*, *adicionar produto*, *ir para checkout*, *preencher pagamento*, *confirmar pedido*). Essa clareza ajuda na **documentação viva** do sistema: os próprios arquivos de recursos de facades servem como referência dos casos de uso suportados.

## Benefícios e Considerações Finais

Ao aplicar o padrão Facade em automação de testes (seja em APIs ou UI), colhemos diversos benefícios:

* **Testes mais enxutos:** Os casos de teste ficam mais curtos e fáceis de ler, pois interagem com uma interface simplificada (as facades) em vez de múltiplas chamadas detalhadas. Isso aumenta a produtividade do QA e facilita entender o que o teste cobre. Por exemplo, um teste de checkout que antes tinha \~10 passos de página pode se tornar 1 ou 2 chamadas de fachada, correspondendo diretamente ao caso de uso de negócio.
* **Manutenção simplificada:** As fachadas centralizam a lógica de fluxos. Se um elemento de página muda ou um endpoint de API é alterado, apenas o Page Object ou Service correspondente muda; se a sequência de passos muda, apenas a fachada muda. Os testes em si permanecem estáveis, necessitando pouca atualização frente a mudanças na aplicação. Isso reduz drasticamente o esforço de manutenção em larga escala.
* **Reutilização e padronização:** Fluxos comuns (login, setups, operações repetitivas) ficam definidos em um único lugar e reutilizáveis em toda a suíte, evitando duplicação de código. Equipes de ponta enfatizam o uso de facades justamente para manter o código de teste DRY e consistente em diferentes cenários.
* **Camada extra de abstração:** Vale notar que o Facade **adiciona uma camada de indireção** – isto é, mais um nível entre o teste e as ações de baixo nível. Em teoria, isso pode introduzir um leve overhead e requer que a equipe mantenha também as facades atualizadas. Porém, na prática de automação de testes, esse custo é amplamente compensado pela redução de complexidade nos testes e pela melhoria na organização do código. A perda de performance é mínima comparada ao ganho de clareza e robustez.
* **Quando (não) usar:** Utilize o padrão Facade especialmente para **fluxos complexos ou repetitivos**. Se um caso de teste é muito simples ou único, pode não haver necessidade de criar uma fachada apenas para ele – use o bom senso para equilibrar esforço e benefício. No entanto, em suites de teste abrangentes (como as citadas no projeto, com centenas de cenários em CI/CD), *é quase sempre vantajoso investir em facades* para padronizar esses cenários.

Em resumo, o padrão de projeto Facade no Robot Framework permite que os QAs estruturem seus testes de forma mais **modular, legível e resiliente a mudanças**. Seguindo as melhores práticas apresentadas – como separar camadas (Pages/APIs vs. Facades), escrever facades expressivos e manter as verificações dentro delas – um QA consegue aplicar o Facade em seus testes com confiança. A curto prazo, isso simplifica a criação de novos testes (pois muito da lógica comum já estará pronta para uso); a longo prazo, facilita a manutenção conforme a aplicação evolui. Assim, os testes automatizados ficam alinhados aos princípios de engenharia de software, tornando-se mais confiáveis e fáceis de evoluir junto com o produto. 🚀

**Referências Utilizadas:** Facade Pattern em automação de testes (conceitos e exemplos de mercado), entre outras fontes de boas práticas da indústria. Todas elas enfatizam como uma interface unificada simplifica interações complexas e melhora a qualidade do código de teste. Com essa documentação e os exemplos fornecidos, espera-se que um QA consiga aplicar com clareza o padrão Facade em seus testes Robot Framework, tanto para web UI quanto para APIs, aproveitando o que há de melhor em design de framework de testes. Boa automação! 🎉
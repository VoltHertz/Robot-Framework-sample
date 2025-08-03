# Padrão **Library-Keyword / Service Object** no Robot Framework

## Visão Geral do Padrão

O **Library-Keyword Pattern**, também conhecido como **Service Object Model** no contexto de testes de API, consiste em encapsular chamadas de API e lógica de negócio em palavras-chave reutilizáveis (keywords) ou bibliotecas dedicadas por serviço. A ideia é similar ao Page Object Model da automação de UI, porém aplicada a APIs: ao invés de cada teste chamar diretamente endpoints HTTP, criamos “objetos de serviço” (conjuntos de keywords) que representam as operações disponíveis em cada API. Isso **abstrai os detalhes técnicos** (URLs, requisições, parsing de JSON, etc.) para fora dos casos de teste, tornando-os mais legíveis e fáceis de manter. Equipes de ponta adotam esse padrão para tornar a automação de APIs mais **intuitiva, resiliente e escalável** – por exemplo, Spotify e Uber estruturam seus testes de microserviços usando o conceito de Service Objects e builders de dados.

## Problema: Testes sem o Padrão (Código Duplicado e Frágil)

Sem aplicar esse padrão, é comum que diversos casos de teste implementem manualmente sequências semelhantes de chamadas de API e verificações. Isso fere o princípio **DRY (Don't Repeat Yourself)** e dificulta a manutenção: se a API mudar (por exemplo, um endpoint ou formato de resposta), será necessário alterar código em vários testes. Abaixo vemos um exemplo simplificado de um teste **sem** o uso do padrão, onde cada chamada HTTP e verificação é codificada no próprio caso de teste:

```robotframework
*** Settings ***
Library    RequestsLibrary

*** Test Cases ***
Teste Sem Padrão (exemplo simplificado)
    Create Session    api    https://api.exemplo.com
    ${resp1}=    Get    api    /users/1
    Should Be Equal As Integers    ${resp1.status_code}    200
    ${user1}=    Convert To JSON    ${resp1.content}
    ${resp2}=    Get    api    /users/2
    Should Be Equal As Integers    ${resp2.status_code}    200
    ${user2}=    Convert To JSON    ${resp2.content}
    Should Be Equal    ${user1['username']}    alice
    Should Be Equal    ${user2['username']}    bob
```

No exemplo acima, o teste realiza duas requisições GET para obter usuários e valida algumas propriedades. **Problemas** evidentes: estamos repetindo o código de requisição e verificação de status para cada chamada, espalhando detalhes de endpoint (`/users/id`) e manipulação de JSON dentro do caso de teste. Em um cenário real, múltiplos testes poderiam conter trechos quase idênticos. Consequentemente, uma mudança na API (por exemplo, a URL base, rota ou necessidade de autenticação) exigiria modificar *cada* teste afetado – um processo lento e propenso a erros. Além disso, o caso de teste fica poluído com detalhes de baixo nível, dificultando a compreensão da lógica de negócio que está sendo validada.

## Solução: Implementando o **Library-Keyword / Service Object**

Com o padrão **Library-Keyword**, extraímos a lógica repetitiva de dentro dos testes e a colocamos em **palavras-chave reutilizáveis**, organizadas por domínio/serviço. Cada conjunto de keywords funciona como um “serviço” ou objeto de negócio, expondo operações de alto nível da API. Vamos ver passo a passo como aplicar isso, refatorando o exemplo anterior:

**1. Criar uma biblioteca de keywords por serviço:** Na estrutura do projeto, mantenha uma pasta (por exemplo, `resources/apis/`) contendo um arquivo de recursos (.resource) para cada serviço de API. Nele, definimos keywords correspondentes a ações da API. Por exemplo, podemos criar `users_service.resource` para agrupar as operações relacionadas a *Usuários*. Esse arquivo pode importar bibliotecas necessárias (como RequestsLibrary para chamadas HTTP) e definir keywords como **Obter Usuário Com ID**, **Criar Usuário**, etc., encapsulando as chamadas HTTP e qualquer lógica comum.

```robotframework
*** Settings ***
Library    RequestsLibrary
# (Poderíamos importar aqui também JSONLibrary ou outras libs se necessário)

*** Keywords ***
Obter Usuário Com ID 
    [Arguments]    ${user_id}
    Create Session    api    https://api.exemplo.com
    ${response}=    Get    api    /users/${user_id}
    Should Be Equal As Integers    ${response.status_code}    200
    ${dados_usuario}=    Convert To JSON    ${response.content}
    [Return]    ${dados_usuario}

Criar Usuário 
    [Arguments]    ${nome}    ${email}
    ${payload}=    Create Dictionary    name=${nome}    email=${email}
    ${response}=   Post    api    /users    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    ${novo_usuario}=    Convert To JSON    ${response.content}
    [Return]    ${novo_usuario}
```

No código acima, definimos duas keywords: **Obter Usuário Com ID** e **Criar Usuário**. Cada uma realiza a chamada HTTP correspondente (GET ou POST), verifica se a resposta teve sucesso (status 200) e converte o JSON de resposta para um formato utilizável, retornando-o. Note que utilizamos **\[Arguments]** para tornar as keywords flexíveis a diferentes entradas (ID do usuário, nome, email, etc.), evitando valores codificados diretamente. Todos os detalhes de implementação – URL base, método HTTP, construção de payload, verificação de status – estão agora encapsulados nessa “biblioteca” de usuário. Se amanhã a rota `/users` mudar para `/clientes`, por exemplo, basta atualizar a keyword **Obter Usuário Com ID** em um lugar único, ao invés de caçar cada teste que chama a API.

**2. Reutilizar as keywords nos casos de teste:** Com as operações principais abstratas em keywords, os arquivos de teste (.robot) podem simplesmente importar o recurso e chamar essas palavras-chave de alto nível, focando no fluxo de negócio e nas validações específicas de cada caso. Vamos refazer o teste de exemplo usando as novas keywords:

```robotframework
*** Settings ***
Resource    resources/apis/users_service.resource

*** Test Cases ***
Teste Com Padrão (usando Service Object)
    ${user1}=   Obter Usuário Com ID    1
    ${user2}=   Obter Usuário Com ID    2
    Should Be Equal    ${user1['username']}    alice
    Should Be Equal    ${user2['username']}    bob
```

Veja como o caso de teste agora está muito mais **limpo e legível**. Em vez de expor *como* cada chamada é feita, ele descreve *o que* está sendo feito: “Obter Usuário com ID 1”, “Obter Usuário com ID 2”, depois valida os nomes. A lógica de baixo nível (sessão HTTP, verificação de código 200, conversão JSON) acontece dentro das keywords definidas no serviço de usuários. Com isso, ganhamos vários benefícios imediatos:

* **Reutilização:** As keywords **Obter Usuário Com ID** e **Criar Usuário** podem ser chamadas por qualquer caso de teste que precise dessas operações, sem duplicação de código. Isso atende diretamente ao princípio DRY e reduz drasticamente o esforço para criar novos testes (as operações comuns já estão prontas).
* **Manutenibilidade:** Caso a API mude, ajustamos a implementação da keyword uma vez só. Os testes em si não precisam ser reescritos – eles estão desacoplados dos detalhes do endpoint. Como citado antes, separar essa camada torna os testes mais resilientes a mudanças na API. O padrão API Object Model “future-proof” os testes: adaptações concentram-se no objeto de serviço, garantindo que os scripts de teste permanecem funcionais sem modificações extensas.
* **Legibilidade:** Os casos de teste se tornam narrativas de alto nível, próximos da descrição funcional. Isso facilita a compreensão do que está sendo validado, inclusive para quem não conhece detalhes técnicos da API. Palavras-chave de alto nível representam ações de negócio (por exemplo, *“Cadastrar Novo Usuário”* poderia chamar **Criar Usuário** e depois **Obter Usuário** para verificar), enquanto as de baixo nível realizam as tarefas técnicas. Essa hierarquia melhora a organização e evita misturar diferentes níveis de abstração em um só lugar.

**3. Opcional – Lógica de serviço em biblioteca Python:** Em projetos maiores, pode-se optar por implementar os Service Objects também como classes Python (como mostrado na pasta `libraries/` do projeto). Por exemplo, poderíamos ter uma classe `UsersService` com métodos `criar_usuario(nome, email)` e `obter_usuario(id)` implementados em Python. O Robot Framework permite importar classes Python como Libraries, tornando seus métodos disponíveis como keywords. A vantagem dessa abordagem é permitir reutilizar a mesma lógica de serviço fora do Robot – por exemplo, em testes de API feitos com Pytest ou em scripts de carga usando Locust, instanciando a classe de serviço diretamente. Essa separação (código de verificação nos testes e operações de serviço nas classes/keywords) segue boas práticas de engenharia, deixando o código **mais limpo e de fácil entendimento**. Para muitos times, entretanto, definir as keywords em arquivos `.resource` (conforme nosso exemplo) já é suficiente, mantendo tudo em formato Robot Framework. O importante é **centralizar e abstrair** a lógica da API em um só lugar, independente da implementação exata.

## Melhores Práticas ao Aplicar o Padrão

Ao adotar o Library-Keyword Pattern (Service Object), considere as seguintes recomendações para obter o máximo de benefício:

* **Organize por serviço/domínio:** Estruture as keywords em módulos correspondentes às APIs ou áreas de negócio (usuários, produtos, autenticação, etc.), conforme o exemplo. Isso promove modularidade e **reutilização máxima**, já que keywords dentro de um serviço podem chamar umas às outras e servir de base para workflows maiores. API Objects distintos para grupos de funcionalidades isoladas (ex: usuários vs. produtos) aumentam a clareza e evitam colisão de responsabilidades.
* **Use nomes descritivos e consistentes:** Nomeie as palavras-chave de forma clara, em linguagem de negócio. Siga o estilo do Robot (Title Case para keywords) e utilize verbos no infinitivo para ações. Por exemplo, **Obter Usuário Com ID**, **Excluir Produto**, **Validar Resposta de Erro**. Bons nomes tornam os testes quase autoexplicativos e facilitam mapear a keyword à operação que ela realiza. Evite abreviações ou termos técnicos desnecessários – lembre que o objetivo é ser legível para toda a equipe.
* **Defina parâmetros e evite valores fixos:** Torne as keywords genéricas usando `[Arguments]` para receber dados variáveis, e utilize variáveis de ambiente/configuração para constantes como URLs, credenciais, etc. *“Evite codificar valores ou lógica nas palavras-chave; em vez disso use parâmetros ou fontes de dados”*. Isso não só permite reutilizar a mesma keyword em cenários diferentes (p.ex., **Obter Usuário Com ID** para qualquer ID), como também facilita a manutenção (um token de autenticação, por exemplo, pode ser lido de uma variável global ao invés de estar embutido em várias keywords).
* **Encapsule complexidade, exponha simplicidade:** Cada keyword deve idealmente cumprir uma função bem definida (Single Responsibility). Internamente, pode executar passos múltiplos, mas para o teste ela aparece como uma ação única de alto nível. Se a operação é complexa, divida em keywords de baixo nível e então componha uma keyword de nível mais alto que as chame em sequência – seguindo a ideia de palavras-chave de alto nível vs. baixo nível. Por exemplo, você pode ter keywords de baixo nível para chamadas individuais (como **Obter Usuário Com ID** e **Obter Pedidos do Usuário**) e uma keyword de alto nível **Verificar Perfil Completo do Usuário** que chama ambas e valida o conjunto de informações. Assim mantemos a lógica de negócio agregada, mas ainda modularizada.
* **Separa verificação de operação (quando aplicável):** Uma prática comum é manter as asserções principais nos testes ou em keywords de validação separadas, enquanto as keywords de serviço focam em realizar a ação e retornar dados. Isso dá flexibilidade para reutilizar a mesma operação em cenários distintos, validando de maneiras diferentes conforme a necessidade. No entanto, é razoável que a própria keyword de serviço faça **checks básicos** (por exemplo, verificar se o status code foi 200, conforme mostramos), pois em geral se essa condição falhar não faz sentido o teste prosseguir. Encontre um balanço: deixe a keyword garantir o resultado esperado “mínimo” da chamada e retorne os dados, e delegue às camadas superiores quaisquer validações de regra de negócio específicas do caso de teste.
* **Documente e padronize:** Adicione ***\[Documentation]*** às keywords explicando brevemente o que fazem e seus parâmetros/retornos. Utilize também tags se quiser categorizá-las (ex: `[Tags]    API  Usuários`). Embora possa parecer detalhe, documentar as keywords ajuda novos membros do time a entendê-las e promove uso correto. Além disso, mantenha um padrão de formatação e organização nos arquivos de recurso (ordem das sections, separadores, etc.), conforme as convenções do Robot Framework e do seu projeto (seguindo a estrutura exemplificada). Um código consistente e bem documentado é mais fácil de reutilizar e evitará erros de uso.
* **Teste e refatore as keywords:** Assim como código de produção, as bibliotecas de keywords devem ser testadas/validadas. Você pode começar implementando keywords simples e aos poucos refatorar duplicações internas entre elas. Por exemplo, se várias keywords precisam de uma mesma preparação (como garantir que um usuário válido existe no banco), considere mover essa parte para uma keyword de suporte ou Setup. Revise periodicamente se novas funcionalidades da API estão sendo incorporadas seguindo o padrão (é comum no crescimento do projeto surgirem atalhos ou desvios – evite isso mantendo disciplina na arquitetura).

Seguindo essas práticas, seus testes de API no Robot Framework ficarão mais **robustos, enxutos e fáceis de manter**. Ao encapsular a lógica de chamadas em Service Objects, você ganha uma camada de abstração poderosa: os casos de teste focam no comportamento a validar, enquanto os “como fazer” ficam centralizados nas keywords de biblioteca. Essa separação de preocupações é exatamente o que torna o Keyword-Driven Testing eficaz, aplicando conceitos de modularização e design de software na automação de testes.

Em resumo, o padrão Library-Keyword / Service Object permite construir uma suíte de testes **sustentável e escalável**. Quando bem implementado, qualquer QA conseguirá rapidamente entender e reutilizar funcionalidades de teste sem precisar reinventar a roda a cada novo caso. Adotar essa abordagem alinha sua automação às melhores práticas de mercado – não por acaso, muitas empresas líderes a utilizam para manter seus testes confiáveis diante da evolução constante dos sistemas. Com este guia e exemplos, espera-se que você possa aplicar com clareza o padrão em seus próprios testes, colhendo os benefícios de uma automação mais limpa, reutilizável e orientada a design.

**Referências Utilizadas:** As vantagens e conceitos discutidos aqui estão de acordo com publicações recentes e experiências da indústria, incluindo materiais sobre Service Object Model em automação de microserviços, princípios de design no Robot Framework e casos de uso reais em empresas globais, entre outros. Dessa forma, você pode ter confiança de que essas práticas representam um caminho comprovado para melhorar a qualidade e manutenabilidade dos testes automatizados em API.

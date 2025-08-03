# Padrão de Projeto **Strategy** no Robot Framework

O **Strategy Pattern** (Padrão Estratégia) permite definir **múltiplos algoritmos para uma mesma tarefa**, encapsular cada um e torná-los intercambiáveis em tempo de execução. Em automação de testes, isso significa que podemos ter diferentes abordagens (estratégias) para realizar um **setup de dados** ou passos de teste, escolhendo dinamicamente a melhor opção de acordo com parâmetros ou contexto de execução. Em vez de duplicar código para cada variação, aplicamos Strategy para alternar facilmente entre métodos de preparação de dados – por exemplo, via UI, API ou banco de dados – tornando os testes mais **flexíveis e rápidos** quando possível.

## Alternando estratégias de setup de dados por parâmetro de execução

No contexto de testes automatizados, muitas vezes o maior custo de tempo está na preparação dos dados necessários para os cenários. Empresas de ponta contornam isso implementando estratégias alternativas de setup: **se um caminho mais rápido estiver disponível, o teste o utiliza; caso contrário, recorre ao método tradicional**. Por exemplo, a criação de um usuário ou cadastro de um produto para um teste pode ser feita pelos **fluxos UI** (mais lento, simulando o uso real) ou por **chamadas de API/back-end** (bem mais rápido). Com o padrão Strategy, ambas as abordagens ficam **encapsuladas** em estratégias distintas, mas expõem a **mesma interface** (mesma keyword ou método) para o teste. Assim, um parâmetro de execução pode selecionar qual estratégia usar sem alterar o restante do teste.

**Benefícios:**

* *Flexibilidade:* Escolher dinamicamente a estratégia de execução mais adequada (rápida ou completa).
* *Performance:* Permitir rodar testes mais rápido em ambientes de CI (usando estratégias rápidas, p.ex. via API ou DB) e ainda ter opção de fluxos completos em testes end-to-end quando necessário.
* *Manutenibilidade:* Evitar código duplicado – a lógica comum do teste permanece única, variando apenas o método de setup de dados (princípio DRY).
* *Extensibilidade:* Novas estratégias podem ser adicionadas facilmente (por ex., uma nova forma de criar dados) sem modificar os testes existentes, apenas implementando outra classe ou keyword seguindo a interface esperada.

## Implementando o Strategy no Robot Framework

No Robot Framework, podemos aplicar Strategy de duas formas principais: usando **keywords/recursos do próprio Robot** ou utilizando **bibliotecas Python** para encapsular as estratégias. A seguir, detalhamos um exemplo completo para cada abordagem – um focado em testes **Web UI** e outro em testes **de API** –, demonstrando como alternar métodos de setup de dados via um parâmetro de estratégia.

### Exemplo 1: Estratégias de preparo de dados em teste Web UI (UI vs API)

**Cenário:** Suponha que precisamos de um **usuário cadastrado** no sistema para realizar um teste de interface web (por exemplo, verificar login ou perfil do usuário). Podemos criar esse usuário de duas maneiras:

* **Via UI (fluxo manual):** Abrir o navegador, navegar até a página de cadastro, preencher formulário e enviar (simulando o fluxo real do usuário).
* **Via API (fluxo rápido):** Chamar diretamente a API de criação de usuário (ou acessar o banco de dados) para inserir o usuário, evitando a interface e economizando tempo.

Usaremos um **parâmetro `${CREATE_USER_STRATEGY}`** para decidir a estratégia. Digamos que ao rodar os testes, podemos definir `--variable CREATE_USER_STRATEGY:API` para usar o caminho rápido, ou `UI` para o caminho tradicional. A default pode ser `UI` se não especificado.

**1. Definindo as keywords para cada estratégia:** Podemos criar duas keywords separadas para as implementações distintas de cadastro de usuário, garantindo que ambas recebam os mesmos argumentos (por exemplo, dados do usuário) e cumpram a mesma função. Por organização, podemos colocá-las em um arquivo resource (p. ex. `resources/keywords/user_setup.resource`). Exemplo:

```robot
*** Keywords ***
Create User Via UI
    [Arguments]    ${name}    ${email}    ${password}
    # Passos para criar usuário através da interface web (exemplo simplificado):
    Open Browser    ${REGISTER_URL}    ${BROWSER}
    Input Text      id=name    ${name}
    Input Text      id=email   ${email}
    Input Text      id=pass    ${password}
    Click Button    id=registerSubmit
    # Verificar se cadastro foi bem-sucedido (ex: mensagem ou redirecionamento)
    Element Should Be Visible    id=welcomeMessage

Create User Via API
    [Arguments]    ${name}    ${email}    ${password}
    # Uso de uma keyword de HTTP request para chamar API de criação de usuário:
    ${response}=    POST    /api/users    {"name":"${name}", "email":"${email}", "password":"${password}"}
    Should Be Equal As Integers    ${response.status_code}    201    # verifica se criou (HTTP 201)
    ${user_id}=    Parse JSON    ${response.body}    $.id    # extrai ID do usuário criado
    [Return]    ${user_id}
```

No exemplo acima:

* **Create User Via UI:** abre o navegador e realiza o cadastro manualmente.
* **Create User Via API:** envia uma requisição HTTP para criar o usuário diretamente no backend e retorna o `user_id` gerado.

**2. Definindo a keyword de estratégia (contexto):** Agora criamos uma keyword que decide qual das estratégias chamar com base no parâmetro `${CREATE_USER_STRATEGY}`. Essa keyword atua como o **Context** no padrão Strategy, escolhendo e executando a estratégia apropriada:

```robot
*** Keywords ***
Create User (Strategy)
    [Arguments]    ${name}    ${email}    ${password}
    # Escolhe estratégia baseado no parâmetro global (UI por default, se não definido)
    ${strategy}=    Set Variable    ${CREATE_USER_STRATEGY}
    Run Keyword If    "${strategy}"=="UI"    Create User Via UI    ${name}    ${email}    ${password}
    Run Keyword If    "${strategy}"=="API"    ${user_id}=    Create User Via API    ${name}    ${email}    ${password}
    ...    ELSE    Fail    "Estratégia desconhecida: ${strategy}"
    [Return]    ${user_id}
```

Explicação passo a passo:

* `${strategy}= Set Variable ${CREATE_USER_STRATEGY}` obtém o tipo de estratégia desejada (por exemplo "API" ou "UI"). Se `${CREATE_USER_STRATEGY}` não estiver definida, assumimos "UI" como padrão (poderíamos incorporar um default com `Run Keyword Unless`).
* `Run Keyword If` verifica o valor de `${strategy}`. Se for "UI", executa a keyword **Create User Via UI**. Se for "API", executa **Create User Via API** e captura o `${user_id}` retornado.
* O `ELSE` final cuida de valores inesperados, falhando o teste se a estratégia informada não for reconhecida (garante robustez).
* A keyword retorna `${user_id}` (no caso da via UI, poderíamos obter o ID via DB ou página de sucesso; aqui simplificamos assumindo que API retorna o ID enquanto UI poderia não retornar nada diretamente. Em uma implementação real, ambas as estratégias deveriam retornar algum identificador ou confirmar sucesso para uso posterior no teste).

**3. Usando a estratégia no caso de teste:** No próprio caso de teste, fica tudo mais simples e genérico. Por exemplo, em um teste de login poderíamos ter:

```robot
*** Test Cases ***
Testar Login de Usuário
    [Setup]    ${user_id}=    Create User (Strategy)    John Doe    john@test.com    12345
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Text    id=email   john@test.com
    Input Text    id=password   12345
    Click Button  id=login
    Element Should Contain    id=welcomeMsg   John Doe
```

Nesse caso de teste, a etapa de **Setup** chama `Create User (Strategy)` uma vez, e internamente a lógica decide se vai usar a UI ou API para criar o usuário. O teste em si não precisa se preocupar com como o usuário foi criado – apenas sabe que ele existe. **Se rodarmos com `${CREATE_USER_STRATEGY} = API`, o teste ganha velocidade**, pois pulamos a interface gráfica para o setup. Se rodarmos com `UI`, garantimos que também estamos cobrindo o fluxo de cadastro via tela quando necessário. Isso exemplifica a intercambiabilidade dos algoritmos de setup de dados usando Strategy.

**Boas práticas demonstradas:**

* *Separação de responsabilidades:* cada keyword de criação (UI vs API) trata da sua implementação específica. A keyword de *Strategy* apenas faz o roteamento da chamada conforme o tipo.
* *Parâmetro centralizado:* usamos uma variável (pode ser definida em argumentos de linha de comando ou variável de ambiente no CI) para controlar o comportamento globalmente, em vez de “forks” espalhados pelo código de teste.
* *Reuso:* outros testes que precisem criar usuários podem usar `Create User (Strategy)` – acrescentando novos métodos de criação (por ex., *via banco de dados*) basta adicionar outra branch no contexto ou tornar o roteamento dinâmico via mapeamento (ver próxima seção). Isso evita duplicação e facilita manutenção.
* *Limpeza pós-teste:* (não mostrado no snippet) Lembre de implementar também a remoção/limpeza dos dados criados, se necessário, usando a mesma estratégia inversa (ex: deletar via API se criado via API, ou via UI se pela UI), para manter o ambiente consistente.

### Exemplo 2: Estratégias de setup de dados em testes de API (API vs Banco de Dados)

**Cenário:** Em testes de API puro (sem interface gráfica), o Strategy também é valioso. Imagine um teste que valida a API de listagem de carrinho de compras de um usuário (`GET /carts`). Para testar, precisamos *garantir que o usuário tenha itens no carrinho* antes de chamar o endpoint. Podemos preparar esse estado de duas formas:

* **Via APIs públicas (fluxo padrão):** usar a própria API de adicionar item ao carrinho várias vezes para construir o estado necessário (simulando um usuário adicionando produtos).
* **Via inserção direta no banco (atalho):** inserir registros diretamente no banco de dados de carrinho para esse usuário, populando o estado sem passar pelos endpoints (usando talvez uma *Factory* de dados ou script SQL). Essa abordagem é *bem mais rápida*, mas deve ser usada apenas em ambientes de teste controlados.

Suponha que configuramos um parâmetro `${CART_SETUP_STRATEGY}` com valores possíveis `API` ou `DB`. Vamos implementar as estratégias:

**1. Estratégias em código Python (usando classes):** Para demonstrar outra forma de implementar Strategy, podemos criar uma biblioteca Python (por exemplo, `libraries/cart_setup_strategy.py`) que contém classes para cada estratégia e uma função de fábrica que retorna a implementação correta. Essa biblioteca Python será importada no Robot Framework como Library. Por exemplo:

```python
# file: libraries/cart_setup_strategy.py
class CartSetupStrategy:
    def prepare_cart(self, user_id, products):
        """Interface: implementado pelas subclasses"""
        raise NotImplementedError()

class ApiCartSetup(CartSetupStrategy):
    def __init__(self, api_client):
        self.api = api_client  # hipotético cliente de API já autenticado
    def prepare_cart(self, user_id, products):
        # Usa chamadas de API para adicionar cada produto ao carrinho do usuário
        for prod in products:
            self.api.post(f"/carts/{user_id}/items", json={"product_id": prod})
        return True  # retorna True se sucesso

class DbCartSetup(CartSetupStrategy):
    def __init__(self, db_conn):
        self.db = db_conn  # conexão ao banco de dados
    def prepare_cart(self, user_id, products):
        # Insere diretamente registros na tabela de itens de carrinho
        cursor = self.db.cursor()
        for prod in products:
            cursor.execute(
                "INSERT INTO cart_items(user_id, product_id, quantity) VALUES(%s, %s, %s)",
                (user_id, prod, 1)
            )
        self.db.commit()
        return True

# Fábrica que seleciona a estratégia baseada em uma string
def get_cart_setup_strategy(strategy_name, api_client=None, db_conn=None):
    if strategy_name == "API":
        return ApiCartSetup(api_client)
    elif strategy_name == "DB":
        return DbCartSetup(db_conn)
    else:
        raise ValueError(f"Estratégia desconhecida: {strategy_name}")
```

No código acima: definimos uma interface `CartSetupStrategy` com método `prepare_cart(...)` e duas implementações concretas: **ApiCartSetup** e **DbCartSetup**. A função `get_cart_setup_strategy` atua como fábrica para instanciar a estratégia correta conforme o nome. Note que cada implementação recebe no construtor os recursos necessários (um cliente HTTP no caso da API, ou uma conexão DB no caso do banco) – isso poderia ser gerenciado externamente ou dentro da própria classe, conforme o framework do projeto.

**2. Uso da biblioteca no Robot Framework:** Precisamos tornar essa biblioteca disponível nos testes e utilizá-la dentro de uma keyword Robot. Podemos importar `cart_setup_strategy.py` como library no settings de um resource, passando as dependências necessárias (por exemplo, instância do cliente API e conexão DB, que poderiam ser inicializados em outra parte do setup geral do teste):

```robot
*** Settings ***
Library    cart_setup_strategy.py    ${API_CLIENT}    ${DB_CONN}

*** Keywords ***
Prepare Cart (Strategy)
    [Arguments]    ${user_id}    @{products}
    ${strategy_name}=    Set Variable    ${CART_SETUP_STRATEGY}
    ${strategy_obj}=    Get Cart Setup Strategy    ${strategy_name}    ${API_CLIENT}    ${DB_CONN}
    # Chama o método prepare_cart da estratégia selecionada:
    ${result}=    Evaluate    ${strategy_obj}.prepare_cart(${user_id}, ${products})
    Should Be True    ${result}    "Falha ao preparar carrinho usando estratégia ${strategy_name}"
```

Explicação:

* Importamos a biblioteca Python `cart_setup_strategy.py` no início (presumindo que `${API_CLIENT}` e `${DB_CONN}` já estejam configurados em variáveis globais – talvez criados via Library import ou Suite Setup).
* A keyword `Prepare Cart (Strategy)` obtém o nome da estratégia desejada de `${CART_SETUP_STRATEGY}` (por exemplo, "DB" ou "API").
* Em seguida, chamamos `Get Cart Setup Strategy` (função Python importada como keyword) para obter uma instância do objeto de estratégia apropriado, já configurado com cliente API ou conexão DB.
* Usamos `Evaluate` para chamar o método Python `prepare_cart` do objeto selecionado, passando o `user_id` e a lista de `products` (notação `@{products}` para lista). Essa chamada executa efetivamente a lógica da estratégia escolhida: ou adicionando itens via API ou inserindo no DB.
* Verificamos se o resultado foi True (sinal de sucesso). A partir daí, o estado do carrinho foi preparado e o teste pode prosseguir a chamar a API de GET do carrinho, confiante de que os dados necessários estão lá.

**3. Caso de teste usando a preparação de carrinho com Strategy:**

```robot
*** Test Cases ***
Testar Listagem de Carrinho
    [Setup]    Prepare Cart (Strategy)    ${USER_ID}    ${ITEMS_LIST}
    ${response}=    GET    /carts/${USER_ID}
    Should Be Equal As Integers    ${response.status_code}    200
    # Valida que os items esperados estão na resposta
    FOR    ${item}    IN    @{ITEMS_LIST}
        Response Should Contain    ${response.body}    ${item}
    END
```

No \[Setup] do teste, chamamos `Prepare Cart (Strategy)` com o usuário e itens desejados. Com `${CART_SETUP_STRATEGY}` definido para `"DB"`, por exemplo, a preparação insere os dados no banco instantaneamente – tornando o teste muito rápido mesmo com muitos items. Se definido para `"API"`, a preparação usaria chamadas legítimas de API para popular o carrinho – cobrindo também o fluxo normal (embora mais lento). Em ambos os casos, o teste de listagem em si permanece igual, isolado da forma como os dados foram criados.

**Notáveis boas práticas e detalhes no exemplo:**

* *Isolamento de camada:* A lógica de manipulação de banco de dados ou múltiplas chamadas HTTP foi **abstraída para dentro de classes Python** (Service Objects), mantendo o código Robot focado na orquestração de alto nível do teste. Esse uso de **Library-Keyword Pattern** combina bem com Strategy – as estratégias são implementadas em código, mas expostas como keywords reutilizáveis no Robot.
* *Configuração de ambiente:* Estratégias como a de acesso direto ao DB devem ser usadas apenas em ambientes controlados. Grandes empresas frequentemente permitem dados diretos em ambientes de QA, mas nunca em produção. **Parametrizar** isso (via `${CART_SETUP_STRATEGY}`) ajuda a integrar com o CI/CD – por exemplo, em jobs noturnos rodamos com DB para ganhar velocidade, mas em um teste end-to-end final podemos rodar com API para simular apenas comportamentos reais.
* *Integração com Factory Pattern:* Note que poderíamos integrar uma **fábrica de dados** (Factory Pattern) aqui – por exemplo, uma função que gera massa de dados aleatória para carrinho – e usá-la dentro de cada estratégia. Isso manteria cada estratégia enxuta, delegando a criação dos dados a outro componente. Estratégia define **como inserir** os dados; fábrica define **quais dados** criar. Essa separação segue princípios SOLID e melhora reutilização.
* *Validação após setup:* Independente da estratégia usada, é importante que ambas levem ao **mesmo resultado final**. Ou seja, após `Prepare Cart (Strategy)`, o carrinho do usuário deve estar preenchido corretamente. Podemos incluir asserts internos (como fizemos com `Should Be True`) ou logar informações úteis para depurar caso uma estratégia falhe. Grandes empresas adotam práticas de logging e verificação extras quando usam caminhos alternativos, para facilitar descobrir se um eventual bug é na lógica do teste ou na estratégia usada.

## Conclusão

Aplicar o padrão Strategy em automação de testes com Robot Framework **torna a suíte mais flexível e eficiente**. Com ele, conseguimos trocar métodos de setup e execução de forma dinâmica, otimizando tempo sem perder abrangência de cobertura. Como vimos, testes web UI e de API podem se beneficiar:

* Nos testes **Web**, alternamos interações reais de UI com chamadas diretas de APIs para preparar estado do sistema, acelerando os testes sem alterar os passos principais de validação.
* Nos testes **API**, pudemos alternar entre usar as próprias APIs ou atalhos de baixo nível (DB) para compor cenários complexos rapidamente, mantendo o teste em si independente dessas escolhas.

Ao seguir as melhores práticas – separar bem cada estratégia, usar parâmetros de controle, retornar resultados consistentes e evitar duplicação de código – os QAs podem implementar o Strategy Pattern em seus frameworks Robot de forma clara. Isso resulta em setups de teste mais limpos e **executáveis em múltiplas velocidades** conforme a necessidade. Em suma, um QA ao ler esta documentação deve agora entender como estruturar seus keywords ou classes para **trocar algoritmos de teste em tempo de execução** e aplicar imediatamente esse padrão em seus projetos Robot Framework, elevando a qualidade e performance da automação de testes.

**Referências & Fontes:**

* Dubilyer, E. *From Fragile to Flexible: How Design Patterns Can Transform Your Test Automation*. LinkedIn, 2025 – (Estratégia permite seleção dinâmica de comportamentos de teste).
* Agarwal, A. *Mastering Design Patterns in Automation Testing*. LinkedIn, 7mo – (Definição do Strategy e exemplo de estratégias de provedor de dados).
* Souza, A. Publicação no LinkedIn, 2022 – (Conceito do padrão Strategy em português: família de algoritmos encapsulados e intercambiáveis).

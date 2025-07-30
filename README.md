# Robot Framework Design Patterns - Estudos e Implementações

## 📋 Sobre o Projeto

Este repositório é dedicado ao estudo e implementação de **Design Patterns** no **Robot Framework**, com foco em automação de testes de API e boas práticas de desenvolvimento. O objetivo principal é explorar padrões arquiteturais que tornam os testes mais escaláveis, manuteníveis e alinhados às necessidades de equipes de produção.

### 🔄 Origem do Projeto
Este projeto teve origem como um **fork** do repositório [Robot-Framework-02-Estruturando](https://github.com/raiannalimacode/Robot-Framework-02-Estruturando) da **Raianna Lima**, que implementou na prática os ensinamentos do tutorial da **Bianca Campos**. A partir dessa base sólida, expandimos o projeto para incluir estudos aprofundados de Design Patterns e documentação técnica avançada.

## 🎯 Objetivos

- **Estudar Design Patterns**: Aprofundar o conhecimento em padrões de design aplicados ao Robot Framework
- **Implementação Prática**: Aplicar os conceitos aprendidos através de exemplos funcionais
- **Alinhamento com Produção**: Desenvolver práticas que possam ser utilizadas em ambientes reais de desenvolvimento
- **Documentação Técnica**: Criar uma base de conhecimento sólida sobre padrões arquiteturais em automação

## 📚 Base de Conhecimento

### Tutorial Principal
Este projeto foi desenvolvido seguindo e expandindo os ensinamentos do tutorial/kickoff da **Bianca Campos**, uma referência em automação de testes no Brasil. A maior parte da implementação prática do kickoff foi desenvolvida pela **Raianna Lima**, sendo este projeto inicialmente um fork de seu repositório.

🎥 **[Robot Framework - Do Básico ao Avançado](https://www.youtube.com/playlist?list=PL5ipcSFH2tk8RWxtvuaOK-qpdAvlWkSoo)**

📂 **[Repositório Original - Raianna Lima](https://github.com/raiannalimacode/Robot-Framework-02-Estruturando)**

📚 **[SeleniumLibrary Keywords Reference](https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)**

**Sobre Bianca Campos:**
- QA Engineer experiente com foco em automação
- Especialista em Robot Framework e ferramentas de teste
- Criadora de conteúdo educacional de alta qualidade
- Ativa na comunidade brasileira de QA e automação

**Sobre Raianna Lima:**
- Desenvolvedora especializada em automação de testes
- Implementadora das práticas ensinadas no tutorial da Bianca Campos
- Criadora da estrutura base utilizada neste projeto
- Contribuidora ativa da comunidade Robot Framework

### Pesquisa e Documentação
A documentação dos Design Patterns foi desenvolvida através de pesquisas aprofundadas utilizando **Google Gemini 2.5 Pro**, garantindo:
- Análise técnica detalhada de cada padrão
- Exemplos práticos e implementações
- Melhores práticas da indústria
- Fundamentação teórica sólida

### Referências Técnicas Essenciais
A **SeleniumLibrary Keywords Reference** é uma documentação oficial completa que contém:
- **Todas as keywords disponíveis** para automação web com Robot Framework
- **Sintaxe detalhada** com exemplos de uso para cada keyword
- **Parâmetros e argumentos** necessários para cada função
- **Tipos de retorno** e comportamentos esperados
- **Casos de uso práticos** para interação com elementos web

Esta referência é fundamental para implementar corretamente os Design Patterns apresentados neste projeto, especialmente o Page Object Model (POM) e outros padrões que dependem de interações precisas com elementos de interface.

## 🏗️ Design Patterns a implementar/Implementados

### 📁 Documentação Disponível

**Atenção, os desing patterns apresentados aqui foram feitos com engenharia de prompt por IA e podem apresentar erros por solitações ineficientes, no entanto o material apresenta um bom estudo na área**

1. **[Page Object Model (POM)](./POM_Robot.md)**
   - Padrão fundamental para organização de elementos de UI
   - Separação entre lógica de teste e interação com elementos

2. **[Strategy Pattern](./Strategy_Robot.md)**
   - Implementação de diferentes estratégias de teste
   - Flexibilidade na escolha de abordagens

3. **[Factory Pattern](./Factory_Robot.md)**
   - Criação de objetos de teste de forma dinâmica
   - Centralização da lógica de instanciação

4. **[Facade Pattern](./Facade_Robot.md)**
   - Simplificação de interfaces complexas
   - Criação de APIs de alto nível para testes

5. **[Abstraction Pattern](./Abstraction_Robot.md)**
   - Modelo de Objeto de Serviço para APIs
   - Guia definitivo para automação escalável
   - Implementações para REST, Kafka e gRPC

6. **[Resumos e Comparações](./Resumo_Patterns_Robot.md) e subsequentes**
   - Visão geral dos padrões
   - Quando usar cada um
   - Comparações práticas
   - Novos modelos além dos anteriores
   - A ultima versão tentará consolidar todos os design patterns anteriores em um único documento

## 🛠️ Estrutura do Projeto

```
├── Kickoff/           # Implementação prática do tutorial (Raianna Lima)
│   ├── Elements/      # Elementos de página e componentes
│   ├── Resource/      # Recursos e keywords reutilizáveis
│   ├── Results/       # Relatórios e resultados de execução
│   ├── Steps/         # Steps de teste organizados
│   ├── Tests/         # Casos de teste
│   ├── travel.robot   # Exemplo prático de implementação
│   ├── requirements.txt # Dependências do Robot Framework
│   ├── log.html       # Log detalhado da execução
│   ├── output.xml     # Dados estruturados dos resultados
│   └── report.html    # Relatório visual dos resultados
├── Patterns/          # Documentação dos Design Patterns
│   ├── Abstraction_Robot.md
│   ├── Facade_Robot.md
│   ├── Factory_Robot.md
│   ├── POM_Robot.md
│   ├── Strategy_Robot.md
│   └── Resumo_*.md    # Documentação dos patterns
└── README.md          # Este arquivo
```

## 🚀 Como Usar 

### 📋 Pré-requisitos e Instalação

#### Opção 1: Instalação via Chocolatey (Recomendado para Windows)
1. **Abra o PowerShell como Administrador**
2. **Instale o Python:**
   ```bash
   choco install python3 -y
   ```
3. **Feche e reabra o terminal** (sem privilégios de admin)
4. **Verifique a instalação:**
   ```bash
   python --version
   pip --version
   ```

#### Opção 2: Instalação Manual
1. Baixe o Python em: https://www.python.org/downloads/
2. **IMPORTANTE:** Durante a instalação, marque "Add Python to PATH"

#### Instalando as Dependências do Robot Framework

**Opção A: Instalação via requirements.txt (Recomendado)**
```bash
# Navegar para o diretório Kickoff
cd Kickoff

# Instalar todas as dependências de uma vez
pip install -r requirements.txt
```

**Opção B: Instalação manual das dependências**
```bash
# Dependências básicas
pip install robotframework
pip install robotframework-seleniumlibrary
pip install robotframework-requests

# Dependências adicionais para diferentes protocolos
pip install robotframework-jsonlibrary
pip install robotframework-pabot        # Para execução em paralelo
pip install robotframework-browser      # Alternativa moderna ao Selenium

# Para APIs e testes de serviço
pip install robotframework-httplibrary
pip install robotframework-confluentkafkalibrary  # Para Kafka

# Para gRPC (se necessário)
pip install robotframework-grpc-library
pip install grpcio-tools grpcio protobuf types-protobuf googleapis-common-protos
```

#### Verificando a Instalação
```bash
# Verificar se o Robot Framework foi instalado corretamente
robot --version

# Listar bibliotecas instaladas
pip list | findstr robot
```

### Executando os Testes
```bash
# Navegar para o diretório Kickoff
cd Kickoff

# Executar todos os testes
python -m robot Tests/

# Executar teste específico
python -m robot Tests/nome_do_teste.robot

# Executar com tags específicas
python -m robot --include smoke Tests/

# Executar apenas o arquivo principal de exemplo
python -m robot travel.robot
```

### Explorando os Patterns
1. Comece pela leitura da documentação em `Patterns/Resumo_Patterns_Robot.md`
2. Estude cada pattern individualmente nos arquivos `.md` em `Patterns/`
3. Examine as implementações práticas nos diretórios `Kickoff/Elements/`, `Kickoff/Resource/` e `Kickoff/Steps/`
4. Execute os testes em `Kickoff/Tests/` para ver os patterns em ação
5. Use o arquivo `Kickoff/travel.robot` como exemplo de implementação completa

## 📖 Recursos Adicionais

### Documentação Técnica
- Cada pattern possui documentação detalhada com exemplos
- Análises comparativas entre diferentes abordagens
- Casos de uso reais e implementações práticas

### Comunidade e Aprendizado
- **YouTube**: [Canal da Bianca Campos](https://www.youtube.com/@biancacampos)
- **GitHub**: [Repositório Original - Raianna Lima](https://github.com/raiannalimacode/Robot-Framework-02-Estruturando)
- **Robot Framework**: [Documentação Oficial](https://robotframework.org/)
- **SeleniumLibrary**: [Documentação](https://github.com/robotframework/SeleniumLibrary)

## 🤝 Contribuições

Este é um projeto de estudos, mas contribuições são bem-vindas:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/NovoPattern`)
3. Commit suas mudanças (`git commit -m 'Adiciona novo pattern'`)
4. Push para a branch (`git push origin feature/NovoPattern`)
5. Abra um Pull Request

## 📋 To-Do

- [ ] Implementar mais exemplos práticos
- [ ] Adicionar testes para APIs GraphQL
- [ ] Expandir documentação com mais casos de uso
- [ ] Criar templates reutilizáveis
- [ ] Adicionar integração com CI/CD

## 📄 Licença

Este projeto está sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🙏 Agradecimentos

- **Bianca Campos** - Pelo excelente tutorial que serviu de base para este projeto
- **Raianna Lima** - Pela implementação prática do tutorial da Bianca e estrutura base deste repositório
- **Comunidade Robot Framework** - Pela ferramenta incrível e documentação
- **Google Gemini 2.5 Pro** - Pela assistência na pesquisa e documentação técnica

---

⭐ Se este repositório foi útil para você, considere dar uma estrela para ajudar outros desenvolvedores a encontrá-lo!

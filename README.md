# Publifly.ai

**Publifly.ai** é uma plataforma de automação de criação de conteúdo para redes sociais, que utiliza inteligência artificial para gerar textos e imagens, otimizar publicações e agilizar o processo de criação e gestão de conteúdo. A solução integra Flutter para o frontend, Firebase para armazenamento e autenticação, e Python para o backend, utilizando Flask para a criação de APIs.

## Tecnologias Utilizadas

- **Frontend**: 
  - **Flutter**: Framework para a criação de interfaces móveis e web multiplataforma.
  
- **Backend**: 
  - **Python**: Linguagem de programação usada para o desenvolvimento do backend.
  - **Flask**: Micro-framework para criação de APIs RESTful em Python.
  - **Docker**: Utilizado para containerizar a aplicação backend.
  - **Render**: Plataforma de deploy do backend em um web service.

- **Banco de Dados**: 
  - **Firebase Firestore**: Banco de dados NoSQL em tempo real para armazenar informações dos usuários e dados das publicações.

- **Autenticação**: 
  - **Firebase Authentication**: Para gerenciar a autenticação e registro de usuários.

- **Inteligência Artificial**:
  - **CrewAI**: Agentes de marketing digital e automação de conteúdo.
  - **SerperAI**: API para pesquisa e coleta de dados atualizados.
  - **LLMs (OpenAI, LLama, Gemini)**: Para a geração de conteúdo (textos) e imagens automáticas.

## Funcionalidades

1. **Geração de Conteúdo**:
   - O usuário pode solicitar à plataforma que gere conteúdo com base em um tema fornecido.
   - O conteúdo gerado é automaticamente revisado, otimizado e adaptado para diferentes plataformas de redes sociais.

2. **Integração com Redes Sociais**:
   - Possibilidade de automatizar o envio de publicações para redes sociais (em fase de desenvolvimento).

3. **Geração de Imagens**:
   - Imagens são geradas com base no conteúdo criado, utilizando uma API de LLM.

4. **Gestão de Publicações**:
   - O sistema permite salvar, revisar e ajustar os conteúdos gerados, além de fornecer métricas de engajamento.

## Fluxo do Aplicativo

1. O usuário solicita ao backend a criação de uma publicação fornecendo um tema.
2. O backend coleta dados relevantes do SerperAI e os salva no Firebase.
3. O conteúdo gerado é passado por uma LLM para criar o texto da publicação.
4. O conteúdo é salvo no banco de dados e disponibilizado para revisão.
5. O usuário pode gerar uma imagem associada à publicação.
6. O conteúdo final é exibido ao usuário e pronto para ser publicado nas redes sociais.

## 👨‍💻 Contato

<p>
    <img 
      align=left 
      margin=10 
      width=80 
      src="https://avatars.githubusercontent.com/u/80135269?v=4"
    />
    <p>&nbsp&nbsp&nbspManuela Bertella Ossanes<br>
    &nbsp&nbsp&nbsp
    <a href="https://github.com/manuabigsz">
    GitHub</a>&nbsp;|&nbsp;
    <a href="https://www.linkedin.com/in/manuela-bertella-ossanes-690166204/">LinkedIn</a>
&nbsp;|&nbsp;
    <a href="https://www.instagram.com/manuossz/">
    Instagram</a>
&nbsp;|&nbsp;</p>
</p>
<br/><br/>
<p>
---
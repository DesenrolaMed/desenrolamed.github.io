# 🩺 Contexto Técnico Completo do Projeto DesenrolaMed

> **Instrução para a IA**: Você está recebendo o dossiê técnico completo e atualizado da plataforma **DesenrolaMed**. Utilize as especificações, regras de negócio, estrutura de código e padrões abaixo para entender o projeto, propor melhorias, solucionar problemas ou implementar novas funcionalidades mantendo a coerência com a arquitetura existente.

---

## 1. 📌 Visão Geral do Projeto

- **Nome da Plataforma**: DesenrolaMed
- **Objetivo**: Aplicação web interativa focada no estudo e preparação para provas de Medicina da faculdade (AFYA e internato), contendo simulados comentados, banco de questões higienizado, chat em tempo real por período, caderno de erros, flashcards e ranking acadêmico.
- **Link Online em Produção**: [https://desenrolamed.github.io/](https://desenrolamed.github.io/)
- **Repositório GitHub**: `https://github.com/DesenrolaMed/desenrolamed.github.io.git` (branch `main`)
- **Público-alvo**: Estudantes de Medicina do 1º ao 8º período, Internato, candidatos ao ENAMED e TPI.

---

## 2. 🛠️ Stack Tecnológica & Arquitetura

- **Paradigma**: **Single-Page Application (SPA) pura em Vanilla Web** (HTML5 Semântico, CSS3 Moderno com Custom Properties e JavaScript ES6+ puro).
- **Sem Bundlers / Sem Build Step**: Não depende de Node, Webpack, Vite ou frameworks front-end (React, Vue, Angular). Todo o código roda nativamente e de forma instantânea em qualquer navegador web.
- **Hospedagem**: **GitHub Pages** (servindo arquivos estáticos com cache global).
- **Comunicação em Tempo Real**:
  - **MQTT sobre WebSockets**: Biblioteca cliente `MQTT.js` (`https://unpkg.com/mqtt@5.3.5/dist/mqtt.min.js`) conectada a broker seguro (`wss://broker.emqx.io:8084/mqtt`).
  - **BroadcastChannel API**: Sincronização instantânea e sem latência entre diferentes abas abertas no mesmo navegador (`dm_chat_bus`).
- **Efeitos e Gamificação**:
  - `canvas-confetti` (`https://cdn.jsdelivr.net/npm/canvas-confetti`): Animações de celebração ao atingir metas e finalizar simulados.

---

## 3. 📂 Estrutura de Diretórios e Arquivos

```text
📁 Banco de dados do Desenrola/
│
├── 📄 index.html                # Aplicação principal servida pelo GitHub Pages
├── 📄 desenrolaMed.html         # Arquivo espelho mestre para desenvolvimento
├── 📄 desenrolaMed_Amigos.html   # Arquivo espelho para distribuição/sincronização
├── 📄 site_desenrolaMed.zip     # Pacote compactado com todo o sistema e dados
├── 📄 PUBLICAR_NO_SITE.bat      # Script batch para git add, commit e push automático
├── 📄 CONECTAR_PRIMEIRA_VEZ.bat # Script batch para autenticação inicial no repositório
│
└── 📁 dados/                    # Módulos JS de questões carregados via <script>
    ├── 📄 provas_afya_1.js      # Banco de questões do 1º Período
    ├── 📄 provas_afya_2.js      # Banco de questões do 2º Período
    ├── 📄 provas_afya_3.js      # Banco de questões do 3º Período
    ├── 📄 provas_afya_4.js      # Banco de questões do 4º Período
    ├── 📄 provas_afya_5.js      # Banco de questões do 5º Período
    ├── 📄 provas_afya_6.js      # Banco de questões do 6º Período
    ├── 📄 provas_afya_7.js      # Banco de questões do 7º Período
    ├── 📄 provas_afya_8.js      # Banco de questões do 8º Período
    ├── 📄 provas_afya_enamed.js # Banco de questões do ENAMED
    ├── 📄 provas_afya_int.js    # Banco de questões do Internato Médico
    └── 📄 provas_afya_tpi.js    # Banco de questões do TPI
```

---

## 4. 🗄️ Estrutura do Banco de Questões

As questões são carregadas em memória no array global `window.EXTRA_D` e concatenadas ao array `D`. Cada questão segue a seguinte estrutura de dados:

```javascript
{
  "id": "pa-c5e6350cd9-q1",          // ID único da questão
  "s": "Saúde Coletiva e SUS",        // Assunto / Especialidade médica
  "t": "Enunciado completo da questão...", // Enunciado clínico limpo
  "o": [                              // Array de alternativas (A, B, C, D e/ou E)
    "Realizar visitas domiciliares para identificar fatores de risco...",
    "Prescrever medicamentos básicos e realizar consultas...",
    "Realizar o diagnóstico clínico e instituir o tratamento...",
    "Coordenar as ações de vigilância epidemiológica..."
  ],
  "a": 0,                             // Índice da alternativa correta (0 = A, 1 = B, etc.)
  "c": "Gabarito comentado detalhado com referências bibliográficas da AFYA e Ministério da Saúde..."
}
```

### Regras de Qualidade e Higienização Aplicadas:
1. **Total de Questões Ativas**: **5.907 questões higienizadas** (5.855 objetivas com opções A-E e gabarito validado + 52 discursivas clínicas legítimas).
2. **Zero Poluição de Scraping**: O prefixo corrompido `OK Revisar○ (...) ROT.` foi **100% extirpado**.
3. **Sem Questões Truncadas**: Questões que não possuíam opções válidas ou cujo enunciado foi cortado na extração foram excluídas.
4. **Modo Discursivo Legítimo**: Restrito exclusivamente a questões dissertativas autênticas (casos de trauma e cirurgia com padrão de resposta detalhado nos moldes de pontuação `a)` e `b)`).

---

## 5. 🖥️ Módulos e Telas da Aplicação (Views)

O roteamento interno do SPA é controlado pela função `show(viewId)` que gerencia a visibilidade através do atributo `hidden`:

```javascript
var ALL_SECS = ["top", "provas", "metas", "erros", "guias", "flashcards", "ia", "admin", "area", "ci", "chat"];
```

### 1. Início & Questões (`#top`)
- **Filtros de Período**: Botões para alternar instantaneamente entre `Todos`, `1º` ao `8º Período`, `Internato`, `ENAMED` e `TPI`.
- **Disciplinas**: Cards interativos por matéria com contagem dinâmica de questões.
- **Barra de Busca**: Campo de pesquisa rápida em tempo real por palavras-chave em todos os enunciados.
- **Ranking Lateral Compacto (Top 10)**:
  - Localizado na coluna lateral direita (`top-side-col`).
  - **Pódio Olímpico**:
    - 🥇 **1º Lugar**: Dourado com animação de foguinho (`🔥`).
    - 🥈 **2º Lugar**: Prateado discreto.
    - 🥉 **3º Lugar**: Bronze metálico.
    - **4º ao 10º Lugar**: Lista minimalista de corredores.
  - **Atalho de 1 Clique**: Botão direto para entrar no Chat Aberto dos Estudantes.

### 2. Simulador de Questões (`#ci`)
- **Modo Múltipla Escolha**:
  - Alternativas A, B, C, D e E com avaliação instantânea de acerto/erro.
  - Gabarito comentado exibido automaticamente após resposta.
  - Atalhos de teclado ergonômicos: Teclas `1`-`5` ou `A`-`E`, `Enter` para avançar, `Espaço` para pausar.
- **Modo Discursivo**:
  - Campo de texto para redigir a resposta antes de conferir o espelho da banca.
  - Critérios de pontuação e botões de autoavaliação (`Acertei`, `Parcial`, `Errei`).
- **Ações Rápidas**: `Revisar ○`, `+ Anotação Pessoal` e `+ Flashcard Instantâneo`.
- **Minimapa da Prova**: Grid lateral com o status de cada questão respondida.

### 3. Chat Aberto dos Estudantes (`#chat`)
- **10 Canais de Grupo Segmentados**:
  - `🌐 Geral`: Discussão aberta para todos os períodos e avisos gerais.
  - `📚 1º ao 8º Período`: Canais dedicados para cada semestre da graduação.
  - `🏥 Internato`: Canal focado nos rodízios de enfermaria, ambulatório e urgência.
- **Filtro de Mensagens**: Campo de busca instantâneo para filtrar conversas por palavras ou autores.
- **Sincronização em Tempo Real**: Conexão MQTT sobre WebSockets (`wss://broker.emqx.io:8084/mqtt`) com broadcast local entre abas (`BroadcastChannel`).
- **Identificação Visual do Remetente**:
  - Tag de período do aluno (ex: `[7º Período]`, `[Internato]`).
  - Selo exclusivo dourado `👑 Admin` para mensagens da conta oficial.
  - Mensagens próprias alinhadas à direita em destaque; mensagens de colegas à esquerda.
  - Botões de bizus rápidos: `💡 Bizu:`, `❓ Dúvida:`, `📚 Material:`, `🔥 Foco na Prova:`.

### 4. Painel Administrativo (`#admin`)
- **Acesso Exclusivo**: Protegido contra qualquer usuário que não seja o administrador oficial.
- **Métricas Globais**: Estudantes online em tempo real, total de usuários cadastrados, total de questões respondidas no sistema e líder do ranking.
- **Radar de Estudantes Online**: Lista de alunos com presença ativa nos últimos 5 minutos.
- **Tabela de Alunos Cadastrados**: Pesquisa, data de cadastro, período e total de questões resolvidas.
- **Exportação de Dados**: Download da base de usuários e estatísticas em formato JSON.

### 5. Outros Módulos
- **Provas & PDFs (`#provas`)**: Catálogo organizado para visualização das provas oficiais.
- **Caderno de Erros (`#erros`)**: Fila inteligente de repetição para revisar apenas as questões que o aluno errou.
- **Guias Clínicos (`#guias`)**: Resumos objetivos e condutas práticas baseadas em consensos médicos.
- **Flashcards (`#flashcards`)**: Sistema de repetição espaçada com virada de cards e autoavaliação.
- **Metas (`#metas`)**: Planejamento de metas diárias de questões e percentual de progresso.
- **IA & Backup (`#ia`)**: Prompts prontos para NotebookLM / Gemini e sistema de backup/restauração de dados do aluno via arquivo JSON.

---

## 6. 🔒 Regras de Negócio e Segurança

1. **Acesso Bloqueado sem Login (Access Gate)**:
   - A plataforma exige autenticação prévia (login com e-mail e senha) para liberar o acesso às questões e ferramentas.
2. **Administrador Único e Exclusivo**:
   - A permissão de administrador (`role = "admin"`) é atribuída **estritamente e exclusivamente** à conta com o e-mail:
     ```javascript
     (u.email || "").trim().toLowerCase() === "igorinteraminense@gmail.com"
     ```
   - Nenhuma outra conta (mesmo que se cadastre com o nome "Igor" ou qualquer outro e-mail) tem acesso ao painel de administração ou ao selo de admin.
3. **Dados 100% Autênticos (Zero Dados Fictícios)**:
   - Todos os dados simulados (`DEFAULT_PEERS`) foram eliminados do código.
   - O ranking e os contadores refletem **apenas** contas reais criadas no sistema e questões efetivamente resolvidas pelos usuários.

---

## 7. 💾 Gerenciamento de Estado no Front-End (`localStorage`)

| Chave | Formato | Finalidade |
| :--- | :--- | :--- |
| `dm_current_user` | `Object` | Dados da sessão ativa do aluno (nome, e-mail, período, role). |
| `dm_auth_users` | `Array<Object>` | Lista de todos os usuários cadastrados na plataforma. |
| `dm-hist` | `Object` | Histórico de resolução (acertos, erros, respostas e timestamps). |
| `dm_online_presence` | `Object` | Heartbeat atualizado a cada minuto para o monitor de usuários online. |
| `dm_chat_history_v1` | `Object` | Histórico de mensagens por canal de conversa do chat. |
| `dm-notes` | `Object` | Anotações pessoais vinculadas ao ID de cada questão. |
| `dm-cfc` | `Array<Object>` | Flashcards personalizados criados pelo usuário. |
| `dm-favs` | `Array<String>` | IDs das questões favoritadas com estrela (⭐). |
| `dm-period` | `String` | Período acadêmico selecionado atualmente no filtro. |
| `dm-theme` | `String` | Preferência de tema (`dark` ou `light`). |

---

## 8. 🎨 Design System e Tokens CSS

- **Modo Escuro (Padrão)**: Fundo `#0b0f19`, Cards `#111827`, Texto `#f3f4f6`, Bordas `#1f2937`.
- **Modo Claro**: Fundo `#f8fafc`, Cards `#ffffff`, Texto `#0f172a`, Bordas `#e2e8f0`.
- **Cores Semânticas**:
  - Roxo DesenrolaMed (`--pl`): `#7c3aed` (Primária / Identidade da marca)
  - Verde Sucesso (`--ok`): `#10b981` (Acertos, status online)
  - Vermelho Erro (`--er`): `#ef4444` (Erros no gabarito)
  - Dourado / Pódio (`--wn`): `#f59e0b` (Destaque do 1º lugar do ranking e selo de Admin)
- **Folha de Prova / Impressão (`@media print`)**: Formatação especial para impressão limpa de simulados com gabarito ao final.

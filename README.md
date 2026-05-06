# 🏦 Banco Legado COBOL

Simulação de um core bancário legado utilizando COBOL e Db2, estruturado com princípios modernos de arquitetura para demonstrar estratégias reais de modernização de sistemas críticos.

---

## 🎯 Objetivo

Este projeto tem como objetivo simular um cenário real de sistemas bancários legados, onde:

* A lógica de negócio é implementada em COBOL
* Os dados são persistidos em Db2
* A infraestrutura é provisionada via Docker
* A arquitetura é organizada de forma modular e escalável

---

## 🧠 Contexto

Grande parte dos bancos ainda opera sistemas críticos baseados em COBOL, integrados a bancos de dados robustos como o IBM Db2.

Este projeto demonstra:

* Como esses sistemas funcionam internamente
* Quais são seus desafios
* Como podem ser modernizados de forma incremental

---

## 🏗️ Arquitetura

```text
+---------------------+
|     COBOL Core      |
| (Lógica de Negócio) |
+----------+----------+
           |
           v
+---------------------+
|        Db2          |
|   (Persistência)    |
+----------+----------+
           |
           v
+---------------------+
|   Infraestrutura    |
|     (Docker)        |
+---------------------+
```

---

## 📁 Estrutura do Projeto

```bash
banco-legado-cobol/
│
├── cobol-core/        # Lógica de negócio em COBOL
├── db2-database/      # Scripts SQL (DDL/DML)
├── infra/             # Docker e infraestrutura
├── docs/              # Documentação e decisões arquiteturais
├── tests/             # Testes (futuro)
│
├── Makefile           # Automação de comandos
└── README.md
```

---

## ⚙️ Como executar

### 1. Subir o banco Db2

```bash
cd infra
docker-compose up -d
```

---

### 2. Criar estrutura do banco

```bash
cd db2-database
# executar scripts SQL manualmente ou via script
```

---

### 3. Executar programa COBOL

```bash
cd cobol-core
./scripts/compile.sh
./scripts/run.sh
```

---

## 💡 Caso de Uso

Consulta de saldo e movimentações de um cliente:

* Busca dados do cliente
* Consulta conta associada
* Exibe saldo atual
* Lista últimas transações

---

## ⚖️ Decisões Arquiteturais

* Uso de mono-repo para facilitar setup e entendimento
* Separação clara entre:

  * lógica de negócio (COBOL)
  * dados (Db2)
  * infraestrutura (Docker)
* Simulação de ambiente real sem dependência de mainframe

---

## ☁️ Estratégia de Modernização

Este projeto pode evoluir para:

* Exposição via API (Python / FastAPI)
* Migração para cloud (AWS)
* Substituição gradual do COBOL (Strangler Pattern)

---

## 🚀 Próximos Passos

* [ ] Integração COBOL com Db2 via ODBC
* [ ] Criação de API moderna
* [ ] Observabilidade (logs e métricas)
* [ ] Testes automatizados

---

## 🧠 Aprendizados

* Complexidade de sistemas legados não está na linguagem, mas no ecossistema
* Separação de responsabilidades é essencial mesmo em sistemas antigos
* Modernização deve ser incremental e orientada a risco

---

## 📌 Autor

Rodrigo Sena de Oliveira
Arquiteto de Soluções | Especialista em modernização de sistemas críticos

---

# ⚙️ Como construir isso passo a passo (guia real)

## 🔹 Etapa 1 — Criação inicial

```bash
mkdir banco-legado-cobol
cd banco-legado-cobol
git init
touch README.md
```

👉 Cole o conteúdo acima

---

## 🔹 Etapa 2 — Primeiro commit (importante estrategicamente)

```bash
git add .
git commit -m "feat: initial architecture and project structure for legacy banking simulation"
```

👉 Esse commit já comunica senioridade

---

## 🔹 Etapa 3 — Subir no GitHub

```bash
git remote add origin <seu-repo>
git push -u origin main
```

---

# ⚖️ Decisões e Trade-offs

### Por que esse README funciona?

| Elemento       | Impacto                   |
| -------------- | ------------------------- |
| Objetivo claro | recrutador entende rápido |
| Arquitetura    | mostra visão              |
| Modernização   | mostra futuro             |
| Simplicidade   | evita overengineering     |

---

# 🧼 Boas práticas aplicadas

* Clareza > volume
* Linguagem executiva
* Separação de camadas
* Narrativa orientada a negócio

---

# ⚠️ Riscos

| Risco                 | Mitigação                 |
| --------------------- | ------------------------- |
| README técnico demais | manter visão de negócio   |
| Muito simples         | adicionar arquitetura     |
| Falta de contexto     | explicar cenário bancário |

---

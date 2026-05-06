#!/bin/bash
set -u

PROJECT_DIR="${HOME}/Desktop/PROJETOS/Git/banco-legado-cobol"
DOCKER_DIR="${PROJECT_DIR}/infra/docker"
COBOL_DIR="${PROJECT_DIR}/cobol-core/src"
OUTPUT_DIR="${PROJECT_DIR}/output"
CONTAINER_NAME="banco-postgres"
DB_USER="admin"
DB_NAME="banco"

banner() {
  clear
  echo "============================================================"
  echo "          BANCO LEGADO COBOL - DEMO AUTOMATIZADA"
  echo "============================================================"
  echo " Fluxo:"
  echo " PostgreSQL -> CSV -> COBOL -> Relatorio TXT"
  echo "============================================================"
  echo
}

step() {
  echo
  echo "------------------------------------------------------------"
  echo ">> $1"
  echo "------------------------------------------------------------"
}

run_cmd() {
  echo
  echo "+ $1"
  eval "$1"
  local status=$?
  if [ $status -ne 0 ]; then
    echo
    echo "ERRO: comando falhou com status ${status}."
    echo "Interrompendo execucao."
    exit $status
  fi
}

pause_if_interactive() {
  if [ "${INTERACTIVE_DEMO:-1}" = "1" ]; then
    echo
    read -r -p "Pressione ENTER para continuar..."
  fi
}

banner
step "INICIANDO DEMO AUTOMATIZADA - BANCO LEGADO COBOL"
echo "Projeto   : ${PROJECT_DIR}"
echo "Container : ${CONTAINER_NAME}"
echo "Banco     : ${DB_NAME}"
echo "Modo demo : INTERACTIVE_DEMO=${INTERACTIVE_DEMO:-1}"
pause_if_interactive

step "VALIDANDO DIRETORIOS DO PROJETO"
[ -d "${PROJECT_DIR}" ] || { echo "Diretorio do projeto nao encontrado: ${PROJECT_DIR}"; exit 1; }
[ -d "${DOCKER_DIR}" ] || { echo "Diretorio Docker nao encontrado: ${DOCKER_DIR}"; exit 1; }
[ -d "${COBOL_DIR}" ] || { echo "Diretorio COBOL nao encontrado: ${COBOL_DIR}"; exit 1; }
[ -d "${OUTPUT_DIR}" ] || { echo "Diretorio output nao encontrado: ${OUTPUT_DIR}"; exit 1; }
echo "Diretorios validados com sucesso."
pause_if_interactive

step "VALIDANDO DEPENDENCIAS"
run_cmd "docker --version"
run_cmd "cobc -V | head -n 1"
pause_if_interactive

step "SUBINDO AMBIENTE DOCKER / POSTGRESQL"
cd "${DOCKER_DIR}" || exit 1
run_cmd "docker compose up -d"
pause_if_interactive

step "VALIDANDO CONTAINER EM EXECUCAO"
run_cmd "docker ps --filter name=${CONTAINER_NAME}"
pause_if_interactive

step "TESTANDO CONECTIVIDADE COM O POSTGRESQL"
run_cmd "docker exec ${CONTAINER_NAME} psql -U ${DB_USER} -d ${DB_NAME} -c 'SELECT current_database(), current_user;'"
pause_if_interactive

step "CONSULTANDO TABELA CLIENTES"
run_cmd "docker exec ${CONTAINER_NAME} psql -U ${DB_USER} -d ${DB_NAME} -c 'SELECT * FROM clientes;'"
pause_if_interactive

step "CONSULTANDO TABELA CONTAS"
run_cmd "docker exec ${CONTAINER_NAME} psql -U ${DB_USER} -d ${DB_NAME} -c 'SELECT * FROM contas;'"
pause_if_interactive

step "CONSULTANDO TABELA TRANSACOES"
run_cmd "docker exec ${CONTAINER_NAME} psql -U ${DB_USER} -d ${DB_NAME} -c 'SELECT * FROM transacoes;'"
pause_if_interactive

step "EXECUTANDO SELECT PRINCIPAL DO EXTRATO"
run_cmd "docker exec ${CONTAINER_NAME} psql -U ${DB_USER} -d ${DB_NAME} -c \"SELECT c.nome, co.saldo, t.tipo, t.valor, t.data FROM clientes c JOIN contas co ON c.id = co.cliente_id JOIN transacoes t ON co.id = t.conta_id WHERE c.id = 1 ORDER BY t.data DESC;\""
pause_if_interactive

step "COMPILANDO COBOL DE TELA"
cd "${COBOL_DIR}" || exit 1
run_cmd "cobc -x leitura_extrato.cob -o extrato"
pause_if_interactive

step "EXECUTANDO COBOL DE TELA"
run_cmd "./extrato"
pause_if_interactive

step "VALIDANDO EXISTENCIA DO COBOL DE RELATORIO"
if [ -f "${COBOL_DIR}/gera_relatorio_txt.cob" ]; then
  echo "Arquivo gera_relatorio_txt.cob encontrado."
else
  echo "Arquivo gera_relatorio_txt.cob NAO encontrado."
  echo "Vou seguir sem a etapa de geracao do relatorio TXT."
fi
pause_if_interactive

if [ -f "${COBOL_DIR}/gera_relatorio_txt.cob" ]; then
  step "COMPILANDO COBOL QUE GERA RELATORIO TXT"
  run_cmd "cobc -x gera_relatorio_txt.cob -o gera_relatorio_txt"
  pause_if_interactive

  step "EXECUTANDO COBOL QUE GERA RELATORIO TXT"
  run_cmd "./gera_relatorio_txt"
  pause_if_interactive
fi

step "VALIDANDO ARQUIVOS DE SAIDA"
run_cmd "ls -l ${OUTPUT_DIR}"
pause_if_interactive

if [ -f "${OUTPUT_DIR}/relatorio.txt" ]; then
  step "EXIBINDO relatorio.txt"
  run_cmd "cat ${OUTPUT_DIR}/relatorio.txt"
  pause_if_interactive
else
  echo "Arquivo relatorio.txt ainda nao existe."
fi

step "DEMO FINALIZADA COM SUCESSO"
echo "Tudo executado."
echo
echo "DICA:"
echo "- Para rodar sem pausas entre as etapas:"
echo "  INTERACTIVE_DEMO=0 ./demo_banco_legado_cobol_showcase.sh"
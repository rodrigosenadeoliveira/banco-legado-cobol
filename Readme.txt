/*  executar no terminal

chmod +x demo_banco_legado_cobol.sh
./demo_banco_legado_cobol.sh

*/


from pathlib import Path

content = """GUIA DE RECUPERACAO RAPIDA - BANCO LEGADO COBOL

CENARIO:
- Entrar no projeto
- Subir ambiente Docker/PostgreSQL
- Testar banco
- Rodar SELECT no PostgreSQL
- Compilar COBOL
- Executar COBOL de tela
- Executar COBOL que gera relatorio.txt

==================================================
1) ENTRAR NA PASTA DO PROJETO
==================================================

cd ~/Desktop/PROJETOS/Git/banco-legado-cobol

==================================================
2) SUBIR O AMBIENTE (POSTGRESQL)
==================================================

cd infra/docker
docker compose up -d

==================================================
3) VALIDAR SE O CONTAINER SUBIU
==================================================

docker ps

==================================================
4) ENTRAR NO POSTGRESQL
==================================================

docker exec -it banco-postgres psql -U admin -d banco

==================================================
5) TESTAR O BANCO COM SELECTS
==================================================

SELECT * FROM clientes;
SELECT * FROM contas;
SELECT * FROM transacoes;

==================================================
6) RODAR O SELECT PRINCIPAL DO EXTRATO
==================================================

SELECT 
    c.nome,
    co.saldo,
    t.tipo,
    t.valor,
    t.data
FROM clientes c
JOIN contas co ON c.id = co.cliente_id
JOIN transacoes t ON co.id = t.conta_id
WHERE c.id = 1
ORDER BY t.data DESC;

==================================================
7) SAIR DO POSTGRESQL
==================================================

\\q

==================================================
8) IR PARA A PASTA DO COBOL
==================================================

cd ../../cobol-core/src

==================================================
9) COMPILAR E EXECUTAR O COBOL DE TELA
==================================================

cobc -x leitura_extrato.cob -o extrato
./extrato

==================================================
10) COMPILAR E EXECUTAR O COBOL QUE GERA RELATORIO TXT
==================================================

cobc -x gera_relatorio_txt.cob -o gera_relatorio_txt
./gera_relatorio_txt

==================================================
11) VALIDAR O ARQUIVO GERADO
==================================================

cat ../../output/relatorio.txt

==================================================
12) PARAR O AMBIENTE (OPCIONAL)
==================================================

cd ../../infra/docker
docker compose down

==================================================
FLUXO COMPLETO EM BLOCO UNICO
==================================================

cd ~/Desktop/PROJETOS/Git/banco-legado-cobol
cd infra/docker
docker compose up -d
docker ps
docker exec -it banco-postgres psql -U admin -d banco

-- dentro do PostgreSQL:
SELECT * FROM clientes;
SELECT * FROM contas;
SELECT * FROM transacoes;

SELECT 
    c.nome,
    co.saldo,
    t.tipo,
    t.valor,
    t.data
FROM clientes c
JOIN contas co ON c.id = co.cliente_id
JOIN transacoes t ON co.id = t.conta_id
WHERE c.id = 1
ORDER BY t.data DESC;

\\q

cd ../../cobol-core/src
cobc -x leitura_extrato.cob -o extrato
./extrato
cobc -x gera_relatorio_txt.cob -o gera_relatorio_txt
./gera_relatorio_txt
cat ../../output/relatorio.txt

==================================================
OBSERVACOES RAPIDAS
==================================================

- Se Docker nao subir:
  docker compose logs

- Se o COBOL nao compilar:
  cobc -V

- Se quiser limpar tela:
  clear

- Se der erro de caminho do arquivo:
  pwd
  ls ../../output
"""

path = Path("/mnt/data/guia_recuperacao_banco_legado_cobol.txt")
path.write_text(content, encoding="utf-8")
print(f"Arquivo criado em: {path}")

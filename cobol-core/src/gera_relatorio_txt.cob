       IDENTIFICATION DIVISION.
       PROGRAM-ID. GERA-RELATORIO.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARQ-EXTRATO ASSIGN TO '../../output/extrato.csv'
           ORGANIZATION IS LINE SEQUENTIAL.

           SELECT ARQ-RELATORIO ASSIGN TO '../../output/relatorio.txt'
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.
       FD ARQ-EXTRATO.
       01 REGISTRO-ENTRADA PIC X(200).

       FD ARQ-RELATORIO.
       01 REGISTRO-SAIDA PIC X(200).

       WORKING-STORAGE SECTION.

       01 WS-EOF PIC X VALUE 'N'.

       01 WS-NOME            PIC X(100).
       01 WS-SALDO           PIC 9(10)V99.
       01 WS-TIPO            PIC X(10).
       01 WS-VALOR           PIC 9(10)V99.
       01 WS-DATA            PIC X(30).

       01 WS-CLIENTE         PIC X(100) VALUE SPACES.
       01 WS-SALDO-INICIAL   PIC 9(10)V99 VALUE 0.
       01 WS-SALDO-FINAL     PIC 9(10)V99 VALUE 0.

       01 WS-TOTAL-CREDITO   PIC 9(10)V99 VALUE 0.
       01 WS-TOTAL-DEBITO    PIC 9(10)V99 VALUE 0.

       01 WS-VALOR-FMT       PIC Z,ZZZ,ZZZ,ZZ9.99.
       01 WS-CREDITO-FMT     PIC Z,ZZZ,ZZZ,ZZ9.99.
       01 WS-DEBITO-FMT      PIC Z,ZZZ,ZZZ,ZZ9.99.
       01 WS-SALDO-FMT       PIC Z,ZZZ,ZZZ,ZZ9.99.
       01 WS-SALDO-FINAL-FMT PIC Z,ZZZ,ZZZ,ZZ9.99.

       PROCEDURE DIVISION.

       MAIN.

           OPEN INPUT ARQ-EXTRATO
           OPEN OUTPUT ARQ-RELATORIO

           PERFORM ESCREVER-CABECALHO

           PERFORM UNTIL WS-EOF = 'S'
               READ ARQ-EXTRATO
                   AT END
                       MOVE 'S' TO WS-EOF
                   NOT AT END
                       PERFORM PROCESSAR-LINHA
               END-READ
           END-PERFORM

           COMPUTE WS-SALDO-FINAL =
               WS-SALDO-INICIAL + WS-TOTAL-CREDITO - WS-TOTAL-DEBITO

           PERFORM ESCREVER-RESUMO

           CLOSE ARQ-EXTRATO
           CLOSE ARQ-RELATORIO

           DISPLAY "Relatorio gerado em ../../output/relatorio.txt"

           STOP RUN.

       ESCREVER-CABECALHO.

           MOVE ALL SPACES TO REGISTRO-SAIDA
           MOVE "==============================" TO REGISTRO-SAIDA
           WRITE REGISTRO-SAIDA

           MOVE ALL SPACES TO REGISTRO-SAIDA
           MOVE "      EXTRATO BANCARIO" TO REGISTRO-SAIDA
           WRITE REGISTRO-SAIDA

           MOVE ALL SPACES TO REGISTRO-SAIDA
           MOVE "==============================" TO REGISTRO-SAIDA
           WRITE REGISTRO-SAIDA

           MOVE SPACES TO REGISTRO-SAIDA
           WRITE REGISTRO-SAIDA.

       PROCESSAR-LINHA.

           IF REGISTRO-ENTRADA(1:4) = "nome"
               EXIT PARAGRAPH
           END-IF

           UNSTRING REGISTRO-ENTRADA
               DELIMITED BY ";"
               INTO WS-NOME
                    WS-SALDO
                    WS-TIPO
                    WS-VALOR
                    WS-DATA
           END-UNSTRING

           IF WS-CLIENTE = SPACES
               MOVE WS-NOME  TO WS-CLIENTE
               MOVE WS-SALDO TO WS-SALDO-INICIAL
               MOVE WS-SALDO-INICIAL TO WS-SALDO-FMT

               MOVE ALL SPACES TO REGISTRO-SAIDA
               STRING
                   "Cliente       : " DELIMITED BY SIZE
                   WS-CLIENTE      DELIMITED BY SPACES
                   INTO REGISTRO-SAIDA
               END-STRING
               WRITE REGISTRO-SAIDA

               MOVE ALL SPACES TO REGISTRO-SAIDA
               STRING
                   "Saldo Inicial : " DELIMITED BY SIZE
                   WS-SALDO-FMT      DELIMITED BY SIZE
                   INTO REGISTRO-SAIDA
               END-STRING
               WRITE REGISTRO-SAIDA

               MOVE SPACES TO REGISTRO-SAIDA
               WRITE REGISTRO-SAIDA

               MOVE ALL SPACES TO REGISTRO-SAIDA
               MOVE "Transacoes:" TO REGISTRO-SAIDA
               WRITE REGISTRO-SAIDA
           END-IF

           MOVE WS-VALOR TO WS-VALOR-FMT

           IF WS-TIPO = "CREDITO"
               ADD WS-VALOR TO WS-TOTAL-CREDITO
               MOVE ALL SPACES TO REGISTRO-SAIDA
               STRING
                   "+ "         DELIMITED BY SIZE
                   WS-VALOR-FMT DELIMITED BY SIZE
                   " (CREDITO)" DELIMITED BY SIZE
                   INTO REGISTRO-SAIDA
               END-STRING
               WRITE REGISTRO-SAIDA
           ELSE
               ADD WS-VALOR TO WS-TOTAL-DEBITO
               MOVE ALL SPACES TO REGISTRO-SAIDA
               STRING
                   "- "        DELIMITED BY SIZE
                   WS-VALOR-FMT DELIMITED BY SIZE
                   " (DEBITO)" DELIMITED BY SIZE
                   INTO REGISTRO-SAIDA
               END-STRING
               WRITE REGISTRO-SAIDA
           END-IF.

       ESCREVER-RESUMO.

           MOVE WS-TOTAL-CREDITO TO WS-CREDITO-FMT
           MOVE WS-TOTAL-DEBITO  TO WS-DEBITO-FMT
           MOVE WS-SALDO-FINAL   TO WS-SALDO-FINAL-FMT

           MOVE SPACES TO REGISTRO-SAIDA
           WRITE REGISTRO-SAIDA

           MOVE ALL SPACES TO REGISTRO-SAIDA
           MOVE "==============================" TO REGISTRO-SAIDA
           WRITE REGISTRO-SAIDA

           MOVE ALL SPACES TO REGISTRO-SAIDA
           MOVE "RESUMO" TO REGISTRO-SAIDA
           WRITE REGISTRO-SAIDA

           MOVE ALL SPACES TO REGISTRO-SAIDA
           STRING
               "Total Creditos: " DELIMITED BY SIZE
               WS-CREDITO-FMT     DELIMITED BY SIZE
               INTO REGISTRO-SAIDA
           END-STRING
           WRITE REGISTRO-SAIDA

           MOVE ALL SPACES TO REGISTRO-SAIDA
           STRING
               "Total Debitos : " DELIMITED BY SIZE
               WS-DEBITO-FMT      DELIMITED BY SIZE
               INTO REGISTRO-SAIDA
           END-STRING
           WRITE REGISTRO-SAIDA

           MOVE ALL SPACES TO REGISTRO-SAIDA
           STRING
               "Saldo Final   : " DELIMITED BY SIZE
               WS-SALDO-FINAL-FMT DELIMITED BY SIZE
               INTO REGISTRO-SAIDA
           END-STRING
           WRITE REGISTRO-SAIDA

           MOVE ALL SPACES TO REGISTRO-SAIDA
           MOVE "==============================" TO REGISTRO-SAIDA
           WRITE REGISTRO-SAIDA.
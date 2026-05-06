       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXTRATO.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARQ-EXTRATO ASSIGN TO '../../output/extrato.csv'
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.
       FD ARQ-EXTRATO.
       01 REGISTRO PIC X(200).

       WORKING-STORAGE SECTION.

       01 WS-EOF PIC X VALUE 'N'.

       01 WS-NOME            PIC X(100).
       01 WS-SALDO           PIC 9(10)V99.
       01 WS-TIPO            PIC X(10).
       01 WS-VALOR           PIC 9(10)V99.
       01 WS-DATA            PIC X(30).

       01 WS-CLIENTE         PIC X(100) VALUE SPACES.
       01 WS-SALDO-INICIAL   PIC 9(10)V99 VALUE 0.

       01 WS-TOTAL-CREDITO   PIC 9(10)V99 VALUE 0.
       01 WS-TOTAL-DEBITO    PIC 9(10)V99 VALUE 0.
       01 WS-SALDO-FINAL     PIC 9(10)V99 VALUE 0.

       01 WS-VALOR-FMT       PIC Z,ZZZ,ZZZ,ZZ9.99.
       01 WS-CREDITO-FMT     PIC Z,ZZZ,ZZZ,ZZ9.99.
       01 WS-DEBITO-FMT      PIC Z,ZZZ,ZZZ,ZZ9.99.
       01 WS-SALDO-FMT       PIC Z,ZZZ,ZZZ,ZZ9.99.
       01 WS-SALDO-FINAL-FMT PIC Z,ZZZ,ZZZ,ZZ9.99.

       PROCEDURE DIVISION.

       MAIN.

           OPEN INPUT ARQ-EXTRATO

           DISPLAY "=============================="
           DISPLAY "      EXTRATO BANCARIO"
           DISPLAY "=============================="
           DISPLAY " "

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

           PERFORM MOSTRAR-RESUMO

           CLOSE ARQ-EXTRATO

           STOP RUN.

       PROCESSAR-LINHA.

           IF REGISTRO(1:4) = "nome"
               EXIT PARAGRAPH
           END-IF

           UNSTRING REGISTRO
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

               DISPLAY "Cliente       : " WS-CLIENTE
               DISPLAY "Saldo Inicial : " WS-SALDO-FMT
               DISPLAY " "
               DISPLAY "Transacoes:"
           END-IF

           MOVE WS-VALOR TO WS-VALOR-FMT

           IF WS-TIPO = "CREDITO"
               ADD WS-VALOR TO WS-TOTAL-CREDITO
               DISPLAY "+ " WS-VALOR-FMT " (CREDITO)"
           ELSE
               ADD WS-VALOR TO WS-TOTAL-DEBITO
               DISPLAY "- " WS-VALOR-FMT " (DEBITO)"
           END-IF.

       MOSTRAR-RESUMO.

           MOVE WS-TOTAL-CREDITO TO WS-CREDITO-FMT
           MOVE WS-TOTAL-DEBITO  TO WS-DEBITO-FMT
           MOVE WS-SALDO-FINAL   TO WS-SALDO-FINAL-FMT

           DISPLAY " "
           DISPLAY "=============================="
           DISPLAY "RESUMO"
           DISPLAY "Total Creditos: " WS-CREDITO-FMT
           DISPLAY "Total Debitos : " WS-DEBITO-FMT
           DISPLAY "Saldo Final   : " WS-SALDO-FINAL-FMT
           DISPLAY "==============================".
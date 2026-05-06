INSERT INTO clientes (nome)
VALUES ('RODRIGO OLIVEIRA');

INSERT INTO contas (cliente_id, saldo)
VALUES (1, 12500.00);

INSERT INTO transacoes (conta_id, tipo, valor)
VALUES 
(1, 'DEBITO', 200.00),
(1, 'CREDITO', 1000.00),
(1, 'DEBITO', 50.00);
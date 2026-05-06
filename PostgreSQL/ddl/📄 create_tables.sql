CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE contas (
    id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(id),
    saldo DECIMAL(12,2) NOT NULL
);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    conta_id INT REFERENCES contas(id),
    tipo VARCHAR(10) CHECK (tipo IN ('DEBITO', 'CREDITO')),
    valor DECIMAL(12,2),
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
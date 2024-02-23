# ATM - Caixa eletrônico

Aplicação deve ser executada no terminal

**Iniciando container**

```bash
docker compose up -d
```

**Após iniciar é possível visualizar os logs**

```bash
docker logs atm_app -f
```

**Executando aplicação**

```bash
docker exec -it atm_app ruby main.rb
```

**Orientação:**
- CTRL + C: Limpa tela
- Para sair da aplicação digite 'fim'

**Testes**

Testes sem gerar relatório

```bash
docker exec -it atm_app make test
```

Testes com geração de relatório

```bash
docker exec -it atm_app make coverage
```

*Obs.:* Relatório é gerado na pasta `coverage` na raiz do projeto
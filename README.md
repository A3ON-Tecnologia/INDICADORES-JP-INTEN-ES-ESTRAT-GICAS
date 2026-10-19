# Dashboard de Indicadores JP Contábil — atualização automática

Todo dia às 02:00 (Brasília) o GitHub busca os dados na API do Acessórias, gera o painel e publica no GitHub Pages.
Não há banco de dados nem servidor: os dados ficam dentro do próprio HTML, criptografados com a senha do painel.

- **Janela de dados:** mês atual + 2 meses anteriores (entregas pelo prazo, solicitações pela abertura, processos iniciados ou com conclusão/previsão no período).
- **Abre por padrão em:** competência do mês anterior.
- **Duração de cada atualização:** cerca de 10 a 20 minutos (limite da API: 100 chamadas por minuto).

## Arquivos

| Arquivo | Onde fica no repositório |
|---|---|
| `jp_dashboard.py` | raiz do repositório |
| `atualizar-dashboard.yml` | `.github/workflows/atualizar-dashboard.yml` |
| `README.md` | raiz do repositório |

## Passo a passo

1. **Crie o repositório.** Em github.com → **New repository** → nome, por exemplo `indicadores-jp` → **Public** → **Create repository**.
   No plano gratuito o GitHub Pages só funciona em repositório público. Não há risco: o repositório guarda só o script, sem dados e sem chaves. Os dados ficam no site, protegidos pela senha.
2. **Envie os arquivos.** No repositório, clique em **Add file → Upload files** e envie `jp_dashboard.py` e `README.md`.
   Depois clique em **Add file → Create new file**, digite o nome `.github/workflows/atualizar-dashboard.yml`, cole o conteúdo do arquivo `.yml` e clique em **Commit changes**.
3. **Cadastre os dois segredos.** Em **Settings → Secrets and variables → Actions → New repository secret**:
   - `ACESSORIAS_TOKEN`: o token da API do Acessórias (gere um novo em Acessórias → engrenagem → API Token).
   - `PAINEL_SENHA`: a senha que a equipe vai digitar para abrir o painel. Use pelo menos 12 caracteres.
4. **Ligue o GitHub Pages.** Em **Settings → Pages → Build and deployment → Source**, escolha **GitHub Actions**.
5. **Rode a primeira vez.** Em **Actions → Atualizar dashboard → Run workflow**. Acompanhe até ficar verde (cerca de 10 a 20 minutos).
6. **Abra o painel.** O endereço aparece em **Settings → Pages** e no resultado da execução, no formato `https://SEU-USUARIO.github.io/indicadores-jp/`. Digite a senha. O painel lembra a senha até fechar a aba.

A partir daí ele se atualiza sozinho todo dia às 02:00.

## Manutenção

- **Trocar a senha ou o token:** edite o segredo em Settings → Secrets. A mudança vale na próxima atualização (ou rode **Run workflow** para aplicar na hora).
- **Ver se atualizou:** o cabeçalho do painel mostra "Atualizado em …". O arquivo `ultima-atualizacao.txt` do repositório também registra a data.
- **Falhou?** Em **Actions**, a execução fica vermelha e o GitHub envia um e-mail. Causas comuns: token expirado ou trocado (erro "Token inválido") ou instabilidade da API (rode de novo).
- **Agendamento parado:** o GitHub desliga agendamentos de repositórios sem atividade por 60 dias. O workflow evita isso gravando `ultima-atualizacao.txt` a cada execução.
- **Testar no computador:**
  ```
  pip install cryptography
  ACESSORIAS_TOKEN=seu_token PAINEL_SENHA=sua_senha python3 jp_dashboard.py --out index.html
  ```
  Sem `PAINEL_SENHA`, o arquivo sai sem senha. Use assim só para arquivos que não vão para a internet.

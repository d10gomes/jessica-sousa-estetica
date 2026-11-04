# Jéssica Sousa Estética

Site do Centro Estético Jéssica Sousa e do Método Clean Pro, com avaliação online que qualifica e cadastra novas clientes.

## Estrutura

- `index.html`: página principal (inclui a avaliação online, o aviso de cookies e a política de privacidade)
- `painel/`: painel privado para a equipe ver e acompanhar as avaliações (endereço `/painel`)
- `supabase/schema.sql`: estrutura do banco de dados e regras de acesso
- `img/` e `video/`: imagens, logos e depoimentos

## Como a avaliação online funciona

1. Todos os botões "Agendar avaliação" abrem um questionário de 7 perguntas.
2. As respostas são classificadas:
   - **Elegibilidade:** apta, avaliação especial (Roacutan ou rosácea) ou não indicado (gestante ou tratamento oncológico).
   - **Temperatura:** quente (quer começar já e vem presencialmente), morna, fria (só pesquisando) ou contraindicado.
3. Com o consentimento da cliente, as respostas são salvas no Supabase.
4. A cliente envia o resumo pronto para o WhatsApp de atendimento.

## Ligar o banco de dados (uma vez)

1. Crie um projeto no Supabase (região São Paulo, `sa-east-1`).
2. Abra **SQL Editor**, cole o conteúdo de `supabase/schema.sql` e clique em **Run**.
3. Em **Authentication → Sign In / Providers**, desligue **Allow new users to sign up**.
4. Em **Authentication → Users → Add user**, crie o login da Jéssica (e-mail e senha).
5. Autorize esse e-mail no painel, no **SQL Editor**:
   `insert into public.admins (email) values ('email-da-jessica@exemplo.com');`
6. O projeto `jessica-sousa-leads` (São Paulo) já está ligado: `SUPABASE_URL` e `SUPABASE_KEY` estão preenchidos em `index.html` e `painel/index.html`. A chave usada é a pública (anon), que só permite cadastrar avaliações.

## Medição (opcional)

Preencha `META_PIXEL_ID` e `GA4_ID` em `index.html`. Eles só carregam para quem aceita os cookies.
Eventos enviados: `IniciouAvaliacao`, `Lead` (avaliação concluída) e `Contact` (clique para o WhatsApp).

## Links rastreados

Use links com UTM para saber de onde vêm as clientes (aparece no painel em "Origem"):

- Bio do Instagram: `https://SEU-DOMINIO/?utm_source=instagram&utm_medium=bio`
- Stories: `https://SEU-DOMINIO/?utm_source=instagram&utm_medium=stories`
- Anúncios: `https://SEU-DOMINIO/?utm_source=meta&utm_medium=anuncio&utm_campaign=NOME-DA-CAMPANHA`
- Abrir direto a avaliação: acrescente `#avaliacao` ao final do link.

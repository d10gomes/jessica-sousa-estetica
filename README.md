# Jéssica Sousa Estética

Site do Centro Estético Jéssica Sousa e do Método Clean Pro, com captação e qualificação de clientes, parcerias, métricas próprias e painel de gestão.

- Site: https://jessica-sousa-estetica.vercel.app
- Painel (restrito): https://jessica-sousa-estetica.vercel.app/painel

## Seções da página

1. Abertura: foto sem fundo, prova social (+1.000 mulheres atendidas), credenciais (5 anos, Clean Pro, pós em Saúde Estética)
2. Conheça Jéssica Sousa: trajetória, formação e atendimento feminino e masculino
3. Entenda o melasma: o que é e o que piora (sol, calor, hormônios, predisposição)
4. O que é o Método Clean Pro
5. Como funciona: as 5 etapas (inclui kit home care)
6. Para quem é indicado + atendimento para homens
7. Provas sociais: vídeos, antes e depois e depoimentos por objeção
8. Quando não é indicado (contraindicações)
9. Sua primeira avaliação + perguntas frequentes (valores só pelo WhatsApp)
11. Fechamento, unidades (Palmeiras – Praça Souto Soares, Centro; Seabra; Ibitiara – BA) e rodapé

Também: aviso de cookies, política de privacidade (LGPD), avaliação online de 7 perguntas e barra fixa de agendamento no celular.

## Estrutura

- `index.html`: página principal
- `painel/`: painel com Avaliações, Parcerias e Métricas do site
- `parcerias/`: página separada de parcerias (/parcerias)
- `privacidade/`: página da Política de Privacidade (/privacidade)
- `api/capi.js`: API de Conversões da Meta (precisa de META_PIXEL_ID e META_CAPI_TOKEN na Vercel)
- `img/og.jpg`: imagem de prévia ao compartilhar o link (1200×630)
- `api/geo.js`: cidade/estado aproximados da visita (sem guardar IP)
- `vercel.json`: links curtos rastreados (/bio, /stories, /avaliar, /destaque, /direct, /whats)
- `supabase/schema.sql`: estrutura do banco (projeto `jessica-sousa-leads`, São Paulo)
- `img/` e `video/`: imagens, logos e depoimentos

## Banco de dados (Supabase · jessica-sousa-leads)

- `leads`: avaliações online, com temperatura, elegibilidade, status e vínculo com o histórico de navegação
- `parcerias`: propostas de parceria
- `eventos`: métricas de navegação (só de quem aceita cookies)
- `admins`: e-mails com acesso ao painel
- Funções do painel: `painel_metricas`, `painel_geo`, `painel_visitantes`, `painel_historico_leads` (recusam quem não é admin)

O site só consegue cadastrar dados; ler exige login de um e-mail listado em `admins`.

## Links rastreados

| Uso | Link |
|---|---|
| Bio do Instagram | /bio |
| Stories | /stories |
| Stories abrindo a avaliação | /avaliar |
| Destaques | /destaque |
| Direct | /direct |
| WhatsApp (status/listas) | /whats |
| Anúncios | /?utm_source=meta&utm_medium=anuncio&utm_campaign=NOME |
| Parcerias | /parcerias |

## Pendências

- Política de privacidade: CNPJ/CPF, encarregado de dados e e-mail de contato
- Domínio próprio (sugestão: jessicasousaestetica.com.br)
- Meta: preencher META_PIXEL_ID em index.html e parcerias/index.html, e META_PIXEL_ID + META_CAPI_TOKEN nas variáveis da Vercel
- Endereços e mapas de Seabra e Ibitiara
- Horários de atendimento (schema e site)
- Confirmar registro no CRBM

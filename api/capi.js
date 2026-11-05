// API de Conversões da Meta: envia, pelo servidor, os mesmos eventos do Pixel.
// Só funciona com as variáveis META_PIXEL_ID e META_CAPI_TOKEN configuradas na Vercel
// (Settings → Environment Variables). Sem elas, não faz nada.
// O site só chama esta rota quando a visitante aceitou os cookies.
const PERMITIDOS = ['PageView', 'ViewContent', 'Lead', 'Contact'];

module.exports = async (req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  const pixel = process.env.META_PIXEL_ID, token = process.env.META_CAPI_TOKEN;
  if (req.method !== 'POST' || !pixel || !token) return res.status(204).end();
  let b = req.body;
  if (typeof b === 'string') { try { b = JSON.parse(b); } catch (e) { b = {}; } }
  b = b || {};
  if (!PERMITIDOS.includes(b.event_name)) return res.status(400).json({ erro: 'evento inválido' });
  const corta = (v, n) => (typeof v === 'string' ? v.slice(0, n) : undefined);
  const ip = String(req.headers['x-forwarded-for'] || '').split(',')[0].trim() || undefined;
  const evento = {
    event_name: b.event_name,
    event_time: Math.floor(Date.now() / 1000),
    event_id: corta(b.event_id, 64),
    action_source: 'website',
    event_source_url: corta(b.event_source_url, 500),
    user_data: { client_ip_address: ip, client_user_agent: corta(req.headers['user-agent'], 400), fbp: corta(b.fbp, 120), fbc: corta(b.fbc, 200) },
    custom_data: typeof b.custom_data === 'object' && b.custom_data ? Object.fromEntries(Object.entries(b.custom_data).slice(0, 8).map(([k, v]) => [String(k).slice(0, 40), String(v).slice(0, 80)])) : undefined
  };
  try {
    const r = await fetch(`https://graph.facebook.com/v19.0/${encodeURIComponent(pixel)}/events?access_token=${encodeURIComponent(token)}`, {
      method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ data: [evento] })
    });
    return res.status(r.ok ? 200 : 502).json({ ok: r.ok });
  } catch (e) {
    return res.status(502).json({ ok: false });
  }
};

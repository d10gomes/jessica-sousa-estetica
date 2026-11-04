// Localização aproximada da visita, a partir dos dados de rede que a Vercel já fornece.
// Não guarda nem devolve o IP: só cidade, estado e país.
module.exports = (req, res) => {
  const h = req.headers;
  const dec = v => { try { return v ? decodeURIComponent(v) : null; } catch (e) { return v || null; } };
  res.setHeader('Cache-Control', 'no-store');
  res.status(200).json({
    cidade: dec(h['x-vercel-ip-city']),
    estado: h['x-vercel-ip-country-region'] || null,
    pais: h['x-vercel-ip-country'] || null
  });
};

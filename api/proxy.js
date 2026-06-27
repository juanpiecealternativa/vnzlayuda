export default async function handler(req, res) {
  const url = req.query.url;
  if (!url) return res.status(400).json({ error: 'Falta ?url=' });

  try {
    const r = await fetch(url, { headers: { 'Accept': 'application/json' }, signal: AbortSignal.timeout(20000) });
    if (!r.ok) return res.status(r.status).json({ error: 'HTTP ' + r.status });

    const contentType = r.headers.get('content-type') || '';
    if (contentType.includes('application/json')) {
      const data = await r.json();
      res.setHeader('Access-Control-Allow-Origin', '*');
      return res.json(data);
    }

    const text = await r.text();
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Content-Type', contentType || 'text/plain');
    return res.status(r.status).send(text);
  } catch (e) {
    return res.status(502).json({ error: e.message });
  }
}

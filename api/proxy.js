const BROWSER_HEADERS = {
  'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,application/json;q=0.8,*/*;q=0.7',
  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36',
  'Accept-Language': 'es-ES,es;q=0.9,en;q=0.8',
  'Cache-Control': 'no-cache',
  'Pragma': 'no-cache',
  'Sec-Fetch-Dest': 'document',
  'Sec-Fetch-Mode': 'navigate',
  'Sec-Fetch-Site': 'none',
  'Sec-Fetch-User': '?1',
  'Upgrade-Insecure-Requests': '1',
};

export default async function handler(req, res) {
  const url = req.query.url;
  if (!url) return res.status(400).json({ error: 'Falta ?url=' });

  const headers = { ...BROWSER_HEADERS };
  if (typeof url === 'string' && (url.includes('/api/') || url.includes('.json'))) {
    headers['Accept'] = 'application/json, text/plain, */*';
    headers['Sec-Fetch-Dest'] = 'empty';
    headers['Sec-Fetch-Mode'] = 'cors';
    delete headers['Sec-Fetch-User'];
    delete headers['Upgrade-Insecure-Requests'];
  }

  try {
    const r = await fetch(url, { headers, signal: AbortSignal.timeout(20000) });
    if (!r.ok) {
      const body = await r.text().catch(() => '');
      return res.status(r.status).json({ error: 'HTTP ' + r.status, body: body.slice(0, 500) });
    }

    const contentType = r.headers.get('content-type') || '';
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET');

    if (contentType.includes('application/json')) {
      const data = await r.json();
      return res.json(data);
    }

    const text = await r.text();
    res.setHeader('Content-Type', contentType || 'text/plain;charset=utf-8');
    return res.status(r.status).send(text);
  } catch (e) {
    return res.status(502).json({ error: e.message });
  }
}

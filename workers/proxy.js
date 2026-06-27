export default {
  async fetch(request) {
    const url = new URL(request.url);
    const target = url.searchParams.get('url');
    if (!target) return new Response('Falta ?url=', { status: 400 });

    const headers = {
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,application/json;q=0.8,*/*;q=0.7',
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36',
      'Accept-Language': 'es-ES,es;q=0.9,en;q=0.8',
      'Referer': 'https://www.huellascan.com/',
    };

    if (target.includes('/api/') || target.includes('.json')) {
      headers['Accept'] = 'application/json, text/plain, */*';
    }

    const resp = await fetch(target, { headers, signal: AbortSignal.timeout(20000) });
    const body = await resp.text();
    const contentType = resp.headers.get('content-type') || 'text/plain;charset=utf-8';

    return new Response(body, {
      status: resp.status,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': contentType,
      },
    });
  }
};

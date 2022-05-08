const path = require('path')
const http = require('http')

const clients = []

http.createServer((req, res) => {
  return clients.push(
    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Access-Control-Allow-Origin': '*',
      Connection: 'keep-alive'
    })
  )
}).listen(8082)

async function builder () {
  const result = await require('esbuild').build({
    entryPoints: ['application.js'],
    bundle: true,
    outdir: path.join(process.cwd(), 'app/assets/builds'),
    absWorkingDir: path.join(process.cwd(), 'app/javascript'),
    incremental: true,
    banner: {
      js: ' (() => new EventSource("http://localhost:8082").onmessage = () => location.reload())();'
    }
  })
}
builder()

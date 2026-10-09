from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write(b"Я ХОЧУ ИЗМЕНИТЬ ЭТОТ ТЕКСТ К ХУЯМ ")

server = HTTPServer(("0.0.0.0", 8000), Handler)

print("Backend started on port 8000")

server.serve_forever()

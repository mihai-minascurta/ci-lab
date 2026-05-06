from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"healthy\n")
            return

        self.send_response(404)
        self.end_headers()
        self.wfile.write(b"not found\n")

print("API listening on 0.0.0.0:5050", flush=True)
HTTPServer(("", 5050), Handler).serve_forever()

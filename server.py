from threading import Thread
from watchgod import watch, RegExpWatcher
from websocket_server import WebsocketServer
from pathlib import Path
import http.server
import socketserver
import os
import signal
import subprocess

# WebSocket Server
wsServer = WebsocketServer(8080, host="0.0.0.0")
def runWebSockServer():
	print("WebSocket server started at localhost:8080")
	wsServer.run_forever()

# HTTP server
class HTTPHandler(http.server.SimpleHTTPRequestHandler):
	def do_GET(self):
		if "html" in self.headers["accept"]:
			self.send_response(200)
			self.send_header("Content-type", "text/html")
			self.end_headers()
			
			hostname = subprocess.run("hostname", stdout=subprocess.PIPE).stdout.decode('utf-8').rstrip()
			path = self.path + ("/index.html" if ".html" not in self.path else "")
			html = Path("." + path).read_text()
			html = html.replace("</body></html>", "<script>let ws = new WebSocket('ws://" + hostname + ".local:8080/'); ws.onmessage = function(e) {window.location.reload(true)}</script></body></html>")
			self.wfile.write(bytes(html, "utf8"))
			return
		http.server.SimpleHTTPRequestHandler.do_GET(self)
		
		
socketserver.TCPServer.allow_reuse_address = True
handler = HTTPHandler
httpServer = socketserver.TCPServer(("", 8000), handler)
def runHttpServer():
	print("HTTP server started at localhost:8000")
	os.chdir("Output")
	httpServer.serve_forever()


if __name__ == '__main__':
	# Start up servers
	webSockServerThread = Thread(target=runWebSockServer)
	httpServerThread = Thread(target=runHttpServer)
	webSockServerThread.start()
	httpServerThread.start()
	
	# Set up teardown
	def shutdown(num, frame):
		signal.pthread_kill(webSockServerThread.ident, 1)
		signal.pthread_kill(httpServerThread.ident, 1)
	signal.signal(signal.SIGINT, shutdown)

	# Watch project for changes
	print('Watching files...')
	
	# NOTE: watchgod matches against file paths that start with the relative root characters (e.g. "../")️
	# NOTE: I'm only using watchgod because watchdog was triggering too many change events (also why I was using kqueue instead of NSEvents with fswatch)
	for changes in watch('..', watcher_cls=RegExpWatcher, watcher_kwargs=dict(re_files=r'^\.\.\/(?!\.|Output).*$')):
		# Build
		os.system("swift run PeteSchaffner --livereload")
		# Reload browsers
		wsServer.send_message_to_all("reload")
		
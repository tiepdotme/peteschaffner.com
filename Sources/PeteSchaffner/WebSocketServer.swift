#if !os(Linux)
import Network

final class WebSocketServer {
    let port: NWEndpoint.Port
    let listener: NWListener
    let parameters: NWParameters

    var connectionsByID: [Int: WebSocketServerConnection] = [:]

    init(port: UInt16) {
        self.port = NWEndpoint.Port(rawValue: port)!
        parameters = NWParameters(tls: nil)
        parameters.allowLocalEndpointReuse = true
        parameters.includePeerToPeer = true
        let wsOptions = NWProtocolWebSocket.Options()
        wsOptions.autoReplyPing = true
        parameters.defaultProtocolStack.applicationProtocols.insert(wsOptions, at: 0)
        listener = try! NWListener(using: parameters, on: self.port)
    }

    func start() throws {
        print("Server starting...")
        listener.stateUpdateHandler = self.stateDidChange(to:)
        listener.newConnectionHandler = self.didAccept(nwConnection:)
        listener.start(queue: .main)
    }

    func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .ready:
            print("Server ready.")
        case .failed(let error):
            print("Server failure, error: \(error.localizedDescription)")
            exit(EXIT_FAILURE)
        default:
            break
        }
    }

    private func didAccept(nwConnection: NWConnection) {
        let connection = WebSocketServerConnection(nwConnection: nwConnection)
        connectionsByID[connection.id] = connection
        
        connection.start()
        
        connection.didStopCallback = { err in
            if let err = err {
                print(err)
            }
            self.connectionDidStop(connection)
        }
        
        print("server did open connection \(connection.id)")
    }

    private func connectionDidStop(_ connection: WebSocketServerConnection) {
        self.connectionsByID.removeValue(forKey: connection.id)
        print("server did close connection \(connection.id)")
    }

    private func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        for connection in self.connectionsByID.values {
            connection.didStopCallback = nil
            connection.stop()
        }
        self.connectionsByID.removeAll()
    }
}
#endif

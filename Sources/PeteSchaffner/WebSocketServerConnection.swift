#if !os(Linux)
import Foundation
import Network

final class WebSocketServerConnection {
    private static var nextID: Int = 0
    let connection: NWConnection
    let id: Int

    init(nwConnection: NWConnection) {
        connection = nwConnection
        id = WebSocketServerConnection.nextID
        WebSocketServerConnection.nextID += 1
    }
    
    deinit {
        print("deinit")
    }

    var didStopCallback: ((Error?) -> Void)? = nil
    var didReceive: ((Data) -> ())? = nil

    func start() {
        print("connection \(id) will start")
        connection.stateUpdateHandler = self.stateDidChange(to:)
        setupReceive()
        connection.start(queue: .main)
    }

    private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .waiting(let error):
            connectionDidFail(error: error)
        case .ready:
            print("connection \(id) ready")
        case .failed(let error):
            connectionDidFail(error: error)
        default:
            break
        }
    }

    private func setupReceive() {
        connection.receiveMessage() { (data, context, isComplete, error) in
            if let data = data, let context = context, !data.isEmpty {
                self.handleMessage(data: data, context: context)
            }
            if let error = error {
                self.connectionDidFail(error: error)
            } else {
                self.setupReceive()
            }
        }
    }
    
    func handleMessage(data: Data, context: NWConnection.ContentContext) {
        didReceive?(data)
    }


    func send(data: Data) {
        let metaData = NWProtocolWebSocket.Metadata(opcode: .binary)
        let context = NWConnection.ContentContext (identifier: "context", metadata: [metaData])
        self.connection.send(content: data, contentContext: context, isComplete: true, completion: .contentProcessed( { error in
            if let error = error {
                self.connectionDidFail(error: error)
                return
            }
            print("connection \(self.id) did send, data: \(data as NSData)")
        }))
    }

    func stop() {
        print("connection \(id) will stop")
    }

    private func connectionDidFail(error: Error) {
        print("connection \(id) did fail, error: \(error)")
        stop(error: error)
    }

    private func connectionDidEnd() {
        print("connection \(id) did end")
        stop(error: nil)
    }

    private func stop(error: Error?) {
        connection.stateUpdateHandler = nil
        connection.cancel()
        if let didStopCallback = didStopCallback {
            self.didStopCallback = nil
            didStopCallback(error)
        }
    }
}
#endif

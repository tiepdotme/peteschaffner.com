import Foundation
import Publish
import Plot
import Files
import ShellOut

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

class WebSocketServerConnection {
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

final class Watcher {
    private static let ignoredDirNames = ["Output", "resume-references"]

    static var sources: [Path: DispatchSourceFileSystemObject] = [:]

    private static var root: Path?

    private static var watchCount = 0

    static func watch(path: Path, isRoot: Bool = false, action: @escaping (() throws -> ())) throws {
        if isRoot {
            self.root = path
            sources.removeAll()
            watchCount += 1
//            print("Watch count: \(watchCount)")
        }
        let pathURL = URL(fileURLWithPath: path.string)
        guard !ignoredDirNames.contains(pathURL.lastPathComponent) else {
            return
        }
        let fm = FileManager.default
        if sources[path] == nil  {
            let sourceDirDescrptr = open(path.string, O_EVTONLY)
            guard sourceDirDescrptr != -1 else { return }
            let eventSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: sourceDirDescrptr, eventMask: DispatchSource.FileSystemEvent.write, queue: nil)
            eventSource.setEventHandler {
                do {
//                    print("Changed: \(pathURL.lastPathComponent)")
                    try action()
                    if let root = root {
                        try watch(path: root, isRoot: true, action: action)
                    }
                } catch {
                    print(error)
                }
            }
            eventSource.resume()
            sources[path] = eventSource
//            print("registered for \(path)")
        }

        let res = try pathURL.resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
        guard (res.isDirectory == true) else {
            return
        }

        let contents = try fm.contentsOfDirectory(
            at: URL(fileURLWithPath: path.string),
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        for item in contents {
            try watch(path: Path(item.path), action: action)
        }
    }
}
#endif

struct PeteSchaffner: Website {
    enum SectionID: String, WebsiteSectionID {
        case words
        case readlater
    }

    struct ItemMetadata: WebsiteItemMetadata {
        var link: String?
        var slug: String?
    }

    var url = URL(string: "https://peteschaffner.com")!
    var name = "Pete Schaffner"
    var description = "The personal site of Pete Schaffner"
    var language: Language { .english }
    var imagePath: Path? { nil }
    var tagHTMLConfig: TagHTMLConfiguration? { nil }
}

fileprivate let hostname = try! shellOut(to: "hostname")

try PeteSchaffner().publish(using: [
    .copyResources(),
    .addMarkdownFiles(),
    // Handle draft posts
    .if(
        CommandLine.arguments.contains("--compile-drafts"),
        .step(named: "Import blog drafts") { context in
            if let folder = try? context.folder(at: Path("Content/words/drafts")) {
                for file in folder.files {
                    let posts = context.sections[.words].items
                    let postIndex = posts.firstIndex(where: { file.path.contains($0.path.string) })!

                    // File name
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd-HHmm"
                    var fileName = formatter.string(from: file.modificationDate!)
                    if let slug = posts[postIndex].metadata.slug {
                        fileName += "-\(slug)"
                    }

                    // Frontmatter
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    var frontMatter = "---\ndate: \(formatter.string(from: file.modificationDate!))"
                    if let link = posts[postIndex].metadata.link {
                        frontMatter += "\nlink: \(link)\n---"
                    } else {
                        frontMatter += "\n---"
                    }

                    var content = try! file.readAsString()
                    content = frontMatter + "\n\n" + content.replacingOccurrences(of: "(?s)---.*---", with: "", options: .regularExpression)

                    try! folder.createFile(at: "../\(fileName).md", contents: content.data(using: .utf8))
                    try! file.delete()
                }
            }
        }
    ),
    .removeAllItems(in: .words, matching: .init { (item) -> Bool in
        item.path.string.contains("drafts/")
    }),
    .sortItems(by: \.date, order: .descending),
    .mutateAllItems { item in
        // Remove the title for title-less posts since we handle setting a friendly date-based document title in the theme.
        item.title = item.path.string.contains(item.title) ? "" : item.title
        // Remove redundant title from content as that is handled in the theme and via the RSS generator
        item.body = item.body.deletingOccurrences(of: "<h1>.*</h1>")
        // Set RSS item link to
        if let link = item.metadata.link {
            item.rssProperties.link = URL(string: link)
        }
    },
    .generateHTML(withTheme: .pete),
    // Blog feed
    .generateRSSFeed(
        including: Set(arrayLiteral: PeteSchaffner.SectionID.words),
        config: .default
    ),
    // Read later feed
    .generateRSSFeed(
        including: Set(arrayLiteral: PeteSchaffner.SectionID.readlater),
        config: .init(targetPath: .init("readlater.rss"))
    ),
    .if(
        CommandLine.arguments.contains("--livereload"),
        .step(named: "Inject live reload script") { context in
            let files = try context.outputFolder(at: "").files.recursive
            
            let htmlFiles = files.filter { file in
                file.extension == "html" && !file.path.contains("resume-references")
            }
            
            try htmlFiles.forEach { file in
                try file.write(file.readAsString().replacingOccurrences(of: "</body></html>", with: "<script>let ws = new WebSocket('ws://" + hostname + ":8001/'); ws.onmessage = function(e) {window.location.reload(true)}</script></body></html>"))
            }
        }
    ),
    .step(named: "Sanitize feed") { context in
        do {
            let feedFile = try context.outputFile(at: "feed.rss")
            try feedFile.write(feedFile.readAsString().replacingOccurrences(of: "<p>+++</p>", with: ""))
        } catch {
            print("No feed file found")
        }
    },
    .step(named: "Sanitize read later feed") { context in
        do {
            let feedFile = try context.outputFile(at: "readlater.rss")
            try feedFile.write(
                feedFile.readAsString()
                    .replacingOccurrences(of: "<title>Pete Schaffner</title>", with: "<title>Read Later</title>")
                    .replacingOccurrences(of: "<description>The personal site of Pete Schaffner</description>", with: "<description>Pete Schaffner's Reading List</description>")
            )
        } catch {
            print("No feed file found")
        }
    }
])

#if !os(Linux)
if CommandLine.arguments.contains("--serve") {
    signal(SIGINT, SIG_IGN)

    let rootPath = Path(
        URL(string: #file)!
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .absoluteString
    )
    let serverProcess = Process()
    let sigintSource = DispatchSource.makeSignalSource(signal: SIGINT, queue: .main)
    
    sigintSource.setEventHandler {
        serverProcess.terminate()
        exit(0)
    }
    
    sigintSource.resume()
    
    #if !os(Linux)
    let wsServer = WebSocketServer(port: 8001)
    try! wsServer.start()
    #endif
    
    try Watcher.watch(path: rootPath, isRoot: true) {
        try shellOut(
            to: "swift run PeteSchaffner --livereload",
            at: rootPath.string
        )
        #if !os(Linux)
        for connection in wsServer.connectionsByID.values {
            connection.send(data: Data("reload".utf8))
        }
        #endif
    }
    
    try shellOut(
        to: "ruby -run -ehttpd Output -p8000",
        at: rootPath.string,
        process: serverProcess
    )
    
    
    dispatchMain()
}
#endif

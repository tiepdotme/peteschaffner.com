import Foundation
import Publish
import Plot
import ShellOut
import Files

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

private let hostname = try! shellOut(to: "hostname")

// Copy resource files over without building for faster reloads
if CommandLine.arguments.contains("--copyResources") {
	if let root = URL(string: #file)?.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent() {
		let outputFolder = try Folder(path: root.appendingPathComponent("Output", isDirectory: true).absoluteString)
		let resourcesFolder = try Folder(path: root.appendingPathComponent("Resources", isDirectory: true).absoluteString)

		for folder in resourcesFolder.subfolders {
			try outputFolder.subfolder(named: folder.name).delete()
			try folder.copy(to: outputFolder)
		}

		for file in resourcesFolder.files {
			try outputFolder.file(named: file.name).delete()
			try file.copy(to: outputFolder)
		}
	}

	exit(EXIT_SUCCESS)
}

// Build whole site
try PeteSchaffner().publish(using: [
    .copyResources(),
    .step(named: "Add pages") { context in
        context.addPage(PeteSchaffner.resumePage(context: context))
        context.addPage(PeteSchaffner.workPage(context: context))
    },
    .addMarkdownFiles(),
    .step(named: "Fix blog post filenames") { context in
        let items = context.sections[PeteSchaffner.SectionID.words].items
        for item in items {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd-HHmm"
            
            // Create new filename based on item's date and optional slug metadata
            var fileName = formatter.string(from: item.date)
            if let slug = item.metadata.slug {
                fileName += "-\(slug)"
            }
            
            // Rename file
			try? context.file(at: "Content/\(item.path).md").rename(to: fileName)
        }
    },
    .removeAllItems(),
    .addMarkdownFiles(),
    .sortItems(by: \.date, order: .descending),
    .generateHTML(withTheme: .pete),
    // Blog feed
    .generateRSSFeed(
        including: Set(arrayLiteral: PeteSchaffner.SectionID.words),
        config: .default
    ),
    // Set read-later item links to external source
    .mutateAllItems(in: PeteSchaffner.SectionID.readlater) { item in
        if let link = item.metadata.link {
            item.rssProperties.link = URL(string: link)
        }
    },
    // Read later feed
    .generateRSSFeed(
        including: Set(arrayLiteral: PeteSchaffner.SectionID.readlater),
        config: .init(targetPath: .init("readlater.rss"))
    ),
    .if(
        CommandLine.arguments.contains("--livereload") || CommandLine.arguments.contains("--serve"),
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

// Run a web server for development
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
    
    let wsServer = WebSocketServer(port: 8001)
    try! wsServer.start()
    
    try Watcher.watch(path: rootPath, isRoot: true) { url in
		var buildCommand = "swift run PeteSchaffner "

		buildCommand += url.pathComponents.contains("Resources") ? "--copyResources" : "--livereload"
		print(buildCommand)

        try shellOut(
            to: buildCommand,
            at: rootPath.string
        )

        for connection in wsServer.connectionsByID.values {
            connection.send(data: Data("reload".utf8))
        }
    }
    
    try shellOut(
        to: "ruby -run -ehttpd Output -p8000",
        at: rootPath.string,
        process: serverProcess
    )
    
    dispatchMain()
}
#endif

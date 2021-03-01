import Foundation
import Publish
import Plot
import Files
import ShellOut

final class Watcher {
    private static let ignoredDirNames = ["Output"]

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
    // Used for putting in the live reload script
    var hostname: String = try! shellOut(to: "hostname")
}

try PeteSchaffner().publish(using: [
    .copyResources(),
    .addMarkdownFiles(),
    // Handle draft posts
    .if(CommandLine.arguments.contains("--compile-drafts"), .step(named: "Import blog drafts") { context in
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
    }),
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
    
    try Watcher.watch(path: rootPath, isRoot: true) {
        try shellOut(
            to: "swift run",
            at: rootPath.string
        )
    }
    
    try shellOut(
        to: "python -m SimpleHTTPServer 8000",
        at: rootPath.appendingComponent("Output").string,
        process: serverProcess
    )
    
    dispatchMain()
}


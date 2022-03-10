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
	
	struct Footnote: WebsiteItemMetadata {
		var one: String?
		var two: String?
		var three: String?
		var four: String?
		var five: String?
		var six: String?
		var seven: String?
		var eight: String?
		var nine: String?
		
		func valueByPropertyName(name: String) -> String? {
			switch name {
			case "one": return one
			case "two": return two
			case "three": return three
			case "four": return four
			case "five": return five
			case "six": return six
			case "seven": return seven
			case "eight": return eight
			case "nine": return nine
			default: fatalError("Wrong property name")
			}
		}
	}
	
	struct ItemMetadata: WebsiteItemMetadata {
		var link: String?
		var slug: String?
		var footnote: Footnote?
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
	let root = URL(fileURLWithPath: #file)
		.deletingLastPathComponent()
		.deletingLastPathComponent()
		.deletingLastPathComponent()
	let outputFolder = try Folder(path: root.appendingPathComponent("Output", isDirectory: true).path)
	let resourcesFolder = try Folder(path: root.appendingPathComponent("Resources", isDirectory: true).path)
	
	for folder in resourcesFolder.subfolders {
		try outputFolder.subfolder(named: folder.name).delete()
		try folder.copy(to: outputFolder)
	}
	
	for file in resourcesFolder.files {
		try outputFolder.file(named: file.name).delete()
		try file.copy(to: outputFolder)
	}
	
	exit(EXIT_SUCCESS)
}

// Build whole site
try PeteSchaffner().publish(using: [
	.copyResources(),
	.step(named: "Add pages") { context in
		context.addPage(PeteSchaffner.makeResumePage(context: context))
		context.addPage(PeteSchaffner.makeWorkPage(context: context))
	},
	
	// Add blog posts and fix their names, which removes the need
	// to tediously name the files in the correct format and also
	// removes the need to set explicit date metadata in the file
	.addMarkdownFiles(),
	.step(named: "Fix blog post filenames") { context in
		let items = context.sections[PeteSchaffner.SectionID.words].items
		for item in items {
			if let file = try? context.file(at: "Content/\(item.path).md") {
				let formatter = DateFormatter()
				formatter.dateFormat = "yyyy-MM-dd-HHmm"
				
				let fileNameDateSubstring = String(file.nameExcludingExtension.prefix(formatter.dateFormat.count))
				let validDate = formatter.date(from: fileNameDateSubstring) == nil ? false : true
				if validDate {
					continue
				}
				
				var newFileName = formatter.string(from: item.date)
				if let slug = item.metadata.slug {
					newFileName += "-\(slug)"
				}
				
				try file.rename(to: newFileName)
			}
		}
	},
	.removeAllItems(), // Now that we've renamed our post files, remove them...
	.addMarkdownFiles(), // ...and add them back :)
	.sortItems(by: \.date, order: .descending),
	.generateHTML(withTheme: .pete),
	.generateRSSFeed(
		including: Set(arrayLiteral: PeteSchaffner.SectionID.words),
		config: .default
	),
	.mutateAllItems(in: PeteSchaffner.SectionID.readlater) { item in
		// Set read-later item links to external source
		if let link = item.metadata.link {
			item.rssProperties.link = URL(string: link)
		}
	},
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
	
	let rootPath = URL(fileURLWithPath: #file)
		.deletingLastPathComponent()
		.deletingLastPathComponent()
		.deletingLastPathComponent()
		.path
	
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
		var buildCommand = "swift run PeteSchaffner --build-path=.tmp "
		
		buildCommand += url.path.contains("Resources/css") ? "--copyResources" : "--livereload"
		
		try shellOut(
			to: buildCommand,
			at: rootPath
		)
		
		for connection in wsServer.connectionsByID.values {
			connection.send(data: Data("reload".utf8))
		}
	}
	
	try shellOut(
		to: "ruby -run -ehttpd Output -p8000",
		at: rootPath,
		process: serverProcess
	)
	
	dispatchMain()
}
#endif

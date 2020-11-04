import Foundation
import Publish
import Plot

struct PeteSchaffner: Website {
    enum SectionID: String, WebsiteSectionID {
        case words
        case readlater
    }

    struct ItemMetadata: WebsiteItemMetadata {
        var link: String?
        var draft: Bool?
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://peteschaffner.com")!
    var name = "Pete Schaffner"
    var description = "The personal site of Pete Schaffner"
    var language: Language { .english }
    var imagePath: Path? { nil }
    var tagHTMLConfig: TagHTMLConfiguration? { nil }
}

try PeteSchaffner().publish(using: [
    .copyResources(),
    .addMarkdownFiles(),
    .sortItems(by: \.date, order: .descending),
    .if(CommandLine.arguments.contains("--removeDrafts"), .removeAllItems(matching: \.metadata.draft == true)),
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
    .generateRSSFeed(
        including: Set(arrayLiteral: PeteSchaffner.SectionID.words),
        config: .default
    ),
    .generateRSSFeed(
        including: Set(arrayLiteral: PeteSchaffner.SectionID.readlater),
        config: .init(targetPath: .init("readlater.rss"))
    ),
    .step(named: "Rename .htaccess") { context in
        try context.outputFile(at: "htaccess").rename(to: ".htaccess")
    },
    .step(named: "Sanitize Feed") { context in
        do {
            let feedFile = try context.outputFile(at: "feed.rss")
            try feedFile.write(feedFile.readAsString().replacingOccurrences(of: "<p>+++</p>", with: ""))
        } catch {
            print("No feed file found")
        }
    },
    .step(named: "Sanitize Read Later Feed") { context in
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

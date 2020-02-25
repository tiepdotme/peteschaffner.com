import Foundation
import Publish
import Plot

struct PeteSchaffner: Website {
    enum SectionID: String, WebsiteSectionID {
        case words
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

try PeteSchaffner().publish(withTheme: .pete, additionalSteps: [
    .if(CommandLine.arguments.contains("--removeDrafts"), .removeAllItems(matching: \.metadata.draft == true)),
    .mutateAllPages { page in
        // Replace dumb quotes with smart ones
        page.body.convertQuotes()
    },
    .mutateAllItems { item in
        // Remove redundant titles because we extract and place them manually in a header element
        item.body = item.body.deletingOccurences(of: "<h1>.*</h1>")
        // Replace dumb quotes with smart ones
        item.body.convertQuotes()
        item.title = item.path.string.contains(item.title) ? "" : item.title
    }
])

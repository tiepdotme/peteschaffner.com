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
    .mutateAllItems { item in
        // Remove the title for title-less posts since we handle setting a friendly date-based document title in the theme.
        item.title = item.path.string.contains(item.title) ? "" : item.title
    },
    .step(named: "Rename .htaccess") { context in
        try context.outputFile(at: "htaccess").rename(to: ".htaccess")
    }
])

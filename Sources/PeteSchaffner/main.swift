import Foundation
import Publish
import Plot

struct PeteSchaffner: Website {
    enum SectionID: String, WebsiteSectionID {
        case words
    }

    struct ItemMetadata: WebsiteItemMetadata {
        var link: String?
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
    .mutateAllItems { item in
        item.body = item.body.deletingOccurences(of: "<h1>.*</h1>")
    }
])

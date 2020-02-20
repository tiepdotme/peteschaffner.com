import Foundation
import Publish
import Plot

struct PeteSchaffner: Website {
    enum SectionID: String, WebsiteSectionID {
        case words
    }

    struct ItemMetadata: WebsiteItemMetadata {
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://peteschaffner.com")!
    var name = "Pete Schaffner"
    var description = "The personal site of Pete Schaffner"
    var language: Language { .english }
    var imagePath: Path? { nil }
    var tagHTMLConfig: TagHTMLConfiguration? { nil }
}

try PeteSchaffner().publish(withTheme: .pete)

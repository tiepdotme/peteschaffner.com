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
        // Remove redundant titles because we extract and place them manually in a header element
        item.body = item.body.deletingOccurrences(of: "<h1>.*</h1>")
        // Remove the title for title-less posts since we handle setting a friendly date-based document title in the theme.
        item.title = item.path.string.contains(item.title) ? "" : item.title
    },
    .step(named: "Convert quotes") { context in
        // Posts
        for section in context.sections.ids {
            context.sections[section].mutateItems(matching: .any) { item in
                item.body.convertQuotes()
            }
        }
        
        // Pages
        for path in context.pages.keys {
            try context.mutatePage(
                at: path,
                matching: .any,
                using: { page in
                    page.body.convertQuotes()
                }
            )
        }
        
        // Index
        context.index.body.convertQuotes()
    },
    .step(named: "Add footnotes") { context in
        let c = context
        func getSource(from location: Location) -> String {
            return try! c.file(at: "Content/\(location.path.string.isEmpty ? "index" : location.path).md").readAsString()
        }
        
        // Posts
        for section in context.sections.ids {
            context.sections[section].mutateItems(matching: .any) { item in
                item.body.addFootnotes(from: getSource(from: item))
            }
        }
        
        // Pages
        for path in context.pages.keys {
            try context.mutatePage(
                at: path,
                matching: .any,
                using: { page in
                    page.body.addFootnotes(from: getSource(from: page))
                }
            )
        }
        
        // Index
        context.index.body.addFootnotes(from: getSource(from: context.index))
    },
    .step(named: "Rename .htaccess") { context in
        try context.outputFile(at: "htaccess").rename(to: ".htaccess")
    }
])

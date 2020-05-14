//
//  File.swift
//  
//
//  Created by Peter Schaffner on 17/02/2020.
//

import Foundation
import Publish
import Plot
import Ink

extension Theme where Site == PeteSchaffner {
    static var pete: Self {
        Theme(htmlFactory: PeteHTMLFactory())
    }
    
    private struct PeteHTMLFactory: HTMLFactory {
        func makeIndexHTML(for index: Index, context: PublishingContext<PeteSchaffner>) throws -> HTML {
            layout(for: index, site: context.site)
        }
        
        func makeSectionHTML(for section: Section<PeteSchaffner>, context: PublishingContext<PeteSchaffner>) throws -> HTML {
            let body = Node.forEach(section.items) { item in
                .article(
                    .div(
                        .header(
                            .if(
                                !item.title.isEmpty,
                                .h1(
                                    .a(
                                        // `item.path.string` returns an extra root path fragment (/words/words/<post>), yet creating a `Path` from the same string fixes things 🤷‍♂️
                                        .href(Path(item.metadata.link ?? item.path.string)),
                                        .text(item.title),
                                        .if(
                                            item.metadata.link != nil,
                                            .span(
                                                .class("external-link-arrow"),
                                                .text("→")
                                            )
                                        )
                                    )
                                )
                            ),
                            .time(
                                .attribute(named: "datetime", value: dateTime(item.date)),
                                .a(
                                    .href(item.path),
                                    .text(friendlyDate(item.date)),
                                    .span(.text(" ∞"))
                                )
                            )
                        ),
                        .contentBody(item.body.deletingOccurrences(of: #"\+\+\+((.|\n)*)"#)),
                        .if(
                            item.body.html.contains("+++"),
                            .a(.class("read-more"), .href(item.path), .text("Read more…"))
                        )
                    )
                )
            }
            
            return layout(for: section, site: context.site, body: body)
        }
        
        func makeItemHTML(for item: Item<PeteSchaffner>, context: PublishingContext<PeteSchaffner>) throws -> HTML {
            let body = Node.article(
                .header(
                    .if(
                        !item.title.isEmpty,
                        .h1(
                            .if(
                                item.metadata.link != nil,
                                .a(
                                    .unwrap(item.metadata.link) { .href($0) },
                                    .text(item.title),
                                    .span(
                                        .class("external-link-arrow"),
                                        .text("→")
                                    )
                                ),
                                else: .text(item.title)
                            )
                        )
                    ),
                    .time(
                        .attribute(named: "datetime", value: dateTime(item.date)),
                        .text(friendlyDate(item.date))
                    )
                ),
                .contentBody(item.body.deletingOccurrences(of: #"<p>\+\+\+<\/p>"#))
            )
            
            return layout(for: item, site: context.site, body: body)
        }
        
        func makePageHTML(for page: Page, context: PublishingContext<PeteSchaffner>) throws -> HTML {
            layout(for: page, site: context.site)
        }
        
        func makeTagListHTML(for page: TagListPage, context: PublishingContext<PeteSchaffner>) throws -> HTML? { nil }
        
        func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<PeteSchaffner>) throws -> HTML? { nil }
    }
}

extension Node where Context: HTML.BodyContext {
    static func time(_ nodes: Node<HTML.BodyContext>...) -> Node {
        .element(named: "time", nodes: nodes)
    }
}

extension Content.Body {
    func deletingOccurrences(of string: String) -> Self {
        Self(html: html.replacingOccurrences(
            of: string,
            with: "",
            options: .regularExpression
        ))
    }
    
    mutating func makeSmartSubstitutions() {
        html = html
        // Quotes
        .replacingOccurrences(of: #"'(.+?)'"#, with: "‘$1’", options: .regularExpression)
        .replacingOccurrences(of: #"([\w\s])'(\w)"#, with: "$1’$2", options: .regularExpression)
        .replacingOccurrences(of: #""([^"><]+)"(?![^<]*>)"#, with: "“$1”", options: .regularExpression)
        // Punctuation
        .replacingOccurrences(of: "...", with: "…")
        .replacingOccurrences(of: "---", with: "—")
        .replacingOccurrences(of: "--", with: "–")
    }
    
    mutating func addFootnotes(from source: String) {
        let superscriptChars = ["0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴", "5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹"]
        let footnoteReferenceRegex = try! NSRegularExpression(pattern: #"(?<=\w)\[\^(.+?)\]"#)
        let parser = MarkdownParser()
        let footnoteReferenceMatches = footnoteReferenceRegex.matches(in: html, options: [], range: NSRange(html.startIndex..<html.endIndex, in: html))
        var totalOffset = 0
        var footnotes = ""
        
        footnoteReferenceMatches.enumerated().forEach { index, match in
            let footnoteNumber = String(index + 1)
            let footnoteSuperscript = footnoteNumber.compactMap {
                superscriptChars[$0.description]
            }.joined()
            let footnoteReference = Node.element(named: "sup", nodes: [Node.a(.href("#fn\(footnoteNumber)"), .id("fnr\(footnoteNumber)"), .attribute(named: "title", value: "See footnote"), .text(footnoteSuperscript))]).render()
            
            totalOffset += index > 0 ? footnoteReferenceMatches[index - 1].range.length - footnoteReference.count : 0
            let range = Range(NSRange(location: match.range.lowerBound - totalOffset, length: match.range.length), in: html)!
            guard let footnoteSubstring = source.firstSubstring(between: .init(stringLiteral: "\(html[range]):"), and: .init(unicodeScalarLiteral: "\n")) else {
                fatalError("Missing footnote definition")
            }
            let footnoteMarkdown = String(footnoteSubstring).trimmingCharacters(in: .whitespaces)
            
            html = html.replacingCharacters(in: range, with: footnoteReference)

            footnotes += Node.li(.id("fn\(footnoteNumber)"), .raw(parser.html(from: footnoteMarkdown).replacingOccurrences(of: #"<\/?p>"#, with: "", options: .regularExpression)), .a(.href("#fnr\(footnoteNumber)"), .attribute(named: "title", value: "Return to article"), .class("reversefootnote"), .text("↑"))).render()
            
            if match == footnoteReferenceMatches.last {
                html += Node.ol(.class("footnotes"), .raw(footnotes)).render()
            }
        }
    }
}

func friendlyDate(_ date: Date) -> String {
    let df = DateFormatter()
    df.dateFormat = "dd MMM yyyy"
    return df.string(from: date)
}

func dateTime(_ date: Date) -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    return df.string(from: date)
}

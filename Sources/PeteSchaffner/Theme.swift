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
            let body = Content.Body(node: .div(.contentBody(index.body)))
                        
            return layout(for: index, context: context, body: body)
        }
        
        func makeSectionHTML(for section: Section<PeteSchaffner>, context: PublishingContext<PeteSchaffner>) throws -> HTML {
            let body = Content.Body(node: .forEach(section.items) { item in
                .article(
                    .header(
                        .if(
                            !item.path.string.contains(item.title),
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
                                .span(.text("∞"))
                            )
                        )
                    ),
                    .contentBody(
                        item.body
                            .deletingOccurrences(of: #"\+\+\+((.|\n)*)"#)
                            .deletingOccurrences(of: "<h1>.*</h1>")
                    ),
                    .if(
                        item.body.html.contains("+++"),
                        .a(.class("read-more"), .href(item.path), .text("Read more…"))
                    )
                )
            })
            
            return layout(for: section, context: context, body: body)
        }
        
        func makeItemHTML(for item: Item<PeteSchaffner>, context: PublishingContext<PeteSchaffner>) throws -> HTML {
            let body = Content.Body(node: .article(
                .header(
                    .if(
                        !item.path.string.contains(item.title),
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
                .contentBody(
                    item.body
                        .deletingOccurrences(of: #"<p>\+\+\+<\/p>"#)
                        .deletingOccurrences(of: "<h1>.*</h1>")
                )
            ))
            
            return layout(for: item, context: context, body: body)
        }
        
        func makePageHTML(for page: Page, context: PublishingContext<PeteSchaffner>) throws -> HTML {
            let body = Content.Body(node: .div(.contentBody(page.body)))
            
            return layout(for: page, context: context, body: body)
        }
        
        func makeTagListHTML(for page: TagListPage, context: PublishingContext<PeteSchaffner>) throws -> HTML? { nil }
        
        func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<PeteSchaffner>) throws -> HTML? { nil }
        
        private func layout(for location: Location, context: PublishingContext<PeteSchaffner>, body: Content.Body) -> HTML {
            var body = body
            var pageID: String
            var pageClass: String
            var avatarName: String

            switch location.path.absoluteString {
            case "/words":
                pageID = "words"
                avatarName = ".words"
            case "/readlater":
                pageID = "words"
                avatarName = ".private"
            case let str where str.contains("/words"):
                pageID = ""
                avatarName = ".words"
            case let str where str.contains("/work"):
                pageID = "work"
                avatarName = ".work"
            case "/resume":
                pageID = "resume"
                avatarName = ".resume"
            default:
                pageID = "home"
                avatarName = ""
            }
            
            if location.title == "Four Oh Four!" {
                pageID = "four-oh-four"
                avatarName = ".404"
            }
            
            switch pageID {
            case "words", "work":
                pageClass = "list"
            default:
                pageClass = ""
            }
            
            // Process footnotes if they exist
            if let file = try? context.file(at: "Content/\(location.path).md") {
                var totalOffset = 0
                var footnotes = ""
                var html = body.html
                let superscriptChars = ["0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴", "5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹"]
                let footnoteReferenceRegex = try! NSRegularExpression(pattern: #"(?<=\w)\[\^(.+?)\]"#)
                let parser = MarkdownParser()
                let footnoteReferenceMatches = footnoteReferenceRegex.matches(in: html, options: [], range: NSRange(html.startIndex..<html.endIndex, in: html))
                
                footnoteReferenceMatches.enumerated().forEach { index, match in
                    let footnoteNumber = String(index + 1)
                    let footnoteSuperscript = footnoteNumber.compactMap {
                        superscriptChars[$0.description]
                    }.joined()
                    let footnoteReference = Node.element(named: "sup", nodes: [Node.a(.href("#fn\(footnoteNumber)"), .id("fnr\(footnoteNumber)"), .attribute(named: "title", value: "See footnote"), .text(footnoteSuperscript))]).render()
                    
                    totalOffset += index > 0 ? footnoteReferenceMatches[index - 1].range.length - footnoteReference.count : 0
                    let range = Range(NSRange(location: match.range.lowerBound - totalOffset, length: match.range.length), in: html)!
                    guard let footnoteSubstring = try! file.readAsString().firstSubstring(between: .init(stringLiteral: "\(html[range]):"), and: .init(unicodeScalarLiteral: "\n")) else {
                        fatalError("Missing footnote definition")
                    }
                    let footnoteMarkdown = String(footnoteSubstring).trimmingCharacters(in: .whitespaces)
                    
                    html = html.replacingCharacters(in: range, with: footnoteReference)
                    
                    footnotes += Node.li(.id("fn\(footnoteNumber)"), .raw(parser.html(from: footnoteMarkdown).replacingOccurrences(of: #"<\/?p>"#, with: "", options: .regularExpression)), .a(.href("#fnr\(footnoteNumber)"), .attribute(named: "title", value: "Return to article"), .class("reversefootnote"), .text("↑"))).render()
                    
                    if match == footnoteReferenceMatches.last {
                        html += Node.ol(.class("footnotes"), .raw(footnotes)).render()
                    }
                }
                
                body.html = html
            }
            
            return HTML(
                .lang(context.site.language),
                .head(
                    .encoding(.utf8),
                    .title((location.path.absoluteString == "/" ? "" : (location.path.string.contains(location.title) ? friendlyDate(location.date) : location.title) + " · ") + context.site.name),
                    .viewport(.accordingToDevice),
                    .description(context.site.description),
                    .meta(.name("author"), .content("Pete Schaffner")),
                    .rssFeedLink(Path.defaultForRSSFeed.absoluteString, title: "Pete Schaffner"),
                    .link(.href("https://micro.blog/peteschaffner"), .attribute(named: "rel", value: "me")),
                    .stylesheet("/css/fonts.css"),
                    .if(body.html.contains("<code>"), .stylesheet("/css/code-fonts.css")),
                    .stylesheet("/css/styles.css"),
                    .favicon("/favicon.png")
                ),
                .body(
                    .id(pageID),
                    .class(pageClass),
                    .nav(
                        .class("constrained"),
                        .element(
                            named: "svg",
                            nodes: [
                                .id("avatar"),
                                .attribute(named: "width", value: "90px"),
                                .attribute(named: "height", value: "90px"),
                                .attribute(named: "viewBox", value: "0 0 90 90"),
                                .attribute(named: "version", value: "1.1"),
                                .attribute(named: "xmlns", value: "http://www.w3.org/2000/svg"),
                                .attribute(named: "xmlns:xlink", value: "http://www.w3.org/1999/xlink"),
                                .raw(try! context.file(at: "Resources/images/avatar\(avatarName).svg").readAsString())
                            ]
                        ),
                        .p(
                            .text("The "),
                            .if(
                                pageID == "resume",
                                .a(.class("current"), .href("/resume"), .text("résumé")),
                                else: .group([
                                    .a(
                                        .class(location.path.absoluteString.contains("/words") ? "current" : ""),
                                        .href("/words"),
                                        .text("words")
                                    ),
                                    .text(" & "),
                                    .a(
                                        .class(pageID == "work" ? "current" : ""),
                                        .href("/work"),
                                        .text("work")
                                    )])
                            ),
                            .text(" of "),
                            .a(
                                .class(location.path.absoluteString == "/" ? "current" : ""),
                                .href("/"),
                                .text("Pete Schaffner")
                            ),
                            .text(".")
                        )
                    ),
                    .main(
                        .class("constrained"),
                        .contentBody(body.makingSmartSubstitutions())
                    ),
                    .footer(
                        .class("constrained"),
                        .text("© \(Calendar.current.component(.year, from: Date())) · "),
                        .a(
                            .href(Path.defaultForRSSFeed),
                            .text("RSS")
                        ),
                        .text(" · "),
                        .a(
                            .href("/colophon"),
                            .text("Colophon")
                        ),
                        .text(" · "),
                        .a(
                            .href("https://github.com/peteschaffner/peteschaffner.com"),
                            .text("Source")
                        )
                    ),
                    .script(.raw(try! context.file(at: "Resources/js/nav.js").readAsString())),
                    .if(
                        location.path.absoluteString == "/work",
                        .script(
                            .raw(try! context.file(at: "Resources/js/work.js").readAsString())
                        )
                    )
                )
            )
        }

        private func friendlyDate(_ date: Date) -> String {
            let df = DateFormatter()
            df.dateFormat = "dd MMM yyyy"
            return df.string(from: date)
        }

        private func dateTime(_ date: Date) -> String {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df.string(from: date)
        }
    }
}

extension Node where Context: HTML.BodyContext {
    static func time(_ nodes: Node<HTML.BodyContext>...) -> Node {
        .element(named: "time", nodes: nodes)
    }
}

private extension Content.Body {
    func deletingOccurrences(of string: String) -> Self {
        Self(html: html.replacingOccurrences(
            of: string,
            with: "",
            options: .regularExpression
        ))
    }
    
    func makingSmartSubstitutions() -> Self {
        Self(html: html
            // Quotes
            .replacingOccurrences(of: #"\b'(\w?)"#, with: "’$1", options: .regularExpression) // e.g. 'Quotation(') | Pete(')s | you(')ve
            .replacingOccurrences(of: #"'(\d{2}s)"#, with: "’$1", options: .regularExpression) // e.g. (')30s
            .replacingOccurrences(of: #"'\b"#, with: "‘", options: .regularExpression) // e.g. (')Quotation'
            .replacingOccurrences(of: #""([^"><]+)"(?![^<]*>)"#, with: "“$1”", options: .regularExpression) // e.g. <a href="/path">(")Quotation(")</a>
            .replacingOccurrences(of: #"(\d)"(\s)(?![^<]*>)"#, with: "$1”$2", options: .regularExpression) // e.g. 13(") MacBook Pro
            // Punctuation
            .replacingOccurrences(of: "...", with: "…")
            .replacingOccurrences(of: "---", with: "—")
            .replacingOccurrences(of: "--", with: "–")
        )
    }
}

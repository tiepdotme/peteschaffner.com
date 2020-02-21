//
//  File.swift
//  
//
//  Created by Peter Schaffner on 17/02/2020.
//

import Foundation
import Publish
import Plot

extension Theme where Site == PeteSchaffner {
    static var pete: Self {
        Theme(htmlFactory: PeteHTMLFactory())
    }
    
    private struct PeteHTMLFactory: HTMLFactory {
        func makeIndexHTML(for index: Index, context: PublishingContext<PeteSchaffner>) throws -> HTML {
            layout(for: index, site: context.site)
        }
        
        func makeSectionHTML(for section: Section<PeteSchaffner>, context: PublishingContext<PeteSchaffner>) throws -> HTML {
            func excerpt(from contentBody: String) -> Content.Body {
                return Content.Body(html:
                    (contentBody.replacingOccurrences(
                        of: "<h1>.*</h1>",
                        with: "",
                        options: .regularExpression
                    )) // Remove redundant title
                    .replacingOccurrences(
                        of: "<!-- excerpt -->.*",
                        with: "",
                        options: .regularExpression
                    ) // Remove everything after the marked excerpt
                )
            }
            
            let body = Node.forEach(section.items) { item in
                .section(
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
                    .contentBody(excerpt(from: item.body.html)),
                    .if(
                        item.body.html.contains("<!-- excerpt -->"),
                        .a(.href(item.path), .text("More…"))
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
                .contentBody(
                    Content.Body(
                        // Remove redundant title as it is already handled above
                        html: item.body.html.replacingOccurrences(
                            of: "<h1>.*</h1>", with: "", options: .regularExpression
                        )
                    )
                )
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

func layout<T: Website>(for location: Location, site: T, body: Node<HTML.BodyContext>? = nil) -> HTML {
    let pageID: String
    
    switch location.path.absoluteString {
    case "/words":
        pageID = "words"
    case "/work":
        pageID = "work"
    default:
        pageID = ""
    }
    
    return HTML(
        .lang(site.language),
        .head(
            .encoding(.utf8),
            .title((location.path.absoluteString == "/" ? "": "\(location.title.isEmpty ? friendlyDate(location.date) : location.title) · ") + site.name),
            .viewport(.accordingToDevice),
            .description(site.description),
            .meta(.name("author"), .content("Pete Schaffner")),
            .rssFeedLink(Path.defaultForRSSFeed.absoluteString, title: "Pete Schaffner"),
            .link(.href("https://micro.blog/peteschaffner"), .attribute(named: "rel", value: "me")),
            .stylesheet("/css/fonts.css"),
            .stylesheet("/css/styles.css"),
            .favicon("/favicon.png")
        ),
        .body(
            .id(pageID),
            .nav(
                .class("constrained"),
                .text("The "),
                .a(
                    .class(location.path.absoluteString.contains("/words") ? "current" : ""),
                    .href("/words"),
                    .text("words")
                ),
                .element(named: "i", text: " & "),
                .a(
                    .class(location.path.absoluteString == "/work" ? "current" : ""),
                    .href("/work"),
                    .text("work")
                ),
                .text(" of "),
                .a(
                    .class(location.path.absoluteString == "/" ? "current" : ""),
                    .href("/"),
                    .text("Pete Schaffner")
                )
            ),
            .main(
                .class("constrained"),
                body ?? .contentBody(location.body)
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
                )
            )
        )
    )
}

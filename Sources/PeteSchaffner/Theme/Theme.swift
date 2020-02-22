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
                    .contentBody(item.body.deletingOccurences(of: "<!-- excerpt -->((.|\n)*)")),
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
                .contentBody(item.body)
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
    func deletingOccurences(of string: String) -> Self {
        return Self(html: html.replacingOccurrences(
            of: string,
            with: "",
            options: .regularExpression
        ))
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

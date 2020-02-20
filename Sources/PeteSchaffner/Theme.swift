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
            layout(for: section, site: context.site)
        }
        
        func makeItemHTML(for item: Item<PeteSchaffner>, context: PublishingContext<PeteSchaffner>) throws -> HTML {
            HTML()
        }
        
        func makePageHTML(for page: Page, context: PublishingContext<PeteSchaffner>) throws -> HTML {
            layout(for: page, site: context.site)
        }
        
        func makeTagListHTML(for page: TagListPage, context: PublishingContext<PeteSchaffner>) throws -> HTML? { nil }
        
        func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<PeteSchaffner>) throws -> HTML? { nil }
    }
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
            .title((location.path.absoluteString == "/" ? "": "\(location.title) · ") + site.name),
            .viewport(.accordingToDevice),
            .description(site.description),
            .meta(.name("author"), .content("Pete Schaffner")),
            .rssFeedLink(Path.defaultForRSSFeed.absoluteString, title: "Pete Schaffner"),
            .link(.href("https://micro.blog/peteschaffner"), .attribute(named: "rel", value: "me")),
            .stylesheet("/css/styles.css"),
            .favicon("/favicon.png")
        ),
        .body(
            .id(pageID),
            .nav(
                .class("constrained"),
                .text("The "),
                .a(
                    .class(location.path.absoluteString == "/words" ? "current" : ""),
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

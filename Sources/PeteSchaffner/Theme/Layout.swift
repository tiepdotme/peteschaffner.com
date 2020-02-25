//
//  Layout.swift
//
//
//  Created by Pete Schaffner on 21/02/2020.
//

import Foundation
import Publish
import Plot

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
            .title((location.path.absoluteString == "/" ? "" : (location.title.isEmpty ? friendlyDate(location.date) : location.title) + " · ") + site.name),
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

//
//  Layout.swift
//
//
//  Created by Pete Schaffner on 21/02/2020.
//

import Foundation
import Publish
import Plot

func layout(for location: Location, context: PublishingContext<PeteSchaffner>, body: Content.Body) -> HTML {
    var pageID: String
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
        pageID = ""
        avatarName = ""
    }
    
    if location.title == "Four Oh Four!" {
        pageID = "four-oh-four"
        avatarName = ".404"
    }

    return HTML(
        .lang(context.site.language),
        .head(
            .encoding(.utf8),
            .title((location.path.absoluteString == "/" ? "" : (location.title.isEmpty ? friendlyDate(location.date) : location.title) + " · ") + context.site.name),
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
            .nav(
                .class("constrained"),
                .div(.raw(try! context.file(at: "Resources/images/avatar\(avatarName).svg").readAsString())),
                .div(.raw(try! context.file(at: "Resources/images/avatar\(avatarName).dark.svg").readAsString())),
                .p(
                    .text("The "),
                    .if(
                        location.path.absoluteString == "/resume",
                        .a(.class("current"), .href("/resume"), .text("résumé")),
                        else: .group([
                            .a(
                                .class(location.path.absoluteString.contains("/words") ? "current" : ""),
                                .href("/words"),
                                .text("words")
                            ),
                            .text(" & "),
                            .a(
                                .class(location.path.absoluteString == "/work" ? "current" : ""),
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
            .if(location.path.absoluteString == "/work", .script(.src("/js/work.js")))
        )
    )
}

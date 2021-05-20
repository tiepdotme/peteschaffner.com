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
			HTML(for: index, with: context) {
				Div {
					index.body
				}
			}
        }

        func makeSectionHTML(for section: Section<PeteSchaffner>, context: PublishingContext<PeteSchaffner>) throws -> HTML {
			HTML(for: section, with: context) {
				ArticleList(section.items) { item in
					ComponentGroup {
						Header {
							if !item.path.string.contains(item.title) {
								H1 {
									Node.a(
										.href(item.metadata.link ?? item.path.absoluteString),
										.text(item.title),
										.if(
											item.metadata.link != nil,
											.span(
												.class("external-link-arrow"),
												.text("→")
											)
										)
									)
								}
							}
							Node.time(
								.attribute(named: "datetime", value: dateTime(item.date)),
								.a(
									.href(item.path),
									.text(friendlyDate(item.date)),
									.span(.text("∞"))
								)
							)
						}
						item.body
							.deletingOccurrences(of: #"\+\+\+((.|\n)*)"#)
							.deletingOccurrences(of: "<h1>.*</h1>")
						if item.body.html.contains("+++") {
							Link("Read more…", url: item.path.string).class("read-more")
						}
					}
				}
			}
        }

        func makeItemHTML(for item: Item<PeteSchaffner>, context: PublishingContext<PeteSchaffner>) throws -> HTML {
			HTML(for: item, with: context) {
				Article {
					Header {
						if !item.path.string.contains(item.title) {
							H1 {
								if let url = item.metadata.link {
									Node.a(
										.href(url),
										.text(item.title),
										.span(
											.class("external-link-arrow"),
											.text("→")
										)
									)
								} else {
									Text(item.title)
								}
							}
						}
						Node.time(
							.attribute(named: "datetime", value: dateTime(item.date)),
							.text(friendlyDate(item.date))
						)
					}
					item.body
						.deletingOccurrences(of: #"<p>\+\+\+<\/p>"#)
						.deletingOccurrences(of: "<h1>.*</h1>")
				}
			}
        }

        func makePageHTML(for page: Page, context: PublishingContext<PeteSchaffner>) throws -> HTML {
			HTML(for: page, with: context) {
				Div {
					page.body
				}
			}
        }

        func makeTagListHTML(for page: TagListPage, context: PublishingContext<PeteSchaffner>) throws -> HTML? { nil }

        func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<PeteSchaffner>) throws -> HTML? { nil }
    }
}

// MARK: Main Layout

private extension HTML {
	init(for location: Location, with context: PublishingContext<PeteSchaffner>, @ComponentBuilder content: @escaping () -> ComponentGroup) {
		self.init(
			.head(for: location, with: context),
			.body(for: location, with: context) {
				content()
			}
		)
	}
}

// MARK: Components

private struct SiteNav: Component {
	var location: Location
	var context: PublishingContext<PeteSchaffner>
	var metaData: (id: String, class: String, avatarSuffix: String)

	init(location: Location, context: PublishingContext<PeteSchaffner>) {
		self.location = location
		self.context = context
		self.metaData = metadataFor(page: location)
	}

	var body: Component {
		Navigation {
			Node<HTML.BodyContext>.element(
				named: "svg",
				nodes: [
					.id("avatar"),
					.attribute(named: "width", value: "90px"),
					.attribute(named: "height", value: "90px"),
					.attribute(named: "viewBox", value: "0 0 90 90"),
					.attribute(named: "version", value: "1.1"),
					.attribute(named: "xmlns", value: "http://www.w3.org/2000/svg"),
					.attribute(named: "xmlns:xlink", value: "http://www.w3.org/1999/xlink"),
					.raw(try! context.file(at: "Resources/images/avatar\(metaData.avatarSuffix).svg").readAsString())
				]
			)
			Paragraph {
				Text("The ")
				if metaData.id == "resume" {
					Link("résumé", url: "/resume").class("current")
				} else {
					Link("words", url: "/words").class(location.path.absoluteString.contains("/words") ? "current" : "")
					Text(" & ")
					Link("work", url: "/work").class(metaData.id == "work" ? "current" : "")
				}
				Text(" of ")
				Link("Pete Schaffner", url: "/").class(location.path.absoluteString == "/" ? "current" : "")
				Text(".")
			}
		}
		.class("constrained")
	}
}

private struct MainContent: ComponentContainer {
	@ComponentBuilder var content: ContentProvider

	var body: Component {
		Node.main(
			.class("constrained"),
			.component(Content.Body(components: content).makingSmartSubstitutions())
		)
	}
}

private struct SiteFooter: Component {
	var location: Location
	var context: PublishingContext<PeteSchaffner>

	var body: Component {
		Footer {
			Text("© \(Calendar.current.component(.year, from: Date())) · ")
			Link("RSS", url: Path.defaultForRSSFeed.string)
			Text(" · ")
			Link("Colophon", url: "/colophon")
			Text(" · ")
			Link("Source", url: "https://github.com/peteschaffner/peteschaffner.com")

			inlineScript(at: "Resources/js/nav.js")
			inlineScript(at: "Resources/js/welcome.js")

			if location.path.absoluteString == "/work" {
				inlineScript(at: "Resources/js/work.js")
			}
		}
		.class("constrained")
	}

	private func inlineScript(at path: Path) -> Node<HTML.BodyContext> {
		Node.script(.raw(try! context.file(at: path).readAsString()))
	}
}

private struct ArticleList<Articles: Sequence>: Component {
	var articles: Articles
	var content: (Articles.Element) -> Component

	init(_ articles: Articles,
		 content: @escaping (Articles.Element) -> Component) {
		self.articles = articles
		self.content = content
	}

	var body: Component {
		ComponentGroup {
			for article in articles {
				Article {
					content(article)
				}
			}
		}
	}
}

// MARK: Node Extensions

private extension Node where Context == HTML.DocumentContext {
	static func head(for location: Location, with context: PublishingContext<PeteSchaffner>) -> Node {
		return .group(
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
				.if(location.body.html.contains("<code>"), .stylesheet("/css/code-fonts.css")),
				.stylesheet("/css/styles.css"),
				.favicon("/favicon.png")
			)
		)
	}
}

private extension Node where Context == HTML.DocumentContext {
	static func body(for location: Location, with context: PublishingContext<PeteSchaffner>, @ComponentBuilder content: @escaping () -> Component) -> Node {
		let metaData = metadataFor(page: location)
		var location = location

		location.body.html = htmlWithFootnotes(for: location, with: context)

		return .body(
			.id(metaData.id),
			.class(metaData.class),
			.components {
				SiteNav(location: location, context: context)
				MainContent {
					content()
				}
				SiteFooter(location: location, context: context)
			}
		)
	}
}

extension Node where Context: HTML.BodyContext {
	static func time(_ nodes: Node<HTML.BodyContext>...) -> Node {
		.element(named: "time", nodes: nodes)
	}
}

// MARK: Content Body Extensions

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

// MARK: Helper functions

private func htmlWithFootnotes(for location: Location, with context: PublishingContext<PeteSchaffner>) -> String {
	guard let file = try? context.file(at: "Content/\(location.path).md") else {
		return location.body.html
	}
	var totalOffset = 0
	var footnotes = ""
	var html = location.body.html
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

	return html
}

private func metadataFor(page: Location) -> (id: String, class: String, avatarSuffix: String) {
	var pageID: String
	var pageClass: String
	var avatarSuffix: String

	switch page.path.absoluteString {
	case "/words":
		pageID = "words"
		avatarSuffix = ".words"
	case "/readlater":
		pageID = "words"
		avatarSuffix = ""
	case let str where str.contains("/words"):
		pageID = ""
		avatarSuffix = ".words"
	case let str where str.contains("/work"):
		pageID = "work"
		avatarSuffix = ".work"
	case "/resume":
		pageID = "resume"
		avatarSuffix = ".resume"
	default:
		pageID = "home"
		avatarSuffix = ""
	}

	if page.title == "Four Oh Four!" {
		pageID = "four-oh-four"
		avatarSuffix = ".404"
	}

	switch pageID {
	case "words", "work":
		pageClass = "list"
	default:
		pageClass = ""
	}

	return (pageID, pageClass, avatarSuffix)
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

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
						item.addingFootnotes().deletingOccurrences(of: #"\+\+\+((.|\n)*)"#)
						if item.body.html.contains("+++") {
							Link("•••", url: item.path.absoluteString)
								.attribute(named: "title", value: "Read more")
								.class("read-more")
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
					item.addingFootnotes().deletingOccurrences(of: #"<p>\+\+\+<\/p>"#)
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

// MARK: - Main Layout

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

// MARK: - Components

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
					.raw(try! context.file(at: "Resources/images/avatar.\(metaData.avatarSuffix).svg").readAsString())
				]
			)
			
			List {
				ListItem {
					Link("About", url: "/")
				}
				.class(metaData.id == "home" ? "current" : "")
				ListItem {
					Link("Blog", url: "/words")
				}
				.class(metaData.id == "words" ? "current" : "")
				ListItem {
					Link("Work", url: "/work")
				}
				.class(metaData.id == "work" ? "current" : "")
				
				if metaData.id == "resume" {
					ListItem {
						Link("Résumé", url: "/resume")
					}
					.class("current")
				}
			}
		}
		.class("constrained")
	}
}

private struct SiteFooter: Component {
	var location: Location
	var context: PublishingContext<PeteSchaffner>

	var body: Component {
		Footer {
			List {
				ListItem {
					Span("Copyright \(Calendar.current.component(.year, from: Date()))")
				}
				ListItem {
					Link("Colophon", url: "/colophon")
				}
				ListItem {
					Link("RSS", url: Path.defaultForRSSFeed.absoluteString)
				}
			}
		}
		.class("constrained")
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

// MARK: - Extensions

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
		
		func inlineScript(at path: Path) -> Node<HTML.BodyContext> {
			Node<HTML.BodyContext>.script(.raw(try! context.file(at: path).readAsString()))
		}

		return .body(
			.id(metaData.id),
			.class(metaData.class),
			.components {
				SiteNav(location: location, context: context)
				Node<HTML.BodyContext>.main(
					.class("constrained"),
					.component(Content.Body(components: content).makingSmartSubstitutions())
				)
				SiteFooter(location: location, context: context)
				
				inlineScript(at: "Resources/js/nav.js")

				if location.path.absoluteString == "/" {
					inlineScript(at: "Resources/js/welcome.js")
				}

				if location.path.absoluteString == "/work" {
					inlineScript(at: "Resources/js/work.js")
				}
			}
		)
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

private extension Item where Site == PeteSchaffner {
	func addingFootnotes() -> Content.Body {
		var html = self.body.html
		let superscriptChars = ["1": "¹", "2": "²", "3": "³", "4": "⁴", "5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹"]
		let numberWords = ["1": "one", "2": "two", "3": "three", "4": "four", "5": "five", "6": "six", "7": "seven", "8": "eight", "9": "nine"]
		let footnoteReferenceRegex = try! NSRegularExpression(pattern: #"\[\^(\d)\]"#)
		var definitions: [String: String] = [:]

		while let match = footnoteReferenceRegex.matches(in: html, range: NSRange(html.startIndex..., in: html)).first {
			let number = String(html[Range(match.range(at: 1), in: html)!])
			let sup = Node<HTML.BodyContext>.element(named: "sup", nodes: [
				Link(superscriptChars[number]!, url: "#fn\(number)")
					.id("fnr\(number)")
					.attribute(named: "title", value: "See footnote")
					.class("fn-go").convertToNode()
			])

			guard let definition = self.metadata.footnote?.valueByPropertyName(name: numberWords[number]!) else {
				fatalError("Missing footnote definition for \"\(self.title)\" (\(self.path))")
			}

			definitions[number] = definition
			html = html.replacingCharacters(in: Range(match.range, in: html)!, with: sup.render())
		}

		if !definitions.isEmpty {
			html += List(definitions.sorted(by: <)) { definition in
				let link = Link("◊", url: "#fnr\(definition.key)").attribute(named: "title", value: "Return to article").class("fn-return")
				return ListItem {
					Node<HTML.BodyContext>.raw(MarkdownParser().parse(definition.value + link.render()).html)
				}
				.id("fn\(definition.key)")
			}
			.listStyle(.ordered)
			.class("footnotes")
			.render()
		}

		return Content.Body(html: html)
	}
}

// MARK: - Helper functions

private func metadataFor(page: Location) -> (id: String, class: String, avatarSuffix: String) {
	var pageID: String
	var pageClass: String
	var avatarSuffix: String

	switch page.path.absoluteString {
	case "/":
		pageID = "home"
		pageClass = ""
		avatarSuffix = "default"
	case "/words":
		pageID = "words"
		pageClass = "list"
		avatarSuffix = "words"
	case "/readlater":
		pageID = "readlater"
		pageClass = "list"
		avatarSuffix = "default"
	case let str where str.contains("/words"):
		pageID = "words"
		pageClass = ""
		avatarSuffix = "words"
	case "/work":
		pageID = "work"
		pageClass = "list"
		avatarSuffix = "work"
	case "/resume":
		pageID = "resume"
		pageClass = "list"
		avatarSuffix = "resume"
	default:
		pageID = ""
		pageClass = ""
		avatarSuffix = "default"
	}

	if page.title == "Four Oh Four!" {
		pageID = "four-oh-four"
		avatarSuffix = "404"
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

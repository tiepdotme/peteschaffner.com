import Foundation
import Publish
import Plot

extension PeteSchaffner {
	static func makeWorkPage(context: PublishingContext<PeteSchaffner>) -> Page {
		Page(path: "work", content: Content(title: "Work", body: Content.Body {
			IconSection()
			RadBlockSection()
			TextMateSection()
			ChromeSection()
			LinkinusSection()
			SourceIconPreviewSection()
			VicoSection()
			PotterSection()
		}))
	}
}

// MARK: - Sections

private struct IconSection: Component {
	var body: Component {
		WorkSection(
			title: "Icons",
			description: { Text("An assortment of icons made for various apps over the years: some that lived, some that died, and some that never came to pass.") },
			image: nil, id: "icons") {
			Figure(url: "/images/work/image2icon-icon.png", description: "Image2icon.app app icon") {
				Link("Image2icon", url: "https://img2icnsapp.com")
			}
			Figure(url: "/images/work/bear-icons.png", description: "Bear.app macOS app icon") {
				Link("Bear", url: "https://bear.app")
			}
			Figure(url: "/images/work/radblock-icon.png", description: "RadBlock.app app icon") {
				Text("RadBlock (more on that ")
				Link("below", url: "#radblock")
				Text(")")
			}
			Figure(url: "/images/work/chrome.png", description: "A Chrome for Mac icon replacement that looks at home on macOS 10.10+") { Text("A Chrome for Mac icon replacement that looks at home on macOS 10.10+") }
			Figure(url: "/images/work/emporter-icon.png", description: "Emporter.app alternate app icon") {
				Link("Emporter", url: "https://emporter.app")
				Text(" alternate icon")
			}
			Figure(url: "/images/work/watchlist.png", description: "App icon for Watchlist—a mythical TMDb client for iOS") {
				Text("Watchlist—a mythical ")
				Link("TMDb", url: "https://www.themoviedb.org")
				Text(" client for iOS")
			}
			Figure(url: "/images/work/cloudy1.png", description: "App icon for Cloudy—an Android CloudApp client") { Text("Cloudy—an Android CloudApp client") }
			Figure(url: "/images/work/cloudy2.png", description: "Cloudy alternate icon") { Text("Cloudy alternate icon") }
			Figure(url: "/images/work/chocolat.png", description: "Chocolat.app alternate app icon") {
				Link("Chocolat", url: "https://chocolatapp.com")
				Text(" alternate app icon")
			}
			Figure(url: "/images/work/sourceiconpreview-icon.png", description: "SourceIcon Preview.app app icon") {
				Text("SourceIcon Preview (more on that ")
				Link("below", url: "#sourceiconpreview")
				Text(")")
			}
			Figure(url: "/images/work/linkinus-icon.png", description: "Linkinus.app version 3 app icon") {
				Text("Linkinus (more on that ")
				Link("below", url: "#linkinus")
				Text(")")
			}
			Figure(url: "/images/work/emporter-radblock-prefs-icons.png", description: "RadBlock.app and Emporter.app preference window icons") { Text("RadBlock and Emporter preference window icons") }
			Figure(url: "/images/work/iterm2.png", description: "iTerm2.app preference window icons") {
				Link("iTerm2", url: "https://iterm2.com")
				Text(" preference window icons")
			}
		}
	}
}

private struct RadBlockSection: Component {
	var body: Component {
		WorkSection(title: "RadBlock", description: {
			Link("RadBlock", url: "https://radblock.app")
			Text(" is a Safari extension that efficiently gets rid of advertisements, trackers, and other annoyances. I had the great honor to design and make the logo, icons, website and some of the UI.")
		}, image: "/images/work/radblock-icon.png", id: "radblock") {
			Figure(url: "/images/work/radblock-popover.png", description: "RadBlock.app extension popover", sources: [Source(srcset: "/images/work/radblock-popover-dark.png", media: "(prefers-color-scheme: dark)")], attributes: [Attribute(name: "width", value: "332")])
			Figure(url: "/images/work/radblock-settings.png", description: "RadBlock.app preferences window", sources: [Source(srcset: "/images/work/radblock-settings-dark.png", media: "(prefers-color-scheme: dark)")], attributes: [Attribute(name: "width", value: "572")])
		}
	}
}

private struct TextMateSection: Component {
	var body: Component {
		WorkSection(title: "TextMate", description: {
			Text("I ")
			Link("forked TextMate", url: "https://github.com/peteschaffner/textmate")
			Text(" with the aim of making the bottom toolbars meld better with the text area and sidebar, then got carried away and drew new icons, made a dynamic dark theme that accounts for ")
			Link("Desktop Tinting", url: "https://developer.apple.com/design/human-interface-guidelines/macos/visual-design/dark-mode/")
			Text(", and did ")
			Link("lots of other little things", url: "https://github.com/peteschaffner/textmate/commits?author=peteschaffner")
			Text(".")
		}, image: nil, id: "textmate") {
			Figure(url: "/images/work/textmate-1.jpg", description: "TextMate.app light theme") {
				Text("Light theme")
			}
			Figure(url: "/images/work/textmate-2.jpg", description: "TextMate.app dynamic dark theme") {
				Text("Dynamic dark theme")
			}
		}
	}
}

private struct ChromeSection: Component {
	var body: Component {
		WorkSection(title: "Chrome for iOS & iPadOS", description: {
			Text("For six years I led the design of ")
			Link("Chrome for iOS/iPadOS", url: "https://itunes.apple.com/us/app/google-chrome/id535886823?mt=8")
			Text(", where I strove to make it a great browser and a respectable platform citizen.")
		}, image: "/images/work/chrome-ios-icon.png", id: "chrome") {
			Figure(url: "/images/work/chrome-ios.png", description: "Chrome on iPhone and iPad")
		}
	}
}

private struct LinkinusSection: Component {
	var body: Component {
		WorkSection(title: "Linkinus", description: {
			Text("As an avid user of ")
			Link("Linkinus", url: "https://www.macstories.net/reviews/linkinus/")
			Text(", I started working with the developers in late 2012 to design the next major version. Sadly it never came to pass, but it sure was fun dreaming…")
		}, image: "/images/work/linkinus-icon.png", id: "linkinus") {
			Figure(url: "/images/work/linkinus-1.jpg", description: "Linkinus.app onboarding step 1")
			Figure(url: "/images/work/linkinus-2.jpg", description: "Linkinus.app onboarding step 2")
			Figure(url: "/images/work/linkinus-3.jpg", description: "Linkinus.app onboarding step 3")
			Figure(url: "/images/work/linkinus-4.jpg", description: "Linkinus.app main window")
			Figure(url: "/images/work/linkinus-5.jpg", description: "Linkinus.app connection manager window")
		}
	}
}

private struct SourceIconPreviewSection: Component {
	var body: Component {
		WorkSection(title: "SourceIcon Preview", description: {
			Text("While working on version 3 of Linkinus, I found myself constantly wondering how my ")
			Link("source list", url: "https://developer.apple.com/design/human-interface-guidelines/macos/windows-and-views/sidebars/")
			Text(" template icons would look when rendered by the system (circa ")
			Link("OS X 10.8", url: "https://en.wikipedia.org/wiki/OS_X_Mountain_Lion")
			Text("), so I designed a simple app that would show me.")
		}, image: "/images/work/sourceiconpreview-icon.png", id: "sourceiconpreview") {
			Figure(url: "/images/work/sourceiconpreview-1.jpg", description: "SourceIcon Preview.app drag-and-drop window")
			Figure(url: "/images/work/sourceiconpreview-2.jpg", description: "SourceIcon Preview.app source list renderer window")
		}
	}
}

private struct VicoSection: Component {
	var body: Component {
		WorkSection(title: "Vico", description: {
			Text("I love Vim, and I love native text editors, so when ")
			Link("Vico", url: "https://github.com/vicoapp/vico")
			Text(" came on my radar, I jumped in and started contributing designs. Of particular interest to me were the completions and command bar interfaces.")
		}, image: nil, id: "vico") {
			Figure(url: "/images/work/vico-1.jpg", description: "Vico.app completions") {
				Text("Code completions with extra info popover")
			}
			Figure(url: "/images/work/vico-2.jpg", description: "Vico.app command bar help popover") {
				Text("Command bar with syntax placeholders and inline + popover help")
			}
			Figure(url: "/images/work/vico-3.jpg", description: "Vico.app command bar completions") {
				Text("Command bar with completions")
			}
		}
	}
}

private struct PotterSection: Component {
	var body: Component {
		WorkSection(title: "Pottery", description: {
			Text("What follows are wares I threw during my time in university. I considered changing majors and dreamt of one day being a studio potter. I guess there is still time…")
		}, image: nil, id: "pottery") {
			Figure(url: "/images/work/pottery-teapot.jpg", description: "Teapot")
			Figure(url: "/images/work/pottery-bamboo-teapot.jpg", description: "Teapot with bamboo handle")
			Figure(url: "/images/work/pottery-teabowl.jpg", description: "Raku teabowl")
			Figure(url: "/images/work/pottery-casserole.jpg", description: "Casserole")
			Figure(url: "/images/work/pottery-cruets.jpg", description: "Two cruets")
			Figure(url: "/images/work/pottery-jar.jpg", description: "Jar")
			Figure(url: "/images/work/pottery-mugs.jpg", description: "Two mugs")
			Figure(url: "/images/work/pottery-pitcher.jpg", description: "Pitcher")
			Figure(url: "/images/work/pottery-vase.jpg", description: "Flower vase")
		}
	}
}

// MARK: - Components

private struct Source: Component {
	var srcset: String
	var media: String

	var body: Component {
		Node<HTML.PictureContext>.source(.srcset(srcset), .media(media))
	}
}

private struct Figure: Component {
	var url: URLRepresentable
	var description: String?
	var sources: [Source]?
	var attributes: [Attribute<HTML.ImageContext>]?
	@ComponentBuilder var caption: ContentProvider
	let image: Image

	init(url: URLRepresentable, description: String? = nil, sources: [Source]? = nil, attributes: [Attribute<HTML.ImageContext>]? = nil, @ComponentBuilder caption: @escaping ContentProvider = { ComponentGroup() }) {
		self.url = url
		self.attributes = attributes
		self.sources = sources
		self.caption = caption
		self.image = Image(url: url, description: description ?? "")
	}

	var body: Component {
		Node<HTML.BodyContext>.element(named: "figure", nodes: [
			.picture(
				.unwrap(sources) {
					.forEach($0) {
						.source(.srcset($0.srcset), .media($0.media))
					}
				},
				.components {
					if let attributes = attributes {
						for attribute in attributes {
							image.attribute(attribute)
						}
					} else {
						image
					}
				}
			),
			.if(caption().members.count > 0, .element(named: "figcaption", nodes: [Node.components(caption)]))
		])
	}
}

private struct WorkSection: Component {
	var title: String
	@ComponentBuilder var description: ContentProvider
	var image: String?
	var id: String
	@ComponentBuilder var content: ContentProvider

	var body: Component {
		Node.section(
			.id(id),
			.unwrap(image) { .img(.src($0)) },
			.h1(.a(.text(title), .href("#\(id)"))),
			.p(.components(description)),
			.components(content)
		)
	}
}

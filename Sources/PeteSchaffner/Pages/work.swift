import Foundation
import Publish
import Plot

extension PeteSchaffner {
	static func workPage(context: PublishingContext<PeteSchaffner>) -> Page {
		Page(path: "work", content: Content(
				title: "Work", body: Content.Body(
					node: .group(
						icons,
						radBlock,
						textMate,
						chrome,
						linkinus,
						sourceIconPreview,
						vico,
						pottery
					)
				)
			)
		)
	}
}

private extension Node where Context: HTML.BodyContext {
	static func figure(_ nodes: Node<HTML.BodyContext>...) -> Node {
		.element(named: "figure", nodes: nodes)
	}

	static func figcaption(_ nodes: [Node<HTML.BodyContext>]) -> Node {
		.element(named: "figcaption", nodes: nodes)
	}

	static func figureAndCaption(of image: Node<HTML.PictureContext>, caption: Node<HTML.BodyContext>...) -> Node {
		.figure(
			.picture(image),
			.figcaption(caption)
		)
	}
}

private let icons = Node.section(
	.id("icons"),
	.h1(.a(.text("Icons"), .href("#icons"))),
	.p(.text("An assortment of icons made for various apps over the years: some that lived, some that died, and some that never came to pass.")),
	.figureAndCaption(
		of: .img(.src("/images/work/image2icon-icon.png"), .alt("Image2icon.app app icon")),
		caption: .a(.text("Image2icon"), .href("https://img2icnsapp.com"))
	),
	.figureAndCaption(
		of: .img(.src("/images/work/bear-icons.png"), .alt("Bear.app macOS app icons")),
		caption: .a(.text("Bear"), .href("https://bear.app"))
	),
	.figureAndCaption(
		of: .img(.src("/images/work/radblock-icon.png"), .alt("RadBlock.app app icon")),
		caption: .text("RadBlock (more on that "), .a(.text("below"), .href("#radblock"))
	),
	.figureAndCaption(
		of: .img(.src("/images/work/chrome.png"), .alt("A Chrome for Mac icon replacement that looks at home on macOS 10.10+")),
		caption: .text("A Chrome for Mac icon replacement that looks at home on macOS 10.10+")
	),
	.figureAndCaption(
		of: .img(.src("/images/work/emporter-icon.png"), .alt("Emporter.app alternate app icon")),
		caption: .a(.text("Emporter"), .href("https://emporter.app")), .text(" alternate icon")
	),
	.figureAndCaption(
		of: .img(.src("/images/work/watchlist.png"), .alt("App icon for Watchlist—a mythical TMDb client for iOS")),
		caption: .text("Watchlist—a mythical "), .a(.text("TMDb"), .href("https://www.themoviedb.org")), .text(" client for iOS")
	),
	.figureAndCaption(
		of: .img(.src("/images/work/cloudy1.png"), .alt("App icon for Cloudy—an Android CloudApp client")),
		caption: .text("Cloudy—an Android CloudApp client")
	),
	.figureAndCaption(
		of: .img(.src("/images/work/cloudy2.png"), .alt("Cloudy alternate icon")),
		caption: .text("Cloudy alternate icon")
	),
	.figureAndCaption(
		of: .img(.src("/images/work/chocolat.png"), .alt("Chocolat.app alternate app icon")),
		caption: .a(.text("Chocolat"), .href("https://chocolatapp.com")), .text(" alternate app icon")
	),
	.figureAndCaption(
		of: .img(.src("/images/work/sourceiconpreview-icon.png"), .alt("SourceIcon Preview.app app icon")),
		caption: .text("SourceIcon Preview (more on that "), .a(.text("below"), .href("#sourceiconpreview")), .text(")")
	),
	.figureAndCaption(
		of: .img(.src("/images/work/linkinus-icon.png"), .alt("Linkinus.app version 3 app icon")),
		caption: .text("Linkinus (more on that "), .a(.text("below"), .href("#linkinus")), .text(")")
	),
	.figureAndCaption(
		of: .img(.src("/images/work/emporter-radblock-prefs-icons.png"), .alt("RadBlock.app and Emporter.app preference window icons")),
		caption: .text("RadBlock and Emporter preference window icons")
	),
	.figureAndCaption(
		of: .img(.src("/images/work/iterm2.png"), .alt("iTerm2.app preference window icons")),
		caption: .a(.text("iTerm2"), .href("https://iterm2.com")), .text(" preference window icons")
	)
)
private let radBlock = Node.section(
	.id("radblock"),
	.img(.src("/images/work/radblock-icon.png"), .alt("RadBlock.app app icon")),
	.h1(.a(.text("RadBlock"), .href("#radblock"))),
	.p(.a(.text("RadBlock"), .href("https://radblock.app")), .text(" is a Safari extension that efficiently gets rid of advertisements, trackers, and other annoyances. I had the great honor to design and make the logo, icons, website and some of the UI.")),
	.figure(.picture(
		.source(.srcset("/images/work/radblock-popover-dark.png"), .media("(prefers-color-scheme: dark)")),
		.img(.src("/images/work/radblock-popover.png"), .alt("RadBlock.app extension popover"), .attribute(named: "width", value: "332"))
	)),
	.figure(.picture(
		.source(.srcset("/images/work/radblock-settings-dark.png"), .media("(prefers-color-scheme: dark)")),
		.img(.src("/images/work/radblock-settings.png"), .alt("RadBlock.app preferences window"), .attribute(named: "width", value: "572"))
	))
)
private let textMate = Node.section(
	.id("textmate"),
	.h1(.a(.text("TextMate"), .href("#textmate"))),
	.p(
		.text("I "),
		.a(.text("forked TextMate"), .href("https://github.com/peteschaffner/textmate")),
		.text(" with the aim of making the bottom toolbars meld better with the text area and sidebar, then got carried away and drew new icons, made a dynamic dark theme that accounts for "),
		.a(.text("Desktop Tinting"), .href("https://developer.apple.com/design/human-interface-guidelines/macos/visual-design/dark-mode/")),
		.text(", and did "),
		.a(.text("lots of other little things"), .href("https://github.com/peteschaffner/textmate/commits?author=peteschaffner")),
		.text(".")
	),
	.figureAndCaption(
		of: .img(.src("/images/work/textmate-1.jpg"), .alt("TextMate.app light theme")),
		caption: .text("Light theme")
	),
	.figureAndCaption(
		of: .img(.src("/images/work/textmate-2.jpg"), .alt("TextMate.app dynamic dark theme")),
		caption: .text("Dynamic dark theme")
	)
)
private let chrome = Node.section(
	.id("chrome"),
	.img(.src("/images/work/chrome-ios-icon.png"), .alt("Chrome for iOS app icon")),
	.h1(.a(.text("Chrome for iOS & iPadOS"), .href("#chrome"))),
	.p(.text("For six years I led the design of "), .a(.text("Chrome for iOS/iPadOS"), .href("https://itunes.apple.com/us/app/google-chrome/id535886823?mt=8")), .text(", where I strove to make it a great browser and a respectable platform citizen.")),
	.figure(.picture(.img(.src("/images/work/chrome-ios.png"), .alt("Chrome on iPhone and iPad"))))
)
private let linkinus = Node.section(
	.id("linkinus"),
	.img(.src("/images/work/linkinus-icon.png"), .alt("Linkinus.app version 3 app icon")),
	.h1(.a(.text("Linkinus"), .href("#linkinus"))),
	.p(.text("As an avid user of "), .a(.text("Linkinus"), .href("https://www.macstories.net/reviews/linkinus/")), .text(", I started working with the developers in late 2012 to design the next major version. Sadly it never came to pass, but it sure was fun dreaming…")),
	.figure(.picture(.img(.src("/images/work/linkinus-1.jpg"), .alt("Linkinus.app onboarding step 1")))),
	.figure(.picture(.img(.src("/images/work/linkinus-2.jpg"), .alt("Linkinus.app onboarding step 2")))),
	.figure(.picture(.img(.src("/images/work/linkinus-3.jpg"), .alt("Linkinus.app onboarding step 3")))),
	.figure(.picture(.img(.src("/images/work/linkinus-4.jpg"), .alt("Linkinus.app main window")))),
	.figure(.picture(.img(.src("/images/work/linkinus-5.jpg"), .alt("Linkinus.app connection manager window"))))
)
private let sourceIconPreview = Node.section(
	.id("sourceiconpreview"),
	.img(.src("/images/work/sourceiconpreview-icon.png"), .alt("SourceIcon Preview.app app icon")),
	.h1(.a(.text("SourceIcon Preview"), .href("#sourceiconpreview"))),
	.p(
		.text("While working on version 3 of Linkinus, I found myself constantly wondering how my "),
		.a(.text("source list"), .href("https://developer.apple.com/design/human-interface-guidelines/macos/windows-and-views/sidebars/")),
		.text(" template icons would look when rendered by the system (circa "),
		.a(.text("OS X 10.8"), .href("https://en.wikipedia.org/wiki/OS_X_Mountain_Lion")),
		.text("), so I designed a simple app that would show me.")),
	.figure(.picture(.img(.src("/images/work/sourceiconpreview-1.jpg"), .alt("SourceIcon Preview.app drag-and-drop window")))),
	.figure(.picture(.img(.src("/images/work/sourceiconpreview-2.jpg"), .alt("SourceIcon Preview.app source list renderer window"))))
)
private let vico = Node.section(
	.id("vico"),
	.h1(.a(.text("Vico"), .href("#vico"))),
	.p(.text("I love Vim, and I love native text editors, so when "), .a(.text("Vico"), .href("https://github.com/vicoapp/vico")), .text(" came on my radar, I jumped in and started contributing designs. Of particular interest to me were the completions and command bar interfaces.")),
	.figureAndCaption(
		of: .img(.src("/images/work/vico-1.jpg"), .alt("Vico.app completions")),
		caption: .text("Code completions with extra info popover")),
	.figureAndCaption(
		of: .img(.src("/images/work/vico-2.jpg"), .alt("Vico.app command bar help popover")),
		caption: .text("Command bar with syntax placeholders and inline + popover help")),
	.figureAndCaption(
		of: .img(.src("/images/work/vico-3.jpg"), .alt("Vico.app command bar completions")),
		caption: .text("Command bar with completions"))
)
private let pottery = Node.section(
	.id("pottery"),
	.h1(.a(.text("Pottery"), .href("#pottery"))),
	.p(.text("What follows are wares I threw during my time in university. I considered changing majors and dreamt of one day being a studio potter. I guess there is still time…")),
	.figure(.picture(.img(.src("/images/work/pottery-teapot.jpg"), .alt("Teapot")))),
	.figure(.picture(.img(.src("/images/work/pottery-bamboo-teapot.jpg"), .alt("Teapot with bamboo handle")))),
	.figure(.picture(.img(.src("/images/work/pottery-teabowl.jpg"), .alt("Raku teabowl")))),
	.figure(.picture(.img(.src("/images/work/pottery-casserole.jpg"), .alt("Casserole")))),
	.figure(.picture(.img(.src("/images/work/pottery-cruets.jpg"), .alt("Two cruets")))),
	.figure(.picture(.img(.src("/images/work/pottery-jar.jpg"), .alt("Jar")))),
	.figure(.picture(.img(.src("/images/work/pottery-mugs.jpg"), .alt("Two mugs")))),
	.figure(.picture(.img(.src("/images/work/pottery-pitcher.jpg"), .alt("Pitcher")))),
	.figure(.picture(.img(.src("/images/work/pottery-vase.jpg"), .alt("Flower vase"))))
)

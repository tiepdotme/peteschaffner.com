import Foundation
import Publish
import Plot

extension PeteSchaffner {
    static func resumePage(context: PublishingContext<PeteSchaffner>) -> Page {
        Page(
            path: "resume", content: Content(
                title: "Résumé", body: Content.Body(
                    node: .group(
                        .blockquote(.text("I’m a technical and self-driven software designer with 10 years of experience building beautiful and usable interfaces for the Mac, iPhone and iPad. I give a damn.")),
                        .h2(.text("Personal Info")),
                        .ul(
                            .li(
                                .raw(try! context.file(at: "Resources/images/resume.work.svg").readAsString()),
                                .a(.text("peteschaffner.com/work"), .href("/work"))
                            ),
                            .li(
                                .raw(try! context.file(at: "Resources/images/resume.email.svg").readAsString()),
                                .a(.text("hello@peteschaffner.com"), .href("mailto:hello@peteschaffner.com"))
                            ),
                            .li(
                                .raw(try! context.file(at: "Resources/images/resume.phone.svg").readAsString()),
                                .a(.text("+33 (0)6 42 73 18 05"), .href("tel:+33642731805"))
                            ),
                            .li(
                                .raw(try! context.file(at: "Resources/images/resume.address.svg").readAsString()),
                                .a(.text("St. Nom La Bretèche, France"), .href("https://maps.apple.com/?address=11%20Rue%20Lecoq,%2078860%20Saint-Nom-la-Bret%C3%A8che,%20France&amp;ll=48.863828,2.028852&amp;q=11%20Rue%20Lecoq&amp;_ext=EiYp7/1qaPxtSEAxTiX0M5MtAEA5bdOQxCJvSEBBNjYdgYpJAEBQBA%3D%3D"))
                            )
                        ),
						skillsAndTools,
                        experience,
						education,
						references
                    )
                )
            )
        )
    }
}

private let skillsAndTools = Node.group(
	.h2(.text("Skills & tools")),

	// Design
	.header(
		.id("design"),
		.h3(.a(.text("Design"), .href("#design")))
	),
	.ul(
		.li(.text("Interface/interaction/icon design, prototyping, animation")),
		.li(.text("Sketch, Pixelmator [Pro], PaintCode")),
		.li(.text("Xcode (Interface Builder, Playgrounds, SwiftUI Previews, LLDB, etc.), Origami Studio")),
		.li(.text("Typography, ceramics"))
	),

	// Technical
	.header(
		.id("technical"),
		.h3(.a(.text("Technical"), .href("#technical")))
	),
	.ul(
		.li(.text("Swift, Objective-C")),
		.li(.text("UIKit, AppKit, Auto Layout, Core Animation, SwiftUI")),
		.li(.text("HTML, CSS, JavaScript")),
		.li(.text("Git, Vim, Zsh, Xcode")),
		.li(.text("macOS, iOS, iPadOS, Unix"))
	)
)

private var experience: Node<HTML.BodyContext> {
	let shinyFrog = Node.group(
		.header(
			.id("shinyfrog"),
			.h3(.a(.text("Shiny Frog"), .href("#shinyfrog"))),
			.time(.text("2020–Present"), .attribute(named: "datetime", value: "P1Y")),
			.h4(.text("Designer & wannabe programmer"))
		),
		.ul(
			.li(.a(.text("Bear"), .href("https://bear.app")), .text(" interface and app icon")),
			.li(.a(.text("Panda"), .href("https://bear.app/alpha")), .text(" interface and website")),
			.li(.a(.text("Image2icon"), .href("https://img2icnsapp.com")), .text(" app icon"))
		)
	)

	let google = Node.group(
		.header(
			.id("google"),
			.h3(.a(.text("Google"), .href("#google"))),
			.time(.text("2014–2020"), .attribute(named: "datetime", value: "P6Y")),
			.h4(
				.text("Design lead of "),
				.a(.text("Chrome for iOS/iPadOS"), .href("/work/#chrome"))
			)
		),
		.ul(
			.li(.text("Lead functional and aesthetic redesign of the entire app")),
			.li(.text("Initiated migration to MVC and Auto Layout in order to facilitate design handoff")),
			.li(.text("Pushed for adoption of new OS capabilities and APIs/frameworks")),
			.li(.text("Prototyped new features natively")),
			.li(.text("Implemented my own designs")),
			.li(.text("Mentored new designers and engineers unfamiliar with iOS development")),
			.li(.text("Designed an experimental, unreleased iOS app")),
			.li(.text("Created a set of Origami and Sketch resource libraries")),
			.li(.text("Created an internal Framer.js toolchain for easier sharing and code reuse")),
			.li(.text("Created a set of internal Framer.js modules for rapid prototyping")),
			.li(.text("Advocated for platform-first design and development")),
			.li(.text("Worked closely with and sat amongst the engineering team")),
			.li(.text("Worked independently in France with my manager located in the US"))
		)
	)

	let warewolf = Node.group(
		.header(
			.id("warewolf"),
			.h3(.a(.text("Warewolf"), .href("#warewolf"))),
			.time(.text("2018–2019"), .attribute(named: "datetime", value: "P1Y")),
			.h4(.text("Owner, designer, & developer"))
		),
		.ul(
			.li(.text("Took over ownership of [Espresso.app](https://espressoapp.com), a web development IDE")),
			.li(.text("Shipped a couple minor updates")),
			.li(.text("Began work on a new major version")),
			.li(.text("Created a multi-channel distribution build system")),
			.li(.text("Created a licensing and transactional/marketing email system"))
		)
	)

	let evergig = Node.group(
		.header(
			.id("evergig"),
			.h3(.a(.text("Evergig"), .href("#evergig"))),
			.time(.text("2013–2014"), .attribute(named: "datetime", value: "P1Y")),
			.h4(.text("Web lead, developer, & designer"))
		),
		.ul(
			.li(.text("Managed and lead the web app team (remotely at first, then in person)")),
			.li(.text("Was the sole front-end developer")),
			.li(.text("Lead visual and architectural redesign of the 2.0 web app")),
			.li(.text("Worked with Angular and authored multiple directives")),
			.li(.text("Split up our Angular architecture into a series of CommonJS modules")),
			.li(.text("Improved our test coverage")),
			.li(.text("Interviewed prospective web employees")),
			.li(.text("Managed owner expectations and acted as a designer/developer proxy")),
			.li(.text("Wrote and proofread marketing copy"))
		)
	)

	let irongate = Node.group(
		.header(
			.id("irongate-creative"),
			.h3(.a(.text("IronGate Creative"), .href("#irongate-creative"))),
			.time(.text("2010–2013"), .attribute(named: "datetime", value: "P3Y")),
			.h4(.text("Designer & developer"))
		),
		.ul(
			.li(.text("Owned design and implementation of all web projects")),
			.li(.text("Defined our workflow and standard for web projects")),
			.li(.text("Handled email marketing campaigns")),
			.li(.text("Designed and developed an iOS application")),
			.li(
				.a(.text("Designed"), .href("/resume-references/stronger-nation-2013")),
				.text(" and developed an annual report in digital and print forms")
			),
			.li(
				.text("Designed and developed an "),
				.a(.text("online publication"), .href("http://focus.luminafoundation.org/focus-archive/"))
			),
			.li(.text("Created logos and brand guides")),
			.li(.text("Designed print ads, publications and billboards")),
			.li(.text("Designed business cards and letterhead")),
			.li(.text("Performed CMS training for clients")),
			.li(.text("Provided IT support to clients")),
			.li(.text("Adopted company IT and networking responsibilities"))
		)
	)

	let freelance = Node.group(
		.header(
			.id("freelance"),
			.h3(.a(.text("Freelance & open source"), .href("#freelance"))),
			.time(.text("2010–Present"), .attribute(named: "datetime", value: "P11Y"))
		),
		.ul(
			.li(
				.text("Designed and made the "),
				.a(.text("RadBlock"), .href("/work/#radblock")),
				.text(" logo, icons, website and some of the UI")
			),
			.li(
				.text("Maintained a personal fork of TextMate.app "),
				.a(.text("focused on improved UI/UX"), .href("/work/#textmate"))
			),
			.li(
				.text("Designed "),
				.a(.text("version 3 of Linkinus.app"), .href("/work/#linkinus"))
			),
			.li(
				.text("Contributed to "),
				.a(.text("Vico.app"), .href("/work/#vico")),
				.text(" design and product direction")
			),
			.li(
				.text("Designed UI elements used in "),
				.a(.text("Chocolat.app"), .href("http://chocolatapp.com/"))
			),
			.li(
				.text("Contributed "),
				.a(.text("settings icons"), .href("https://github.com/gnachman/iTerm2/pull/203) to [iTerm2](https://iterm2.com"))
			),
			.li(
				.text("Authored "),
				.a(.text("multiple Framer.js modules"), .href("https://github.com/search?q=user%3Apeteschaffner+framer")),
				.text(", contributed to the library, and actively talked with the devs about how to improve the tool")
			),
			.li(
				.a(.text("Designed"), .href("http://hagerstown.github.io/")),
				.text(" and "),
				.a(.text("developed"), .href("https://github.com/hagerstown/comprehensive-plan")),
				.text(" Comprehensive Plan for the town of Hagerstown, IN")
			),
			.li(
				.text("Created diagrams and illustrations for the "),
				.a(.text("Explore Theatre"), .href("https://www.pearson.com/us/higher-education/product/O-Hara-Explore-Theatre-Standalone-Access-Card/9780205028726.html")),
				.text(" interactive textbook")
			)
		)
	)

	return Node.group(
		.h2(.text("Experience")),
		shinyFrog, google, warewolf, evergig, irongate, freelance
	)
}

private let education = Node.group(
	.h2(.text("Education")),
	.header(
		.id("ball-state"),
		.h3(.a(.text("College of Fine Arts, Ball State University"), .href("#ball-state"))),
		.time(.text("2006–2010"), .attribute(named: "datetime", value: "P4Y")),
		.h4(.text("Bachelor of Fine Arts, Visual Communication"))
	),
	.ul(
		.li(.text("3.8 GPA")),
		.li(.text("Dean's List for 8 consecutive semesters")),
		.li(
			.text("Graduated "),
			.em("magna cum laude"),
			.text(" from the Honors College")
		)
	)
)

private let references = Node.group(
	.h2(.text("References")),
	.header(
		.h3(.text("AbdelKarim Mardini")),
		.h4(.text("Senior product manager at Google"))
	),
	.p(.a(.text("mardini@google.com"), .href("mailto:mardini@google.com"))),

	.header(
		.h3(.text("Alex Ainslie")),
		.h4(.text("Design director of Google Chrome"))
	),
	.p(.a(.text("ainslie@google.com"), .href("mailto:ainslie@google.com"))),

	.header(
		.h3(.text("Jean-Baptiste Bégué")),
		.h4(.text("Engineer at Apple"))
	),
	.p(.a(.text("jb.begue@gmail.com"), .href("mailto:jb.begue@gmail.com"))),

	.header(
		.h3(.text("Mikey Pulaski")),
		.h4(
			.text("Owner, engineer, & designer at "),
			.a(.text("Young Dynasty"), .href("https://www.youngdynasty.net"))
		)
	),
	.p(.a(.text("mikey@youngdynasty.net"), .href("mailto:mikey@youngdynasty.net")))
)

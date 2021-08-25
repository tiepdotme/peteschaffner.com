import Foundation
import Publish
import Plot

extension PeteSchaffner {
    static func makeResumePage(context: PublishingContext<PeteSchaffner>) -> Page {
        Page(path: "resume", content: Content(title: "Résumé", body: Content.Body {
			Intro(context: context)
			SkillsAndToolsSection()
			ExperienceSection()
			EducationSection()
			ReferencesSection()
		}))
    }
}

// MARK: - Sections

private struct Intro: Component {
	var context: PublishingContext<PeteSchaffner>

	var body: Component {
		ComponentGroup {
			ResumeSection() {
				Node.blockquote(.strong(.text("Hi, I'm Pete and this is my résumé.")), .text(" I’m a self-driven software designer/developer with 10 years of experience building beautiful and usable interfaces for the Mac, iPhone, and iPad. I give a damn."))
			}
		}
	}

	private func inlineSVG(named name: String) -> Node<HTML.BodyContext> {
		Node.raw(try! context.file(at: "Resources/images/resume.\(name).svg").readAsString())
	}
}

private struct SkillsAndToolsSection: Component {
	var body: Component {
		ResumeSection(name: "Skills & tools") {
			ResumeHeader(header: "Design", subHead: nil, time: nil, id: "design")
			List {
				ListItem("Interface/interaction/icon design, prototyping, animation")
				ListItem("Sketch, Pixelmator [Pro], PaintCode")
				ListItem("Xcode (Interface Builder, Playgrounds, SwiftUI Previews, LLDB, etc.), Origami Studio")
				ListItem("Typography, ceramics")
			}

			ResumeHeader(header: "Technical", subHead: nil, time: nil, id: "technical")
			List {
				ListItem("Swift, Objective-C")
				ListItem("UIKit, AppKit, Auto Layout, Core Animation, SwiftUI")
				ListItem("HTML, CSS, JavaScript")
				ListItem("Git, Vim, Zsh, Xcode")
				ListItem("macOS, iOS, iPadOS, Unix")
			}
		}
	}
}

private struct ExperienceSection: Component {
	var body: Component {
		ResumeSection(name: "Experience") {
			ResumeHeader(header: "Shiny Frog", subHead: "Designer & wannabe programmer", time: DateRange(begin: 2020, end: nil), id: "shinyfrog")
			List {
				ListItem {
					Link("Bear", url: "https://bear.app")
					Text(" interface and app icon")
				}
				ListItem {
					Link("Panda", url: "https://bear.app/alpha")
					Text(" interface, app icon, and website")
				}
				ListItem {
					Link("Image2icon", url: "https://img2icnsapp.com")
					Text(" app icon")
				}
			}

			ResumeHeader(header: "Google", subHead: ComponentGroup {
					Text("Design lead of ")
					Link("Chrome for iOS/iPadOS", url: "/work/#chrome")
				}, time: DateRange(begin: 2014, end: 2020), id: "google")
			List {
				ListItem("Lead functional and aesthetic redesign of the entire app")
				ListItem("Initiated migration to MVC and Auto Layout in order to facilitate design handoff")
				ListItem("Pushed for adoption of new OS capabilities and APIs/frameworks")
				ListItem("Prototyped new features natively")
				ListItem("Implemented my own designs")
				ListItem("Mentored new designers and engineers unfamiliar with iOS development")
				ListItem("Designed an experimental, unreleased iOS app")
				ListItem("Created a set of Origami and Sketch resource libraries")
				ListItem("Created an internal Framer.js toolchain for easier sharing and code reuse")
				ListItem("Created a set of internal Framer.js modules for rapid prototyping")
				ListItem("Advocated for platform-first design and development")
				ListItem("Worked closely with and sat amongst the engineering team")
				ListItem("Worked independently in France with my manager located in the US")
			}

			ResumeHeader(header: "Warewolf", subHead: "Owner, designer, & developer", time: DateRange(begin: 2018, end: nil), id: "warewolf")
			List {
				ListItem {
					Text("Took over ownership of ")
					Link("Espresso.app", url: "https://espressoapp.com")
					Text(", a web development IDE")
				}
				ListItem("Shipped a couple minor updates")
				ListItem("Began work on a new major version")
				ListItem("Created a multi-channel distribution build system")
				ListItem("Created a licensing and transactional/marketing email system")
			}

			ResumeHeader(header: "Evergig", subHead: "Web lead, developer, & designer", time: DateRange(begin: 2013, end: 2014), id: "evergig")
			List {
				ListItem("Managed and lead the web app team (remotely at first, then in person)")
				ListItem("Was the sole front-end developer")
				ListItem("Lead visual and architectural redesign of the 2.0 web app")
				ListItem("Worked with Angular and authored multiple directives")
				ListItem("Split up our Angular architecture into a series of CommonJS modules")
				ListItem("Improved our test coverage")
				ListItem("Interviewed prospective web employees")
				ListItem("Managed owner expectations and acted as a designer/developer proxy")
				ListItem("Wrote and proofread marketing copy")
			}

			ResumeHeader(header: "IronGate Creative", subHead: "Web lead, developer, & designer", time: DateRange(begin: 2010, end: 2013), id: "irongate-creative")
			List {
				ListItem("Owned design and implementation of all web projects")
				ListItem("Defined our workflow and standard for web projects")
				ListItem("Handled email marketing campaigns")
				ListItem("Designed and developed an iOS application")
				ListItem {
					Link("Designed", url: "/resume-references/stronger-nation-2013")
					Text(" and developed an annual report in digital and print forms")
				}
				ListItem {
					Text("Designed and developed an ")
					Link("online publication", url: "http://focus.luminafoundation.org/focus-archive/")
				}
				ListItem("Created logos and brand guides")
				ListItem("Designed print ads, publications and billboards")
				ListItem("Designed business cards and letterhead")
				ListItem("Performed CMS training for clients")
				ListItem("Provided IT support to clients")
				ListItem("Adopted company IT and networking responsibilities")
			}

			ResumeHeader(header: "Freelance & open source", subHead: nil, time: DateRange(begin: 2010, end: nil), id: "freelance")
			List {
				ListItem {
					Text("Designed and made the ")
					Link("RadBlock", url: "/work/#radblock")
					Text(" logo, icons, website and some of the UI")
				}
				ListItem {
					Text("Maintained a personal fork of TextMate.app ")
					Link("focused on improved UI/UX", url: "/work/#textmate")
				}
				ListItem {
					Text("Designed ")
					Link("version 3 of Linkinus.app", url: "/work/#linkinus")
				}
				ListItem {
					Text("Contributed to ")
					Link("Vico.app", url: "/work/#vico")
					Text(" design and product direction")
				}
				ListItem {
					Text("Designed UI elements used in ")
					Link("Chocolat.app", url: "http://chocolatapp.com/")
				}
				ListItem {
					Text("Contributed ")
					Link("settings icons", url: "https://github.com/gnachman/iTerm2/pull/203) to [iTerm2](https://iterm2.com")
				}
				ListItem {
					Text("Authored ")
					Link("multiple Framer.js modules", url: "https://github.com/search?q=user%3Apeteschaffner+framer")
					Text(", contributed to the library, and actively talked with the devs about how to improve the tool")
				}
				ListItem {
					Link("Designed", url: "http://hagerstown.github.io/")
					Text(" and ")
					Link("developed", url: "https://github.com/hagerstown/comprehensive-plan")
					Text(" Comprehensive Plan for the town of Hagerstown, IN")
				}
				ListItem {
					Text("Created diagrams and illustrations for the ")
					Link("Explore Theatre", url: "https://www.pearson.com/us/higher-education/product/O-Hara-Explore-Theatre-Standalone-Access-Card/9780205028726.html")
					Text(" interactive textbook")
				}
			}
		}
	}
}

private struct EducationSection: Component {
	var body: Component {
		ResumeSection(name: "Education") {
			ResumeHeader(header: "College of Fine Arts, Ball State University", subHead: "Bachelor of Fine Arts, Visual Communication", time: DateRange(begin: 2006, end: 2010), id: "ball-state")
			List {
				ListItem("3.8 GPA")
				ListItem("Dean's List for 8 consecutive semesters")
				ListItem {
					Text("Graduated ")
					Node.em("magna cum laude")
					Text(" from the Honors College")
				}
			}
		}
	}
}

private struct ReferencesSection: Component {
	var body: Component {
		ResumeSection(name: "References") {
			ResumeHeader(header: "AbdelKarim Mardini", subHead: "Senior product manager at Google", time: nil, id: "mardini")
			Paragraph(Link("mardini@google.com", url: "mailto:mardini@google.com"))

			ResumeHeader(header: "Alex Ainslie", subHead: "Design director of Google Chrome", time: nil, id: "ainslie")
			Paragraph(Link("ainslie@google.com", url: "mailto:ainslie@google.com"))

			ResumeHeader(header: "Jean-Baptiste Bégué", subHead: "Engineer at Apple", time: nil, id: "begue")
			Paragraph(Link("jb.begue@gmail.com", url: "mailto:jb.begue@gmail.com"))

			ResumeHeader(
				header: "Mikey Pulaski",
				subHead: ComponentGroup {
					Text("Owner, engineer, & designer at ")
					Link("Young Dynasty", url: "https://www.youngdynasty.net")
				},
				time: nil,
				id: "mikey"
			)
			Paragraph(Link("mikey@youngdynasty.net", url: "mailto:mikey@youngdynasty.net"))
		}
	}
}

// MARK: - Components & Helpers

private struct ResumeSection: Component {
	var name: String?
	@ComponentBuilder var content: ContentProvider

	var body: Component {
		Node.section(
			.unwrap(name) { .h2(.text($0)) },
			.components(content)
		)
	}
}

private struct ResumeHeader: Component {
	var header: String
	var subHead: Any?
	var time: DateRange?
	var id: String

	var body: Component {
		Header {
			H3(Link(header, url: "#\(id)"))
			if let time = self.time {
				Node.time(.text(time.text), .attribute(named: "datetime", value: time.dateTime))
			}
			if let subHead = self.subHead {
				switch subHead {
				case is String:
					H4(subHead as! String)
				case is ComponentGroup:
					H4(subHead as! ComponentGroup)
				default:
					H4(subHead as! String)
				}
			}
		}.id(id)
	}

}

private struct DateRange {
	let begin: Int
	let end: Int?

	var text: String {
		let endString = end != nil ? "\(end!)" : "Present"
		return "\(begin)–\(endString)"
	}
	var dateTime: String {
		let count = (end ?? Calendar.current.component(.year, from: Date())) - begin
		return "P\(count)Y"
	}
}

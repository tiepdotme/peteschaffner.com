import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import SwiftSoup

let urlString = CommandLine.arguments.last!

do {
	if let url = URL(string: urlString), url.host != nil {
		let html = try String(contentsOf: url)
		let title = try SwiftSoup.parse(html).title()
		let sanitizedTitle = title.replacingOccurrences(of: #"""#, with: #"\""#)
		
		print(sanitizedTitle)
	}
} catch {}

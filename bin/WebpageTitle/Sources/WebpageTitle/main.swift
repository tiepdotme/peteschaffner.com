import Foundation
import SwiftSoup

let urlString = CommandLine.arguments.last!

do {	
	if let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue), !urlString.isEmpty {
		let length = urlString.utf16.count
		if let match = detector.firstMatch(in: urlString, options: [], range: NSRange(location: 0, length: length)) {
			// it is a link, if the match covers the whole string
			if match.range.length == length {
				if let url = URL(string: urlString) { 
					let html = try String(contentsOf: url)
					let title = try SwiftSoup.parse(html).title()
					let sanitizedTitle = title.replacingOccurrences(of: #"""#, with: #"\""#)
					
					print(sanitizedTitle)
				}
			}
		}
	}
}

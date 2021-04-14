#if !os(Linux)
import Foundation
import Publish

final class Watcher {
    private static let ignoredDirNames = ["Output", "resume-references"]

    static var sources: [Path: DispatchSourceFileSystemObject] = [:]

    private static var root: Path?

    private static var watchCount = 0

    static func watch(path: Path, isRoot: Bool = false, action: @escaping (() throws -> ())) throws {
        if isRoot {
            self.root = path
            sources.removeAll()
            watchCount += 1
//            print("Watch count: \(watchCount)")
        }
        let pathURL = URL(fileURLWithPath: path.string)
        guard !ignoredDirNames.contains(pathURL.lastPathComponent) else {
            return
        }
        let fm = FileManager.default
        if sources[path] == nil  {
            let sourceDirDescrptr = open(path.string, O_EVTONLY)
            guard sourceDirDescrptr != -1 else { return }
            let eventSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: sourceDirDescrptr, eventMask: DispatchSource.FileSystemEvent.write, queue: nil)
            eventSource.setEventHandler {
                do {
//                    print("Changed: \(pathURL.lastPathComponent)")
                    try action()
                    if let root = root {
                        try watch(path: root, isRoot: true, action: action)
                    }
                } catch {
                    print(error)
                }
            }
            eventSource.resume()
            sources[path] = eventSource
//            print("registered for \(path)")
        }

        let res = try pathURL.resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
        guard (res.isDirectory == true) else {
            return
        }

        let contents = try fm.contentsOfDirectory(
            at: URL(fileURLWithPath: path.string),
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        for item in contents {
            try watch(path: Path(item.path), action: action)
        }
    }
}
#endif

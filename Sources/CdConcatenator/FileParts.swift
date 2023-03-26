import Foundation

func createInstructionFileFromParts(withParts fileParts: [String], forDir dir: String) -> String {
    var formatedFileParts = fileParts.map { part in
        return "file " + part
    }
    
    formatedFileParts.sort()
    
    let contents = formatedFileParts.joined(separator: "\n")
    
    let filePath = "\(dir)/mylist.txt"
    FileManager.default.createFile(atPath: filePath, contents: contents.data(using: String.Encoding.utf8))
    return filePath
}

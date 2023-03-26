import Foundation

enum MovieError: Error {
    case noUrl
    case differentParentDir
    case differentFileExtensions
    case lowMacOsVersion
}

struct Movie {
    private(set) var cdFilePaths: [String]
    private(set) var destinationPath: String = ""
    private(set) var instructionFilePath: String
    
    init(cdFilePaths: [String], instructionFilePath: String) throws {
        assert(cdFilePaths.count == 2)
        
        self.cdFilePaths = cdFilePaths
        self.instructionFilePath = instructionFilePath
        self.destinationPath = try getDestinationPath(forCdFilePaths: cdFilePaths)
    }
    
    private func getDestinationPath(forCdFilePaths cdFilePath: [String]) throws -> String {
        var parentDir: URL?
        var fileExtension: String?
        
        // Get and validate parent dir and file extension
        try cdFilePath.forEach { filePath in
            guard let fileUrl = createUrl(forPath: filePath) else {
                throw MovieError.noUrl
            }
            
            fileExtension = try{
                let currFileExtension = fileUrl.pathExtension
                if  fileExtension == nil {
                    return currFileExtension
                }
                if fileExtension != currFileExtension {
                    throw MovieError.differentFileExtensions
                }
                return currFileExtension
            }()
            
            parentDir = try {
                let currParentDir = fileUrl.deletingLastPathComponent()
                if parentDir == nil {
                    return currParentDir
                }
                if parentDir?.absoluteURL != currParentDir.absoluteURL {
                    throw MovieError.differentParentDir
                }
                return currParentDir
            }()
        }
        if #available(macOS 13.0, *) {
            return parentDir!.path(percentEncoded: false) + parentDir!.lastPathComponent + "." + fileExtension!
        } else {
            throw MovieError.lowMacOsVersion
        }
    }
     
}

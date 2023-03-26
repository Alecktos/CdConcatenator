import Foundation

enum CdIdenterfierError: Error {
    case invalidCdFile(fileName: String)
}

public struct CdIdentifier {
    
    private func isCdFile(forPath filePath: String) throws -> Bool {
        guard let theURL = createUrl(forPath: filePath) else {
           print("File not valid. Could not create URL: " + filePath)
            return false
        }
        
        let fileNameLessExt = theURL.deletingPathExtension().lastPathComponent
        let pathExtension = theURL.pathExtension
        
        let fileExtensions:[String] = ["avi", "mkv", "mpg", "mp4"]
        let correctFileExtension = fileExtensions.contains(where: pathExtension.lowercased().contains)
        if(!correctFileExtension) {
            return false
        }
        
        let lowerCasedfileNameLessExt = fileNameLessExt.lowercased()
        
        let notAllowedCdPrefixes = ["cd03", "cd3", "cd.3", "vcddvd3", "cd 3"]
        if(notAllowedCdPrefixes.contains(where: lowerCasedfileNameLessExt.contains)) {
            throw CdIdenterfierError.invalidCdFile(fileName: lowerCasedfileNameLessExt)
        }
        
        let allowedCd1Prefixs = ["cd01", "cd1", "cd.1", "vcddvd1", "cd 1"]
        if(allowedCd1Prefixs.contains(where: lowerCasedfileNameLessExt.contains)) {
            return true
        }
        
        let allowedCd2Prefixs = ["cd02", "cd2", "cd.2", "vcddvd2", "cd 2"]
        if(allowedCd2Prefixs.contains(where: lowerCasedfileNameLessExt.contains)) {
            return true
        }
        
        return false
    }
    
    private func traverse(WithFm fm: FileManager, atPath currPath: String) throws -> [String] {
        var paths: [String] = Array()
        let items = try fm.contentsOfDirectory(atPath: currPath)
        for item in items {
            var isDir: ObjCBool = false
            
            let itemPath: String = currPath + "/" + item
            
            
            fm.fileExists(atPath: itemPath, isDirectory: &isDir)
            if isDir.boolValue == true {
                let result = try traverse(WithFm: fm, atPath: itemPath)
                paths.append(contentsOf: result)
            } else {
                if (try isCdFile(forPath: itemPath)) {
                    paths.append(itemPath)
                }
            }
        }
        return paths
    }
    
    // This should return Movie info instead
    func getCdFilesPaths(forDir dirPath: String) -> [String] {
        let fm = FileManager.default
        let filePaths: [String]
        do {
            filePaths = try traverse(WithFm: fm, atPath: dirPath)
        } catch {
            print("Failed to traverse dir")
            filePaths = Array()
        }
        
        return filePaths
    }
    
    func getFoldersContainingCdFiles(withFm fm: FileManager, atPath currPath: String) throws -> [String] {
        var paths: [String] = Array()
        let items = try fm.contentsOfDirectory(atPath: currPath)
        for item in items {
            var isDir: ObjCBool = false
            
            let itemPath: String = currPath + "/" + item
            
            
            fm.fileExists(atPath: itemPath, isDirectory: &isDir)
            if isDir.boolValue == true {
                let result = try getFoldersContainingCdFiles(withFm: fm, atPath: itemPath)
                paths.append(contentsOf: result)
            } else {
                if (try isCdFile(forPath: itemPath)) {
                    let fileURL: URL = URL(fileURLWithPath: itemPath)
                    let folderURL = fileURL.deletingLastPathComponent()
                    paths.append(folderURL.relativePath)
                }
            }
        }
        return Array(Set(paths))
    }
    
}



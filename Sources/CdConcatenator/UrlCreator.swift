import Foundation

func createUrl(forPath filePath: String) -> URL? {
    if filePath.lastIndex(of: ".") == nil {
        print("Could not find last dot in filePath: " + filePath)
        return nil
    }

    guard let encodedFilePath = filePath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
        print("Could not encode url: \(filePath)")
        return nil
    }
    
    guard let theURL = URL(string: encodedFilePath) else {
        print("File not valid. Could not create URL: " + filePath)
        return nil
    }
    return theURL
}

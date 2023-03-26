import Foundation

let cdIdentifier = CdIdentifier()
let movie_dir = "" // Add paths to directory containing CD media files
let fm = FileManager.default
do {
    let paths = try cdIdentifier.getFoldersContainingCdFiles(withFm: fm, atPath: movie_dir)
    for path in paths {
        print("Looking for files in path: " + path)
        let paths = cdIdentifier.getCdFilesPaths(forDir: path)
        let instructionFilePath = createInstructionFileFromParts(withParts: escapeSpaces(forStrings: paths), forDir: path)
        
        let m = try Movie(cdFilePaths: paths, instructionFilePath: instructionFilePath)
        
        concat(movie: m)
        
        for file_path in m.cdFilePaths {
            deleteFile(file_path)
        }
        deleteFile(m.instructionFilePath)
    }
} catch CdIdenterfierError.invalidCdFile(let fileName) {
    print("Invalid CdFileName: " + fileName)
} catch {
    print("Uknown Error")
}

func deleteFile(_ fileToDelete: String) {
    print("Deleteing: \(fileToDelete)")
    do {
        try FileManager.default.removeItem(atPath: fileToDelete)
    } catch {
        print("Failed to delete file: \(fileToDelete)" )
    }
}


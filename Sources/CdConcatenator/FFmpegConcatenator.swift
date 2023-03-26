import Foundation

func concat(movie: Movie) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/local/bin/ffmpeg")
    task.arguments = ["-f", "concat", "-safe", "0", "-i", movie.instructionFilePath, "-c", "copy", "\(movie.destinationPath)"]

    let outputPipe = Pipe()
    let errorPipe = Pipe()
     task.standardOutput = outputPipe
     task.standardError = errorPipe
    do {
        try task.run()
    } catch let error {
        print(error.localizedDescription)
    }

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(decoding: outputData, as: UTF8.self)
    let error = String(decoding: errorData, as: UTF8.self)

    // print(output)
    print("Created file: \(movie.destinationPath)")
    // print(error)
}

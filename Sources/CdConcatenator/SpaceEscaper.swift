import Foundation

func escapeSpaces(forStrings strings: [String]) -> [String] {
    var newStrings: [String] = Array()
    for stringItem in strings {
        newStrings.append(stringItem.components(separatedBy: " ").joined(separator: "\\ "))
    }
    return newStrings
}

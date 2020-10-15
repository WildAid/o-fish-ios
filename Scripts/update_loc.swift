#!/usr/bin/xcrun --sdk macosx swift
import Foundation

// MARK: - Extensions
extension String {
    func appendLine(to fileURL: URL) throws {
        try (self + "\n").append(to: fileURL)
    }

    func append(to fileURL: URL, encoding: String.Encoding = .utf8) throws {
        let data = self.data(using: encoding)!
        try data.append(to: fileURL)
    }
}

extension Data {
    func append(to fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        } else {
            try write(to: fileURL, options: .atomic)
        }
    }
}

// MARK: - Global 
private var verbose = false
private var test = false

private struct LocConstants {
    static let stringsFileName = "Localizable.strings"
    static let locDirectorySuffix = ".lproj"
    static let backUpDirName = "Backup"
    static let generatedDirName = "Generated"
    static let editLine = "/*---- Below this line are localizations that need to be done. Please keep this line even if there are no lines below this one. -----*/"
}

// MARK: - Basic command parser
private enum ParseError: Error {
    case args([String])
    case requiredArg(String)
    case help([String])
}

private struct UpdateRequest {
    var sourcePath: String
    var locPath: String
    var backupPath: String?
}

// MARK: - Arg Parsing
private func parseArgs() -> Result<UpdateRequest, ParseError> {
    // Recognized args
    let loc_path = "--loc_path="
    let source_path = "--source_path="
    let backup_path = "--backup_path="
    let verbose_arg = "--verbose="
    let test_arg = "--test="
    let help_path = "--help"
    let validCommands = [
        "\(loc_path) Localization Directory {Required}",
        "\(source_path) Source Files Directory {Required}",
        "\(backup_path) Loc File BackUp Location {Optional - Defaults to Script/Backup}",
        "\(verbose_arg) Show Info Messages {Optional - true/false}",
        "\(test_arg) Show Missing Keys without Making Changes {Optional - true/false}"
    ]

    var badArgs: [String] = []
    var locPath = ""
    var sourcePath = ""
    var backupPath: String?

    for arg in CommandLine.arguments {
        // Skip input command
        if arg == CommandLine.arguments[0] { continue }
        
        // Start parsing args
        if arg.starts(with: source_path) {
            sourcePath = String(arg.dropFirst(source_path.count))
        } else if arg.starts(with: loc_path) {
            locPath = String(arg.dropFirst(loc_path.count))
        } else if arg.starts(with: backup_path) {
            backupPath = String(arg.dropFirst(backup_path.count))
        } else if arg.starts(with: verbose_arg) {
            verbose = (arg.dropFirst(verbose_arg.count).lowercased() == "true") ? true : false
        } else if arg.starts(with: test_arg) {
            test = (arg.dropFirst(test_arg.count).lowercased() == "true") ? true : false
        } else if arg.starts(with: help_path) {
            return .failure(.help(validCommands))
        } else {
            // Just pass back unrecognized args
            badArgs.append(arg)
        }
    }

    if badArgs.count > 0 {
        return .failure(.args(badArgs))
    } else if sourcePath.count == 0 {
        return .failure(.requiredArg(String(source_path.dropFirst(2).dropLast(1))))
    } else if locPath.count == 0 {
        return .failure(.requiredArg(String(loc_path.dropFirst(2).dropLast(1))))
    } else {
        let request = UpdateRequest(sourcePath: sourcePath, locPath: locPath, backupPath: backupPath)  
        return .success(request)      
    }
}

// MARK: - Generate Strings from Source
private func genStrings(sourcePath: String, backUpDirPath: String? = nil) -> Bool {
    let filePath = sourcePath.hasSuffix("/") ? sourcePath : "\(sourcePath)/"
    let outputPath = generatedDirectoryPath(for: backUpDirPath)

    // Drop and recreate Generated path
    let outputUrl = URL(fileURLWithPath: outputPath)
    if FileManager.default.fileExists(atPath: outputUrl.path) {
        do {
            try FileManager.default.removeItem(at: outputUrl)
        } catch {
            log("Error deleting generated missing key directory at: \(outputUrl.absoluteString). Error: \(error.localizedDescription)")

            return false
        }
    }

    // Re-create Generate folder
    do {
        try FileManager.default.createDirectory(atPath: outputUrl.path, withIntermediateDirectories: true, attributes: nil)
    } catch {
        log("Error creating Generated directory at: \(outputUrl.absoluteString). Error: \(error.localizedDescription)")
        return false
    }
    
    // Gen strings command
    let findCodeFilesTask = Process()
    let genStringsTask = Process()
    let toGenStringsPipe = Pipe()

    findCodeFilesTask.standardOutput = toGenStringsPipe
    findCodeFilesTask.executableURL = URL(fileURLWithPath: "/usr/bin/find") 
    findCodeFilesTask.arguments = [
        filePath,
        "-name",
        "*.swift",
        "-print0"
    ]

    genStringsTask.standardError = nil
    genStringsTask.standardInput = toGenStringsPipe
    genStringsTask.executableURL = URL(fileURLWithPath: "/usr/bin/xargs") 
    genStringsTask.arguments = [
        "-0",
        "genstrings",
        "-s", 
        "TextField", 
        "-s", 
        "SecureField", 
        "-a",
        "-SwiftUI",
        "-o", 
        "\(outputPath)"
    ]

    do {
        try findCodeFilesTask.run()
        try genStringsTask.run()
    } catch {

    }

    findCodeFilesTask.waitUntilExit()
    genStringsTask.waitUntilExit()

    return true
}

// MARK: - Directory Functions
private func directoryExistsAtPath(_ path: String) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
}

private func urls(for path: String, endingWith: String) -> [URL] {
    var result = [URL]()

    let startUrl = URL(fileURLWithPath: path)
    let dirExists = directoryExistsAtPath(path)
    if dirExists, let enumerator = FileManager.default.enumerator(at: startUrl, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
        
        for case let fileUrl as URL in enumerator {
            do {
                let attributes = try fileUrl.resourceValues(forKeys:[.isRegularFileKey])
                if attributes.isRegularFile! {
                    // Only capture code files
                    if fileUrl.absoluteString.hasSuffix(endingWith) {
                        result.append(fileUrl)
                    }
                }
            } catch {
                log("Unknown URL Error: \(error) in \(fileUrl)")
            }
        }
    } else {
        log("Invalid path: \(path)")
    }

    return result
}

private func locFileUrls(for path: String) -> [URL] {
    return urls(for: path, endingWith: LocConstants.stringsFileName)
}

private func codeFileUrls(for path: String) -> [URL] {
    return urls(for: path, endingWith: ".swift")
}

private func languageCode(for locDir: URL) -> String? {

    // Must end with strings file name
    guard locDir.absoluteString.hasSuffix(LocConstants.stringsFileName) else {
        return nil
    }

    let directoryPath = locDir.absoluteString.dropLast(LocConstants.stringsFileName.count + 1)

    // Must be an .lproj file
    guard directoryPath.hasSuffix(LocConstants.locDirectorySuffix) else {
        return nil
    }
    
    // Find range for code component
    let code = String(directoryPath.dropLast(LocConstants.locDirectorySuffix.count))
    guard let endSlashIndex = code.lastIndex(of: "/") else {
        return nil
    }

    let codeRange = (code.index(endSlashIndex, offsetBy:1)..<code.endIndex)

    return String(code[codeRange])
}

private func generatedDirectoryPath(for backUpDirPath: String? = nil) -> String {
    var outputPath = (backUpDirPath ?? FileManager.default.currentDirectoryPath)
    outputPath = outputPath.hasSuffix("/") ? outputPath : "\(outputPath)/\(LocConstants.generatedDirName)" 

    return outputPath
}

private func cleanUp(with backUpDirPath: String? = nil) {

    let genDir = generatedDirectoryPath(for: backUpDirPath)
    let genUrl = URL(fileURLWithPath: genDir)

    if FileManager.default.fileExists(atPath: genUrl.path) {
        try? FileManager.default.removeItem(at: genUrl)
    }
}

// MARK: - Strings File Handling - gets just the keys from the new strings file
private func generatedStringKeys(for backUpDirPath: String? = nil) -> [String]? {
    var result: [String]?

    let dirPath = generatedDirectoryPath(for: backUpDirPath)
    var fileUrl = URL(fileURLWithPath: dirPath)
    fileUrl = fileUrl.appendingPathComponent(LocConstants.stringsFileName)

    guard FileManager.default.fileExists(atPath: fileUrl.path) else {
        log("\(LocConstants.stringsFileName) file not found at: \(fileUrl.path)")
        return nil
    }

    guard let sourceString = read(from: fileUrl) else {
        return nil        
    }

    // We only need the keys because for generated loc file keys always == value
    result = tokenize(source: sourceString).map { $0.key }

    return result
}

private func read(from fileUrl: URL, encoding: String.Encoding = .utf16) -> String? {

    var result: String?

    do {
        result = try String(contentsOf: fileUrl, encoding: encoding)
    } catch {
        log("Unable to read \(fileUrl.path). Error: \(error.localizedDescription)")
    }

    return result
}

private func tokenize(source: String) -> [String:String] {

    var result = [String:String]()

    // Split by line then remove comments and trailing ";" 
    let rawStrings = source.components(separatedBy: .newlines)
            .map( { $0.trimmingCharacters(in: .whitespacesAndNewlines)} )
            .filter { !$0.hasPrefix("/*") && ($0.count > 0) }
            .map( { $0.hasSuffix(";") ? String($0.dropLast(1)) : String($0) })
 
    // Tokenize
    for rawString in rawStrings {
        let split = rawString.components(separatedBy: "=").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        result[split[0]] = split[1]
    }

    return result
}

// MARK: - Checks for edit line in file so we know if we need to append it
private func containsEditLine(source: String) -> Bool {

    let rawStrings = source.components(separatedBy: .newlines)
            .map( { $0.trimmingCharacters(in: .whitespacesAndNewlines)} )


    return (rawStrings.first(where: { $0 == LocConstants.editLine }) != nil)
}

// MARK: - Function to copy loc files and folders from user supplied path to either the Script folder or a user supplied path
private func backupLocFiles(from: String, to: String) -> Bool {
    log("Copying current loc files from \(from) to \(to)/\(LocConstants.backUpDirName)")

    guard directoryExistsAtPath(from) else {
        log("From directory not found: \(from)")
        return false
    }

    guard directoryExistsAtPath(to) else {
        log("To directory not found: \(to)")
        return false
    }

    // Copy over
    let fromUrl = URL(fileURLWithPath: from)

    // Base to URL (i.e. Scripts/Backup/)
    var toUrl = URL(fileURLWithPath: to)
        .appendingPathComponent(LocConstants.backUpDirName)

    do {

        // Back up folder - e.g. Scripts/Backup - doesn't exist
        if !FileManager.default.fileExists(atPath: toUrl.path) {
            try FileManager.default.createDirectory(atPath: toUrl.path, withIntermediateDirectories: true, attributes: nil)
        }

        // Append sub-folder in Backup
        toUrl = toUrl.appendingPathComponent(fromUrl.lastPathComponent)

        // Delete prior first loc folders
        if FileManager.default.fileExists(atPath: toUrl.path) {
            try FileManager.default.removeItem(at: toUrl)
        }

        try FileManager.default.copyItem(at: fromUrl, to: toUrl)
    } catch {
        log("Backup failed: \(error.localizedDescription); fromURL: \(fromUrl); toURL: \(toUrl)")
        return false
    }

    return true
}

// MARK: - Debug/Output
private func log(_ message: String) {
    if verbose {
        print(message)
    }
}

// MARK: - Main Loc Update functions
private func updateStrings(request: UpdateRequest) {

    // Verify important directories
    guard directoryExistsAtPath(request.sourcePath) else {
        log("Project directory not found: \(request.sourcePath)")     
        return   
    }

    guard directoryExistsAtPath(request.locPath) else {
        log("Localization directory not found: \(request.locPath)")        
        return   
    }

    let locDirPath = request.locPath
    let locUrls = locFileUrls(for: locDirPath)

    // Ensure valid files found in path
    guard locUrls.count > 0 else {
        log("No localization files found in: \(locDirPath)")        
        return
    }

    // Copy current loc files
    let toPath = request.backupPath ?? FileManager.default.currentDirectoryPath
    guard backupLocFiles(from: locDirPath, to: toPath) else {
        log("Unable to backup loc files from \(locDirPath) to \(toPath)")
        return        
    }

    // Generate delta strings file to working directory
    guard genStrings(sourcePath: request.sourcePath, backUpDirPath: request.backupPath) else {
        log("Unable to generate string delta file")
        return        
    }

    // Get new string keys
    guard let stringKeys = generatedStringKeys(for: request.backupPath) else {
        log("Generated Localized.strings not found")
        return
    }

    // Analyze loc files for missing keys and update
    for locFileUrl in locUrls {
        addMissing(keys: stringKeys, to: locFileUrl)
    }

    // Clean Up Working Directories
    cleanUp(with: request.backupPath)
}

private func addMissing(keys: [String], to locFileUrl: URL) {

    if let fileContents = read(from: locFileUrl, encoding: .utf8) {
        let needsEditLine = !containsEditLine(source: fileContents)
        let existingKeys = tokenize(source: fileContents).map { $0.key }
        var newKeyset = Set<String>(keys)
        
        for key in existingKeys {
            newKeyset.remove(key)
        }

        let sortedKeys = Array(newKeyset).sorted()

        if !test {
            log("Adding missing keys to: \(locFileUrl)")
        }

        // Loop and either display missing keys or append to loc file
        if test && sortedKeys.count > 0 {
            print("\(locFileUrl) is missing:")
            print("\(sortedKeys)")
        } else {

            do {
                // Add edit line if missing
                if needsEditLine {
                    try LocConstants.editLine.appendLine(to: locFileUrl)
                }

                for key in sortedKeys {
                    // Modify
                    let newEntry = "\(key) = \(key);"
                    try newEntry.appendLine(to: locFileUrl)
                }
            } catch {
                log("Unable to update \(locFileUrl). Error: \(error.localizedDescription)")
            }
        }
    }
}

// Main Entry
private let result = parseArgs()

// Route Command Request
switch result {
    case .success(let request): 
        updateStrings(request: request)
    case .failure(let parseError): 

        switch parseError {
            case .args(let badArgs):
                print("Unrecognized argument(s):")        
                for arg in badArgs {
                    print(arg) 
                }
            case .requiredArg(let arg):
                print("\(arg) : is required")    
            case .help(let validCommands):
                print("Valid Commands:")    
                for command in validCommands {
                    print(command)
                }
        }
}

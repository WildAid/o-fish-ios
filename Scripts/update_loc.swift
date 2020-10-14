#!/usr/bin/xcrun --sdk macosx swift
import Foundation

private struct LocConstants {
    static let stringsFileName = "Localizable.strings"
    static let locDirectorySuffix = ".lproj"
    static let backUpDirName = "Backup"
}

// MARK: - Basic command parser
private enum ParseError: Error {
    case args([String])
    case requiredArg(String)
}

private struct UpdateRequest {
    var sourcePath: String
    var locPath: String
    var verbose = true
    var backUpDirPath: String?
}

// MARK: - Shell Command Handler
@discardableResult private func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()

    return task.terminationStatus
}

// MARK: - Arg Parsing
private func parseArgs() -> Result<UpdateRequest, ParseError> {
    // Recognized args
    let loc_path = "--loc_path="
    let source_path = "--source_path="
    var badArgs: [String] = []
    var locPath = ""
    var sourcePath = ""

    for arg in CommandLine.arguments {
        // Skip input command
        if arg == CommandLine.arguments[0] { continue }
        
        // Start parsing args
        if arg.starts(with: source_path) {
            sourcePath = String(arg.dropFirst(source_path.count))
        } else if arg.starts(with: loc_path) {
            locPath = String(arg.dropFirst(loc_path.count))
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
        let request = UpdateRequest(sourcePath: sourcePath, locPath: locPath)  
        return .success(request)      
    }
}

// MARK: - Directory Functions
private func directoryExistsAtPath(_ path: String) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
}

private func urls(for path: String, endingWith: String, verbose: Bool = false) -> [URL] {
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
                if verbose { print(error, fileUrl) }
            }
        }
    } else {
        if verbose { print("Invalid path: \(path)") }
    }

    return result
}

private func locFiles(for path: String, verbose: Bool = false) -> [URL] {
    return urls(for: path, endingWith: LocConstants.stringsFileName, verbose: verbose)
}

private func codeFiles(for path: String, verbose: Bool = false) -> [URL] {
    return urls(for: path, endingWith: ".swift", verbose: verbose)
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

// MARK: - Main Loc Update functions
private func updateLocalizations(request: UpdateRequest) {

    // Verify important directories
    guard directoryExistsAtPath(request.sourcePath) else {
        print("Project directory not found: \(request.sourcePath)")     
        return   
    }

    guard directoryExistsAtPath(request.locPath) else {
        print("Localization directory not found: \(request.locPath)")        
        return   
    }

    let locDirPath = request.locPath
    let files = locFiles(for: locDirPath, verbose: request.verbose)

    // Ensure valid files found in path
    guard files.count > 0 else {
        print("No localization files found in: \(locDirPath)")        
        return
    }

    if request.verbose {
        print("Found: \(files.count) localized files.")
        for file in files {
            //let code = languageCode(for: file) ?? "UNK"
            print(file.absoluteString)
        }
    }

    // Copy current loc files
    let toPath = request.backUpDirPath ?? FileManager.default.currentDirectoryPath
    guard backupLocFiles(from: locDirPath, to: toPath, verbose: request.verbose) else {
        if request.verbose {
            print("Unable to backup loc files from \(locDirPath) to \(toPath)")
        }

        return        
    }

    // Generate string updates
    //shell("ls")

    if request.verbose {
        print("Generating strings update...")
    }

    // Code file
    let swiftFiles = codeFiles(for: request.sourcePath, verbose: request.verbose)
    print(swiftFiles)

    // Update loc files
    if request.verbose {
        print("Updating loc files...")
    }
}

private func backupLocFiles(from: String, to: String, verbose: Bool = false) -> Bool {
    if verbose {
        print("Copying current loc files from \(from) to \(to)/\(LocConstants.backUpDirName)")
    }

    guard directoryExistsAtPath(from) else {
        if verbose { print("From directory not found: \(from)") }
        return false
    }

    guard directoryExistsAtPath(to) else {
        if verbose { print("To directory not found: \(to)") }
        return false
    }

    // Copy over
    let fromUrl = URL(fileURLWithPath: from)
    let toUrl = URL(fileURLWithPath: to)
        .appendingPathComponent(LocConstants.backUpDirName)
        .appendingPathComponent(fromUrl.lastPathComponent)

    do {
        // Delete prior first
        if FileManager.default.fileExists(atPath: toUrl.path) {
            try FileManager.default.removeItem(at: toUrl)
        }

        try FileManager.default.copyItem(atPath: fromUrl.path, toPath: toUrl.path)
    } catch {
        if verbose {
            print("Backup failed: \(error.localizedDescription)")
        }

        return false
    }

    return true
}

// Main Entry
private let result = parseArgs()

// Route Command Request
switch result {
    case .success(let request): 
        updateLocalizations(request: request)
    case .failure(let parseError): 

        switch parseError {
            case .args(let badArgs):
                print("Unrecognized argument(s):")        
                for arg in badArgs {
                    print(arg) 
                }
            case .requiredArg(let arg):
                print("\(arg) : is required")        
        }
}

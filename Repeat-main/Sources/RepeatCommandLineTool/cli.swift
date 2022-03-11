import ArgumentParser
import Foundation

protocol AsyncParsableCommand: ParsableCommand {
    mutating func runAsync() async throws
}

extension ParsableCommand {
    static func main() async {
        do {
            var command = try parseAsRoot(nil) /// `parseAsRoot` uses the program's command-line arguments when passing `nil`
            if var asyncCommand = command as? AsyncParsableCommand {
                try await asyncCommand.runAsync()
            } else {
                try command.run()
            }
        } catch {
            exit(withError: error)
        }
    }
}

@main
enum CLI {
    static func main() async {
        await Repeat.main()
    }
}


struct Repeat: ParsableCommand, AsyncParsableCommand {
    @Flag(help: "Include a counter with each repetition.")
    var includeCounter = false

    @Option(name: .shortAndLong, help: "The number of times to repeat 'phrase'.")
    var count: Int?

    @Argument(help: "The phrase to repeat.")
    var phrase: String

    mutating func runAsync() async throws {
       let this = try safeShell()
        print(this)
        let repeatCount = count ?? .max
        await asyncRepeat(phrase: phrase, repeatCount: repeatCount)
    }

    func asyncRepeat(phrase: String, repeatCount: Int) async {
        try? await Task.sleep(nanoseconds: 5 * 1_000_000_000) // dummy use of an aysnc operation .. wait 5 seconds :)
        for i in 1...repeatCount {
            if includeCounter {
                print("\(i): \(phrase)")
            } else {
                print(phrase)
            }
        }
    }
    
    func safeShell() throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-t", "10", "/Users/civilgisticslabs/Downloads/file_example_MP4_1280_10MG.mp4", "-f", "/Users/civilgisticslabs/Downloads/Repeat-main/Sources/TestForVideoPath"]
        task.executableURL = URL(fileURLWithPath: "/Users/civilgisticslabs/Downloads/Repeat-main/mediafilesegmenter") //<--updated

        try task.run() //<--updated
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        dump(output)
        return output
    }
}


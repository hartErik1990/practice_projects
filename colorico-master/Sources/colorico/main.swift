//import ArgumentParser
//import Foundation //For FileManager
//
//struct Colorico: ParsableCommand {
//
//    static var configuration = CommandConfiguration(
//        abstract: "Colorico adds colour to text using Console Escape Sequences",
//        version: "1.0.0"
//    )
//
//    enum Colour: Int {
//        case red    = 31
//        case green  = 32
//    }
//
//    @Argument(help: "text to colour.")
//    var text: String
//
//    @Flag(inversion: .prefixedNo)
//    var good = true
//
//    @Option(name: [.customShort("o"), .long], help: "name of output file(the command only writes to current directory)")
//    var outputFile: String?
//
//
//    func run() throws {
//        let proccess = Process()
//        let appUrl = Bundle.main.bundleURL.appendingPathComponent("/Users/civilgisticslabs/Downloads/colorico-master/Sources/colorico/mediastreamsegmenter")
//
//        //Workspace.shared().open(appUrl)
//
//        //proccess.executableURL = Bundle.main.
//        var colour = Colour.green.rawValue
//        if !good {
//            colour = Colour.red.rawValue
//        }
//        let colouredText = "\u{1B}[\(colour)m\(text)\u{1B}[0m"
//        if let outputFile = outputFile {
//            let path = FileManager.default.currentDirectoryPath
//
//            //Lets prevent any directory traversal
//            let filename = URL(fileURLWithPath: outputFile).lastPathComponent
//            let fullFilename = URL(fileURLWithPath: path).appendingPathComponent(filename)
//            try colouredText.write(to: fullFilename, atomically: true, encoding: String.Encoding.utf8)
//        } else {
//            print(colouredText)
//        }
//
//    }
//}
//
//func readSTDIN () -> String? {
//    var input:String?
//
//    while let line = readLine() {
//        if input == nil {
//            input = line
//        } else {
//            input! += "\n" + line
//        }
//    }
//
//    return input
//}
//
//var text: String?
//
//if CommandLine.arguments.count == 1 || CommandLine.arguments.last == "-" {
//    if CommandLine.arguments.last == "-" { CommandLine.arguments.removeLast() }
//    text = readSTDIN()
//}
//
//var arguments = Array(CommandLine.arguments.dropFirst())
//if let text = text {
//    arguments.insert(text, at: 0)
//}
//
//let command = Colorico.parseOrExit(arguments)
//do {
//    try command.run()
//} catch {
//
//    Colorico.exit(withError: error)
//}

/// main.swift
import ConsoleKit
import Foundation

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)
var context = CommandContext(console: console, input: input)

var commands = Commands(enableAutocomplete: true)
commands.use(DemoCommand(), as: "demo", isDefault: false)

do {
    let group = commands
        .group(help: "An example command-line application built with ConsoleKit")
    try console.run(group, input: input)
} catch let error {
    console.error("\(error)")
    exit(1)
}

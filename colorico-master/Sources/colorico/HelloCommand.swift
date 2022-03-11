//
//  File.swift
//  
//
//  Created by Civilgistics_Labs on 3/6/22.
//
/// HelloCommand.swift
import Foundation
import ConsoleKit

struct HelloCommand: Command {
        
    struct Signature: CommandSignature {

        @Argument(name: "name", help: "The name to say hello")
        var name: String

        @Option(name: "greeting", short: "g", help: "Greeting used")
        var greeting: String?

        @Flag(name: "capitalize", short: "c", help: "Capitalizes the name")
        var capitalize: Bool
    }

    static var name = "hello"
    let help = "This command will say hello to a given name."

    func run(using context: CommandContext, signature: Signature) throws {
        let greeting = signature.greeting ?? "Hello"
        var name = signature.name
        if signature.capitalize {
            name = name.capitalized
        }
        print("\(greeting) \(name)!")
        
        /// progress bar
        let bar = context.console.progressBar(title: "Hello")
        bar.start()
        /// perform some work...
        // bar.fail()
        bar.succeed()
        
        /// input
        let foo = context.console.ask("What?")
        print(foo)
        
        /// secure input
        let baz = context.console.ask("Secure what?", isSecure: true)
        print(baz)
        
        /// choice
        let c = context.console.choose("Make a choice", from: ["foo", "bar", "baz"])
        print(c)

        /// @Tip: look for more options under the context.console property.
    }
}


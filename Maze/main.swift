//
//  main.swift
//  Maze
//
//  Created by Kaushal Deo on 10/20/17.
//  Copyright © 2017 Scorpion. All rights reserved.
//

import Foundation

enum OutputType {
    case error
    case standard
}

func writeMessage(_ message: String, to: OutputType = .standard) {
    switch to {
    case .standard:
        print(message)
    case .error:
        fputs("Error: \(message)\n", stderr)
    }
}


//Get the argument list from the command lines
let argCount = Int(CommandLine.argc)

//We need to have atleast two arguments in the call
if argCount < 3 {
    var message = "Output files location is missing"
    if argCount == 1 {
        message = "Input and output files location is missing"
    }
    writeMessage(message, to: .error)
    exit(0)
}

let directoryPath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let inputPath = URL(fileURLWithPath: CommandLine.arguments[1], relativeTo: directoryPath)
print("script at: " + inputPath.path)
let outputPath = URL(fileURLWithPath: CommandLine.arguments[2], relativeTo: directoryPath)
print("script at: " + outputPath.path)

let inputStrings = try! String(contentsOf: inputPath)
let inputsItems = inputStrings.components(separatedBy: "\n")
var item : Maze? = nil
do {
    item = try Maze(parameters: inputsItems)
}
catch let error {
    writeMessage(error.localizedDescription, to: .error)
    exit(0)
}
guard let maze = item else {
    writeMessage("Unable to create maze, unknown error", to: .error)
    exit(0)
}
print(maze.description())
let result = maze.findSolution()
var string = String(result.result)
if let position = result.position {
    string += "\n\(position.x) \(position.y)"
}
//writing
do {
    try string.write(to: outputPath, atomically: false, encoding: .utf8)
}
catch let error {
    /* error handling here */
    writeMessage(error.localizedDescription, to: .error)
    exit(0)
}






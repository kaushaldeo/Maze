//
//  Maze.swift
//  Maze
//
//  Created by Kaushal Deo on 10/20/17.
//  Copyright © 2017 Scorpion. All rights reserved.
//

import Foundation

struct Position : Hashable {
    let x : Int
    let y : Int
    let direction : String
    
    public var hashValue: Int {
        return self.x.hashValue + self.y.hashValue + self.direction.hashValue
    }
    
    public static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.direction == rhs.direction
    }
}

class Maze {
    fileprivate let matrix : [[String]]
    
    let boundary : (x:Int, y:Int)
    
    let initial : Position
    
    fileprivate var visited = [Position:Bool]()
    
    init(parameters:[String]) throws {
        if parameters.count < 2 {
            throw NSError(domain: "com.maze.parameters", code: 100, userInfo: nil)
        }
        let limits : [Int] = parameters[0].components(separatedBy: " ").map({  Int($0) ?? 0})
        if limits.count < 2 {
            throw NSError(domain: "com.maze.parameters", code: 101, userInfo: nil)
        }
        self.boundary = (x:limits[0], y:limits[1])
        
        let position : [String] = parameters[1].components(separatedBy: " ")
        if position.count < 3 {
            throw NSError(domain: "com.maze.parameters", code: 102, userInfo: nil)
        }
        
        self.initial = Position(x:Int(position[0]) ?? 0, y:Int(position[1]) ?? 0, direction:position[2])
        
        var array = [[String]]()
        for _ in 0 ..< limits[0] {
            var items = [String]()
            for _ in 0 ..< limits[1] {
                items.append("X")
            }
            array.append(items)
        }
        
        for index in 2 ..< parameters.count {
            let huddles : [String] = parameters[index].components(separatedBy: " ")
            if huddles.count < 3 {
                throw NSError(domain: "com.maze.parameters", code: 103, userInfo: nil)
            }
            let direction = (x:Int(huddles[0]) ?? 0, y:Int(huddles[1]) ?? 0, direction:huddles[2])
            array[direction.x][direction.y] = direction.direction
        }
        self.matrix = array
    }
    
    
    func description()  {
        print("\n")
        for item in self.matrix {
            print(item)
            print("\n")
        }
        print("\n")
        
    }
    
    func findSolution() -> (result: Int, position:(x:Int,y:Int)?) {
        var result = self.solve(position: self.initial)
        //Check the boundary value if present then return with steps
        if let _ = result.position {
            return result
        }
        //Otherwise return with negative value with no position.
        result.result = -1
        return result
    }
    
    fileprivate func solve(position: Position) -> (result: Int, position:(x:Int,y:Int)?) {
        
        //for circle and return the value
        if self.visited[position] == true {
            return (-1, nil)
        }
        
        self.visited[position] = true
        
        //Check for boundary value
        if (position.x == -1 || position.x == self.boundary.x) || (position.y == -1 || position.y == self.boundary.y) {
            return (-1, (x:max(0, position.x), y:max(position.y, 0)))
        }
        
        //Check the direction and prepare for next direction
        var direction = position.direction
        
        //Check the visiting block has some huddle, if so then change direction.
        if self.matrix[position.x][position.y] != "X" {
            switch position.direction {
            case "S":
                direction = self.matrix[position.x][position.y] == "/" ? "W" : "E"
            case "N":
                direction = self.matrix[position.x][position.y] == "/" ? "E" : "W"
            case "E":
                direction = self.matrix[position.x][position.y] == "/" ? "N" : "S"
            case "W":
                direction = self.matrix[position.x][position.y] == "/" ? "S" : "N"
            default:
                direction = position.direction
            }
        }
        
        //Move to next step
        switch direction {
        case "W":
            let result = solve(position: Position(x: position.x, y: position.y - 1, direction: "W"))
            return (result.result + 1, result.position)
        case "E":
            let result = solve(position: Position(x: position.x, y: position.y + 1, direction: "E"))
            return (result.result + 1, result.position)
        case "S":
            let result = solve(position: Position(x: position.x + 1, y: position.y, direction: "S"))
            return (result.result + 1, result.position)
        default:
            let result = solve(position: Position(x: position.x - 1, y: position.y, direction: "N"))
            return (result.result + 1, result.position)
        }
    }
}

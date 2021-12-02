import Foundation

enum Direction {
    case forward(amount: Int)
    case up(amount: Int)
    case down(amount: Int)
}

func parse(_ line: String) -> Direction {
    let parts = line.split(separator: " ")
    let amount = Int(parts[1])!
    let direction = parts[0]
    
    switch direction {
    case "forward":
        return .forward(amount: amount)
    case "up":
        return .up(amount: amount)
    case "down":
        return .down(amount: amount)
    default:
        fatalError("Unrecognized direction '\(direction)'")
    }
}

func part1(_ lines: [String]) -> Int {
    let (x, y) = lines.map { parse($0) }
        .reduce((0, 0)) { accumulator, element in
            let (x, y) = accumulator
            
            switch element {
            case .forward(let amount):
                return (x + amount, y)
            case .down(let amount):
                return (x, y + amount)
            case .up(let amount):
                return (x, y - amount)
            }
        }
    
    return x * y
}

func part2(_ lines: [String]) -> Int {
    let (x, y, _) = lines.map { parse($0) }
        .reduce((0, 0, 0)) { accumulator, element in
            let (x, y, aim) = accumulator
            
            switch element {
            case .forward(let amount):
                return (x + amount, y + amount * aim, aim)
            case .down(let amount):
                return (x, y, aim + amount)
            case .up(let amount):
                return (x, y, aim - amount)
            }
        }
    
    return x * y
}

let contents = FileLoader.load(file: "Input", extension: "txt")
let lines = contents.components(separatedBy: .newlines).filter { !$0.isEmpty }

print(part1(lines))
print(part2(lines))

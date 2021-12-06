import Foundation

struct Vent {
    let start: Coordinate
    let end: Coordinate
    
    var coordinates: [Coordinate] {
        return start.coordinates(between: end)
    }
}

struct Coordinate: Equatable, Hashable, CustomStringConvertible {
    let x: Int
    let y: Int
    
    var description: String {
        return "(\(x), \(y))"
    }
    
    func coordinates(between coordinate: Coordinate) -> [Coordinate] {
        if x == coordinate.x {
            // Vertical lines
            return (min(y, coordinate.y) ... max(y, coordinate.y)).map { Coordinate(x: x, y: $0) }
        } else if y == coordinate.y {
            // Horizontal lines
            return (min(x, coordinate.x) ... max(x, coordinate.x)).map { Coordinate(x: $0, y: y) }
        } else if isDiagonal(with: coordinate) {
            // Diagonal lines
            let direction: Int
            let (start, end) = ordered(coordinate)
            if (start.y > end.y) {
                direction = -1
            } else {
                direction = 1
            }
            
            let coords = stride(from: 0, through: abs(x - coordinate.x), by: 1)
                .map { Coordinate(x: start.x + $0, y: start.y + $0 * direction) }
            return coords
        } else {
            return []
        }
    }
    
    func isDiagonal(with coordinate: Coordinate) -> Bool {
        return abs(x - coordinate.x) == abs(y - coordinate.y)
    }
    
    private func ordered(_ coordinate: Coordinate) -> (Coordinate, Coordinate) {
        return x < coordinate.x ? (self, coordinate) : (coordinate, self)
    }
}

func part1(_ vents: [Vent]) -> Int {
    let coordinates = vents.flatMap { $0.coordinates }
    let occurrences = NSCountedSet(array: coordinates)
    
    var count = 0
    for value in occurrences {
        if occurrences.count(for: value) >= 2 {
            count += 1
        }
    }
    
    return count
}

func part2(_ vents: [Vent]) -> Int {
    let coordinates = vents.flatMap { $0.coordinates }
    let occurrences = NSCountedSet(array: coordinates)
    
    var count = 0
    for value in occurrences {
        if occurrences.count(for: value) >= 2 {
            count += 1
        }
    }
    
    return count
}

let contents = FileLoader.load(file: "Example", extension: "txt")
let points = contents.components(separatedBy: .newlines)
    .filter { !$0.isEmpty }
    .map { str -> Vent in
        let coordinates = str.components(separatedBy: " -> ").flatMap { $0.components(separatedBy: ",").compactMap { Int($0) }
        }
        
        return Vent(
            start: Coordinate(x: coordinates[0], y: coordinates[1]),
            end: Coordinate(x: coordinates[2], y: coordinates[3])
        )
    }

print(part1(points))
print(part2(points))

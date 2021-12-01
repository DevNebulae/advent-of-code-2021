import Foundation

func part1(_ numbers: [Int]) -> Int {
    return zip(numbers, numbers.suffix(from: 1))
        .map { $0.1 > $0.0 }
        .filter { $0 }
        .count
}

func part2(_ numbers: [Int]) -> Int {
    return part1(numbers.windowed(3).map { $0.reduce(0, +) })
}

let contents = FileLoader.load(file: "Input", extension: "txt")
let numbers = contents.components(separatedBy: .newlines).compactMap { Int($0) }

print(part1(numbers))
print(part2(numbers))

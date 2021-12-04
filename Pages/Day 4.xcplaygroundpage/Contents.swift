import Foundation

//typealias Board = [[Int]]

struct Board {
    let columns: [[Int]]
    let rows: [[Int]]
    
    init(rows: [[Int]]) {
        self.rows = rows
        columns = (0 ..< rows.endIndex).map { index in
            rows.map { $0[index] }
        }
    }
    
    func isBingo(_ numbers: Set<Int>) -> Bool {
        return isHorizontalBingo(numbers) || isVerticalBingo(numbers)
    }
    
    func nonDrawnNumbers(_ numbers: Set<Int>) -> Set<Int> {
        let board = Set(rows.flatMap { $0.compactMap { $0 } })
        return board.subtracting(numbers)
    }
    
    private func isHorizontalBingo(_ numbers: Set<Int>) -> Bool {
        return rows.anySatisfy { row in
            row.allSatisfy { numbers.contains($0) }
        }
    }
    
    private func isVerticalBingo(_ numbers: Set<Int>) -> Bool {
        return columns.anySatisfy { column in
            column.allSatisfy { numbers.contains($0) }
        }
    }
}

func parseBoards(_ lines: Array<Substring>, size: Int) -> [Board] {
    var boards = [Board]()
    for index in stride(from: 1, to: lines.endIndex, by: size) {
        let a = lines[index ..< index + size]
        let b = a.map { $0.split(separator: " ").compactMap{ Int($0) } }
        boards.append(Board(rows: b))
    }
    
    return boards
}

func part1(_ boards: [Board], numbers: [Int]) -> Int {
    for offset in stride(from: 5, through: numbers.endIndex, by: 1) {
        let drawnNumbers = numbers[0 ..< offset]
        let numbers = Set(drawnNumbers)
        
        if let board = boards.first(where: { $0.isBingo(numbers) }), let lastDrawnNumber = drawnNumbers.last {
            let sum = board.nonDrawnNumbers(numbers).reduce(0, +)
            
            return sum * lastDrawnNumber
        }
    }
    
    return -1
}

func part2(_ boards: [Board], numbers: [Int], index: Int) -> Int {
    let numberSubset = numbers[0 ..< index]
    let drawnNumbers = Set(numberSubset)
    
    if boards.count == 1, let board = boards.first, board.isBingo(drawnNumbers), let lastDrawnNumber = numberSubset.last  {
        let sum = board.nonDrawnNumbers(drawnNumbers).reduce(0, +)
        return sum * lastDrawnNumber
    }
    
    return part2(boards.filter { !$0.isBingo(drawnNumbers) }, numbers: numbers, index: index + 1)
}

let contents = FileLoader.load(file: "Input", extension: "txt")
let lines = contents.split(whereSeparator: \.isNewline)
let drawnNumbers = lines[0].split(separator: ",").compactMap { Int($0) }
let boards = parseBoards(lines, size: 5)

print(part1(boards, numbers: drawnNumbers))
print(part2(boards, numbers: drawnNumbers, index: 5))

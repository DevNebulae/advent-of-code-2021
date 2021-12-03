import Foundation

extension Bool {
    var numberValue: Int {
        return self ? 1 : 0
    }
}

typealias Bit = Bool
//struct Bit : ExpressibleByIntegerLiteral {
//    typealias IntegerLiteralType = Int
//
//    init(integerLiteral value: Int) {
//        assert(value == 0 || value == 1) {
//            fatalError("Value '\(value)' is neither 0 or 1")
//        }
//    }
//}

struct Reading {
    let bits: [Bit]
    var bitCount: Int {
        return bits.count
    }
    
    subscript(column: Int) -> Bit {
        return bits[column]
    }
    
    func intValue(_ fn: (Bit) -> (Bit) = { $0 }) -> Int {
        let bitString = bits.reduce("") { acc, element in acc + "\(fn(element).numberValue)" }
        return Int(bitString, radix: 2)!
    }
}

struct ReadingAnalyzer {
    let readings: [Reading]
    
    func dominantBit(in column: Int) -> Bit {
        return isDominant(occurrences: occurrences(of: true, in: column))
    }
    
    func submissiveBit(in column: Int) -> Bit {
        return !dominantBit(in: column)
    }
    
    func dominantReading(occurrences: [Int]) -> Reading {
        let dominantBits = occurrences.map { isDominant(occurrences: $0) }
        return Reading(bits: dominantBits)
    }
    
    func co2ScrubberReading(column: Int = 0) -> Int {
        if readings.count == 1, let reading = readings.first {
            return reading.intValue()
        }
        
        let submissiveBit = submissiveBit(in: column)
        let readings = filter(bit: submissiveBit, in: column)
        let analyzer = ReadingAnalyzer(readings: readings)
        
        return analyzer.co2ScrubberReading(column: column + 1)
    }
    
    func oxygenReading(column: Int = 0) -> Int {
        if readings.count == 1, let reading = readings.first {
            return reading.intValue()
        }
        
        let dominantBit = dominantBit(in: column)
        let readings = filter(bit: dominantBit, in: column)
        let analyzer = ReadingAnalyzer(readings: readings)
        
        return analyzer.oxygenReading(column: column + 1)
    }
    
    func isDominant(occurrences: Int) -> Bit {
        return occurrences >= Int(ceil(Double(readings.count) / 2))
    }
    
    func occurrences(of bit: Bit, in column: Int) -> Int {
        return readings.reduce(0) { $0 + $1[column].numberValue }
    }
    
    private func filter(bit: Bit, in column: Int) -> [Reading] {
        return readings.filter { $0[column] == bit }
    }
}

func part1(_ analyzer: ReadingAnalyzer, _ bitCount: Int) -> Int {
    let occurrences = (0 ..< bitCount).map { analyzer.occurrences(of: true, in: $0) }
    let reading = analyzer.dominantReading(occurrences: occurrences)

    return reading.intValue() * reading.intValue((!))
}

func part2(_ analyzer: ReadingAnalyzer) -> Int {
    let oxygenReading = analyzer.oxygenReading()
    let co2Reading = analyzer.co2ScrubberReading()
    
    return oxygenReading * co2Reading
}

let contents = FileLoader.load(file: "Input", extension: "txt")
let lines = contents.components(separatedBy: .newlines).filter { !$0.isEmpty }
let readings = lines.map { Reading(bits: $0.map { $0 == "1" }) }
let bitCount = readings[0].bitCount
let analyzer = ReadingAnalyzer(readings: readings)

print(part1(analyzer, bitCount))
print(part2(analyzer))

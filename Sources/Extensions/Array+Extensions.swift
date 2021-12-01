import Foundation

public extension Array {
    func windowed(_ amount: Int) -> [ArraySlice<Element>] {
        guard count >= 2, amount >= 1 else { return [] }
        
        return stride(from: startIndex, through: endIndex - amount, by: 1)
            .map { self[$0 ..< $0 + amount] }
    }
}

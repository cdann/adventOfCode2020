//
//  Day3.swift
//  adventOfCode
//
//  Created by Céline on 04/12/2020.
//

import Foundation

enum Day3 {
    case step1
    case step2
    
    func run() {
        switch self {
        case .step1:
            exercice1()
        case .step2:
            exercice2()
        }
    }
    
    private func exercice1() {
        let xMoves = 3

        var currentX = 0
        let result = Input.myMap.reduce(0) { (acc, row) -> Int in
            let x = currentX % row.count
            currentX += xMoves
            
            return row[x] == "#" ? acc + 1 : acc
        }
        print(result)
    }
    
    
    class Slope {
        internal init(move: (Int, Int), currentX: Int = 0) {
            self.move = move
            self.currentX = currentX
        }
        
        let move: (Int, Int)
        var currentX: Int = 0
        
        func check(row: [String], y: Int) -> Bool {
            guard y % move.1 == 0 else { return false }
            let x = currentX % row.count
            currentX += move.0
            return row[x] == "#"
        }
        
    }
    
    private func exercice2() {
        let slopes = Input.slopesMoves.map { Slope(move: $0) }
        var currentY = 0
        let slopesTrees = Input.myMap.reduce([]) { (acc, row) -> [Int] in
            let treesInRow = slopes.map { $0.check(row: row, y: currentY) ? 1 : 0 }
            currentY += 1
            if acc.isEmpty {
                return treesInRow
            }
            var resultArray = acc
            for i in 0..<treesInRow.count {
                resultArray[i] = resultArray[i] + treesInRow[i]
            }
            return resultArray
        }
        let result = slopesTrees.reduce(1) { $0 * $1 }
        print(result)
    }
    
    
}

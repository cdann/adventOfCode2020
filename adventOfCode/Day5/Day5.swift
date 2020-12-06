//
//  Day5.swift
//  adventOfCode
//
//  Created by Céline on 05/12/2020.
//

import Foundation

enum Day5 {
    case step1
    case step2

    struct Seat {
        let row: Int
        let column: Int
        var id: Int {
            row * 8 + column
        }
        
        init(from entry: String) {
            self.row = Seat.browse(str: entry.prefix(7), fullRange: 0...127, upperChar: "B")
            self.column = Seat.browse(str: entry.suffix(3), fullRange: 0...7, upperChar: "R")
        }
        
        static func browse(str: Substring, fullRange: ClosedRange<Int>, upperChar: Character) -> Int {
            return str.reduce(fullRange) { (range, character) in
                let max = range.max()!
                let min = range.min()!
                let diff: Int = (max - min) / 2
                if (character == upperChar) {
                    return (max - diff)...max
                }
                return min...(min+diff)
            }.min()!
        }
    }
    
    
    func run() {
        let boardingPassesEntries = Input.boardingPassesEntry.components(separatedBy: .whitespacesAndNewlines).filter({ !$0.isEmpty })
        switch self {
        case .step1:
            exercise1(entries: boardingPassesEntries)
        case .step2:
            exercise2(entries: boardingPassesEntries)
        }
    }
    
    func exercise1(entries: [String]) {
        print(highestBoardingPass(entries: entries))
    }
    
    func exercise2(entries: [String]) {
        let entries = entries.sorted(by: sortEntries(_:_:))
        var seatId: Int = 0
        var lastId: Int = 0
        for i in 0..<(entries.count / 2) {
            let index = i * 2
            let id1 = Seat(from: entries[index]).id
            let id2 = Seat(from: entries[index + 1]).id
            if (lastId - id1) == 2 {
                seatId = id1 + 1
                break
            }
            if (id1 - id2) == 2 {
                seatId = id1 - 1
                break
            }
            lastId = id2
        }
        print(seatId)
    }
    
    func highestBoardingPass(entries: [String]) -> Int {
        if let higher = entries.sorted(by: sortEntries(_:_:)).first {
            return Seat(from: higher).id
        } else {
            fatalError("Should never happen \(entries)")
        }
    }
    
    func sortEntries(_ entry1: String,_ entry2: String) -> Bool {
        for i in 0..<entry1.count {
            let upperLetter: [Character] = ["B", "R"]
            if entry2[i] == entry1[i] { continue }
            if upperLetter.contains(entry1[i]) { return true}
            if upperLetter.contains(entry2[i]) { return false}
        }
        return true
    }
    
}

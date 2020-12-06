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
    
    typealias Seat = (row: Int, column: Int)
    
    
    
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
        for i in 0..<(entries.count) {
            let index = i
            let id1 = computeId(seat:parseEntry(entries[index]))
            let id2 = computeId(seat:parseEntry(entries[index + 1]))
            if (id1 - id2) == 2 {
                seatId = id1 - 1
                break
            }
        }
        print(seatId)
    }
    
    func computeId(seat: Seat) -> Int {
        return seat.row * 8 + seat.column
    }
    
    func parseEntry(_ entry: String) -> Seat {
        var row: (max: Int, min: Int?) = (max: 127, min: 0)
        var column: (max: Int, min: Int?) = (max: 7, min: 0)
        for c in entry {
            if let minRow = row.min, c == "F" || c == "B" {
                row = getPositionRange(currentChar: String(c), part: (max: row.max, min: minRow))
            }
            if let minColumn = column.min, c == "L" || c == "R" {
                column = getPositionRange(currentChar: String(c), part: (max: column.max, min: minColumn))
            }
        }
        return (row: row.max, column: column.max)
    }
    
    func getPositionRange(currentChar:String, part:(max: Int, min: Int)) -> (max: Int, min: Int?) {
        var midSeat  = part.min + (part.max - part.min) / 2
        if (currentChar == "F" || currentChar == "L") {
            //lower half
            if (midSeat == part.min) {
                return (max: midSeat, min: nil)
            }
                
            return (max: midSeat, min: part.min)
        }
        midSeat += 1
        if (currentChar == "B" || currentChar == "R") {
            //upper half
            if (midSeat == part.max) {
                return (max: midSeat, min: nil)
            }
            return (max: part.max, min: midSeat)
        }
        fatalError("Should never happen \(currentChar)")
    }
    
    func highestBoardingPass(entries: [String]) -> Int {
        if let higher = entries.sorted(by: sortEntries(_:_:)).first {
            return computeId(seat: parseEntry(higher))
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

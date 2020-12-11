//
//  Day11.swift
//  adventOfCode
//
//  Created by Céline on 11/12/2020.
//

import Foundation

enum Day11 {
    case step1
    case step2
    
    func run() {
        let rows = Input(inputName: "Day11").contentByLine.compactMap { $0.map { String($0) } }
        switch self {
        case .step1:
            let map = SeatMap(rows: rows)
            map.changeSeats()
        case .step2:
            break
//            self.exercise2(entries: entries, preamble: preamble)
        }
    }
}

class SeatMap {
    var rows: [[String]]
    
    static let freeSign = "L"
    static let occupiedSign = "#"
    static let floorSign = "."
    
    init(rows: [[String]]) {
        self.rows = rows
    }
    
    func changeSeats() {
        var newRows: [[String]] = []
        var hasChange = false
        for y in 0..<rows.count {
            newRows.append([])
            for x in 0..<rows[y].count {
                newRows[y].append(checkSeat(position: (x, y)))
                if newRows[y][x] != rows[y][x] {
                    hasChange = true
                }
            }
        }
        print(newRows)
    }
    
    /*
     If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
     If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
     Otherwise, the seat's state does not change.
     */
    
    private func checkSeat(position: (Int, Int)) -> String {
        let char = rows[position.1][position.0]
        let adjacentsPos = [
            (position.0 - 1, position.1 - 1),
            (position.0 - 1, position.1),
            (position.0 - 1, position.1 + 1),
            (position.0, position.1 - 1),
            (position.0, position.1 + 1),
            (position.0 + 1, position.1 - 1),
            (position.0 + 1, position.1),
            (position.0 + 1, position.1 + 1)
        ]
        if char == SeatMap.freeSign {
            let adjacentNotOccupied = adjacentsPos.filter { (pos) -> Bool in
                if pos.1 > rows.count || pos.1 < 0 ||
                    pos.0 > rows[pos.1].count || pos.0 < 0 {
                    return true
                }
                return rows[pos.1][pos.0] != SeatMap.occupiedSign
            }
            if adjacentNotOccupied.count == adjacentsPos.count {
                return SeatMap.occupiedSign
            }
        }
        if char == SeatMap.occupiedSign {
            let adjacentNotOccupied = adjacentsPos.filter { (pos) -> Bool in
                if pos.1 > rows.count || pos.1 < 0 ||
                    pos.0 > rows[pos.1].count || pos.0 < 0 {
                    return false
                }
                return rows[pos.1][pos.0] == SeatMap.occupiedSign
            }
            if adjacentNotOccupied.count == adjacentsPos.count {
                return SeatMap.freeSign
            }
        }
        return char
    }
    
}

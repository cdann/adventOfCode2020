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
            print("SUCCESS \(map.occupiedSeats())")
        case .step2:
            let map = SeatMap(rows: rows)
            map.changeSeats(visible: true)
            print("SUCCESS \(map.occupiedSeats())")
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
    
    let adjacentMove = [
        (-1, 1),
        (-1, 0),
        (-1, -1),
        (0, 1),
        (0, -1),
        (1, 1),
        (1, 0),
        (1, -1)
    ]
    
    init(rows: [[String]]) {
        self.rows = rows
    }
    
    func occupiedSeats() -> Int {
        self.rows.map({ row -> String in
            row.filter({ $0 == SeatMap.occupiedSign }).joined()
        }).joined().count
    }
    
    
    func changeSeats(visible: Bool = false) {
        var hasChange = true
        var i = 0
        let changes = visible ? changeVisibleSeats(position:) : changeAdjacentSeats(position:)
        while hasChange {
            var newRows: [[String]] = []
            hasChange = false
            for y in 0..<rows.count {
                newRows.append([])
                for x in 0..<rows[y].count {
                    newRows[y].append(changes((x, y)))
                    if newRows[y][x] != rows[y][x] {
                        hasChange = true
                    }
                }
            }
            rows = newRows
            i += 1
        }
    }
    
    func printMap(_ rows: [[String]]? = nil) {
        let mapToPrint = rows ?? self.rows
        mapToPrint.forEach({ (chars) in
            print(chars.joined())
        })
    }
    
    func getSeat(_ pos:(Int, Int)) -> String? {
        if pos.1 >= rows.count || pos.1 < 0 ||
            pos.0 >= rows[pos.1].count || pos.0 < 0 {
            return nil
        }
        return rows[pos.1][pos.0]
    }
    
    func applyConditionIgnoringFloor(pos: (Int, Int), move: (Int, Int), condition: (String?) -> Bool) -> Bool {
        if move.0 == 0 && move.1 == 0 {
            fatalError("Need to move or will loop infinitely")
        }
        var positionCheck = (pos.0 + move.0, pos.1 + move.1)
        while getSeat(positionCheck) == SeatMap.floorSign {
            positionCheck = (positionCheck.0 + move.0, positionCheck.1 + move.1)
        }
        return condition(getSeat(positionCheck))
    }
    
    private func changeVisibleSeats(position: (Int, Int)) -> String {
        let char = rows[position.1][position.0]
        if char == SeatMap.freeSign {
            let visibleNotOccupied = adjacentMove.filter { (move) -> Bool in
                applyConditionIgnoringFloor(pos: position, move: move, condition: { $0 != SeatMap.occupiedSign })
            }
            if visibleNotOccupied.count == adjacentMove.count {
                return SeatMap.occupiedSign
            }
        }
        if char == SeatMap.occupiedSign {
            let visibleOccupied = adjacentMove.filter { (move) -> Bool in
                applyConditionIgnoringFloor(pos: position, move: move, condition: { $0 == SeatMap.occupiedSign })
            }
            if visibleOccupied.count >= 5 {
                return SeatMap.freeSign
            }
        }
        return char
    }
    
    private func changeAdjacentSeats(position: (Int, Int)) -> String {
        let char = rows[position.1][position.0]
        let adjacentsPos = self.adjacentMove.map {(position.0 + $0.0, position.1 + $0.1)}
        if char == SeatMap.freeSign {
            let adjacentNotOccupied = adjacentsPos.filter {
                getSeat($0) != SeatMap.occupiedSign
            }
            if adjacentNotOccupied.count == adjacentsPos.count {
                return SeatMap.occupiedSign
            }
        }
        if char == SeatMap.occupiedSign {
            let adjacentOccupied = adjacentsPos.filter {
                getSeat($0) == SeatMap.occupiedSign
            }
            if adjacentOccupied.count >= 4 {
                return SeatMap.freeSign
            }
        }
        return char
    }
    
}

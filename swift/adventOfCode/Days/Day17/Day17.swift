//
//  Day17.swift
//  adventOfCode
//
//  Created by Céline on 17/12/2020.
//

import Foundation

enum Day17 {
    case step1
    case step2
    
    func run() {
        let entries = Input(inputName: "Day17")
            .contentByLine
        switch self {
        case .step1:
            let map = Map(entries: entries)
            for _ in 0..<6 {
                map.changeToNextCycle()
            }
            print(map.countActive())
        break
        case .step2:
            let map = Map4D(entries: entries)
            for _ in 0..<6 {
                map.changeToNextCycle()
            }
            print(map.countActive())
        break
        }
    }
    
    
    class Position : Hashable, CustomStringConvertible {
        var x: Int
        var y: Int
        var z: Int
        var w: Int? // not used in ex1
        
        init(x: Int, y: Int, z: Int, w: Int? = nil) {
            self.x = x
            self.y = y
            self.z = z
            self.w = w
        }
        
        var description: String {
            "(x: \(x) y: \(y) z: \(z) w:\(w ?? -10)"
        }
        
        static func == (lhs: Day17.Position, rhs: Day17.Position) -> Bool {
            return lhs.x == rhs.x &&
                lhs.y == rhs.y &&
                lhs.z == rhs.z &&
                lhs.w == rhs.w
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
            hasher.combine(z)
            hasher.combine(w)
        }
        
        
    }
    
    class Map4D {
        
        typealias MinMax = (min: Int, max: Int)
        
        var activePositions: Set<Position>
        var bordersX: MinMax
        var bordersY: MinMax
        var bordersZ: MinMax
        var bordersW: MinMax
        
        init(entries: [String]) {
            /// (0, 0, 0) is the position at the upper left of the entry
            var activePositions: Set<Position> = []
            entries.enumerated().forEach { (rowOffset, row) in
                row.enumerated().forEach { (charOffset, char) in
                    guard char == "#" else { return }
                    activePositions.insert(.init(x: charOffset, y: rowOffset, z: 0, w: 0))
                }
            }
            bordersZ = (min: -1, max: 1)
            bordersW = (min:-1, max: 1)
            bordersY = (min: -1, max: entries.count)
            bordersX = (min: -1, max: entries[0].count)
            self.activePositions = activePositions
        }
        
        func drawMap() {
            for w in (bordersW.min + 1)...(bordersW.max - 1) {
                print("#### w: \(w)")
                for z in (bordersZ.min + 1)...(bordersZ.max - 1) {
                    print("z: \(z)")
                    for y in (bordersY.min + 1)...(bordersY.max - 1) {
                        let string = ((bordersX.min + 1)...(bordersX.max - 1)).map { (x) in
                            isActive(x: x, y:y, z:z, w:w) ? "#" : "."
                        }.joined()
                        print("\(string)")
                    }
                    print("\n")
                }
                print("\n")
            }
        }
        
        func extendBordersFrom(positionInAxe: Int, currentBorders: MinMax?) -> MinMax {
            var newBorders: MinMax = MinMax(min: 0, max: 0) /// will be override anyway
            if currentBorders != nil {
                newBorders.min = min(currentBorders!.min, positionInAxe - 1)
                newBorders.max = max(currentBorders!.max, positionInAxe + 1)
            } else {
                newBorders = (min: positionInAxe - 1, max: positionInAxe + 1)
            }
            return newBorders
        }
        
        func changeToNextCycle() {
            var newActivesPosition: Set<Position> = []
            var newBordersX: MinMax? = nil
            var newBordersY: MinMax? = nil
            var newBordersZ: MinMax? = nil
            var newBordersW: MinMax? = nil
            for w in (bordersW.min)...(bordersW.max) {
                for z in (bordersZ.min)...(bordersZ.max) {
                    for y in (bordersY.min)...(bordersY.max) {
                        for x in (bordersX.min)...(bordersX.max) {
    //                        print("x: \(x), y: \(y), z: \(z)")
                            if checkIsPositionNowActive(x: x, y: y, z: z, w: w) {
    //                            print("active")
                                let currentPosition = Position(x: x, y: y, z: z, w: w)
                                newActivesPosition.insert(currentPosition)
                                newBordersX = extendBordersFrom(positionInAxe: x, currentBorders: newBordersX)
                                newBordersY = extendBordersFrom(positionInAxe: y, currentBorders: newBordersY)
                                newBordersZ = extendBordersFrom(positionInAxe: z, currentBorders: newBordersZ)
                                newBordersW = extendBordersFrom(positionInAxe: w, currentBorders: newBordersW)
                            }
                        }
                    }
                }
            }
            activePositions = newActivesPosition
            bordersX = newBordersX ?? bordersX
            bordersY = newBordersY ?? bordersY
            bordersZ = newBordersZ ?? bordersZ
            bordersW = newBordersW ?? bordersW
        }
        
        
        func checkIsPositionNowActive(x: Int, y: Int, z: Int, w: Int) -> Bool {
            var actives = 0
            for nW in (w - 1)...(w + 1) {
                for nZ in (z - 1)...(z + 1) {
                    for nY in (y - 1)...(y + 1) {
                        for nX in (x - 1)...(x + 1) {
                            if nZ == z && nY == y && nX == x && nW == w {
                                continue;
                            }
                            actives += isActive(x: nX, y: nY, z: nZ, w: nW) ? 1 : 0
    //                        print("\((nX, nY, nZ)) \(isActive(x: nX, y: nY, z: nZ))")
                        }
                    }
                }
            }
            return actives == 3 || (actives == 2 && isActive(x: x, y: y, z: z, w: w))
        }
        
        func countActive() -> Int {
            return ((bordersW.min)...(bordersW.max)).reduce(0) { (accW, w) -> Int in
                accW + ((bordersZ.min)...(bordersZ.max)).reduce(0) { (accZ, z) -> Int in
                    accZ + ((bordersY.min)...(bordersY.max)).reduce(0) { (accY, y) -> Int in
                        accY + ((bordersX.min)...(bordersX.max)).reduce(0) {
                            $0 + (isActive(x: $1, y: y, z: z, w: w) ? 1 : 0)
                        }
                    }
                }
            }
        }
        
        func isActive(x: Int, y: Int, z: Int, w: Int) -> Bool {
            let position = Position(
                x: x,
                y: y,
                z: z,
                w: w
            )
            return activePositions.contains(position)
        }
    }
    
    class Map {
        
        typealias MinMax = (min: Int, max: Int)
        
        var activePositions: Set<Position>
        var bordersX: MinMax
        var bordersY: MinMax
        var bordersZ: MinMax
        init(entries: [String]) {
            /// (0, 0, 0) is the position at the upper left of the entry
            var activePositions: Set<Position> = []
            entries.enumerated().forEach { (rowOffset, row) in
                row.enumerated().forEach { (charOffset, char) in
                    guard char == "#" else { return }
                    activePositions.insert(.init(x: charOffset, y: rowOffset, z: 0))
                }
            }
            bordersZ = (min: -1, max: 1)
            bordersY = (min: -1, max: entries.count)
            bordersX = (min: -1, max: entries[0].count)
            self.activePositions = activePositions
        }
        
        func drawMap() {
            for z in (bordersZ.min + 1)...(bordersZ.max - 1) {
                print("z: \(z)")
                for y in (bordersY.min + 1)...(bordersY.max - 1) {
                    let string = ((bordersX.min + 1)...(bordersX.max - 1)).map { (x) in
                        isActive(x: x, y:y, z:z) ? "#" : "."
                    }.joined()
                    print("\(string)")
                }
                print("\n")
            }
        }
        
        func extendBordersFrom(positionInAxe: Int, currentBorders: MinMax?) -> MinMax {
            var newBorders: MinMax = MinMax(min: 0, max: 0) /// will be override anyway
            if currentBorders != nil {
                newBorders.min = min(currentBorders!.min, positionInAxe - 1)
                newBorders.max = max(currentBorders!.max, positionInAxe + 1)
            } else {
                newBorders = (min: positionInAxe - 1, max: positionInAxe + 1)
            }
            return newBorders
        }
        
        func changeToNextCycle() {
            var newActivesPosition: Set<Position> = []
            var newBordersX: MinMax? = nil
            var newBordersY: MinMax? = nil
            var newBordersZ: MinMax? = nil
            for z in (bordersZ.min)...(bordersZ.max) {
                for y in (bordersY.min)...(bordersY.max) {
                    for x in (bordersX.min)...(bordersX.max) {
//                        print("x: \(x), y: \(y), z: \(z)")
                        if checkIsPositionNowActive(x: x, y: y, z: z) {
//                            print("active")
                            let currentPosition = Position(x: x, y: y, z: z)
                            newActivesPosition.insert(currentPosition)
                            newBordersX = extendBordersFrom(positionInAxe: x, currentBorders: newBordersX)
                            newBordersY = extendBordersFrom(positionInAxe: y, currentBorders: newBordersY)
                            newBordersZ = extendBordersFrom(positionInAxe: z, currentBorders: newBordersZ)
                        }
                    }
                }
            }
            activePositions = newActivesPosition
            bordersX = newBordersX ?? bordersX
            bordersY = newBordersY ?? bordersY
            bordersZ = newBordersZ ?? bordersZ
        }
        
        func checkIsPositionNowActive(x: Int, y: Int, z: Int) -> Bool {
            var actives = 0
            for nZ in (z - 1)...(z + 1) {
                for nY in (y - 1)...(y + 1) {
                    for nX in (x - 1)...(x + 1) {
                        if nZ == z && nY == y && nX == x {
                            continue;
                        }
                        actives += isActive(x: nX, y: nY, z: nZ) ? 1 : 0
//                        print("\((nX, nY, nZ)) \(isActive(x: nX, y: nY, z: nZ))")
                    }
                }
            }
            return actives == 3 || (actives == 2 && isActive(x: x, y: y, z: z))
        }
        
        func countActive() -> Int {
            return ((bordersZ.min)...(bordersZ.max)).reduce(0) { (accZ, z) -> Int in
                accZ + ((bordersY.min)...(bordersY.max)).reduce(0) { (accY, y) -> Int in
                    accY + ((bordersX.min)...(bordersX.max)).reduce(0) {
                        $0 + (isActive(x: $1, y: y, z: z) ? 1 : 0)
                    }
                }
            }
        }
        
        func isActive(x: Int, y: Int, z: Int) -> Bool {
            let position = Position(
                x: x,
                y: y,
                z: z
            )
            return activePositions.contains(position)
        }
    }
}


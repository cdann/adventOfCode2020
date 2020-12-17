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
            let map = Map(entries: entries, is4D: false)
            for _ in 0..<6 {
                map.changeToNextCycle()
            }
            map.drawMap()
            print("SUCCESS \(map.countActive()) \n")
        break
        case .step2:
            let map = Map(entries: entries, is4D: true)
            map.drawMap()
            for _ in 0..<6 {
                map.changeToNextCycle()
            }
            print("SUCCESS \(map.countActive()) \n")
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
            "(x: \(x) y: \(y) z: \(z) w:\(w?.description ?? "nop"))"
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
    
    class Map {
        
        typealias MinMax = (min: Int, max: Int)
        
        var activePositions: Set<Position>
        var bordersX: MinMax
        var bordersY: MinMax
        var bordersZ: MinMax
        var bordersW: MinMax?
        
        let is4D: Bool
        
        init(entries: [String], is4D: Bool) {
            /// (0, 0, 0) is the position at the upper left of the entry
            var activePositions: Set<Position> = []
            entries.enumerated().forEach { (rowOffset, row) in
                row.enumerated().forEach { (charOffset, char) in
                    guard char == "#" else { return }
                    activePositions.insert(.init(x: charOffset, y: rowOffset, z: 0, w: is4D ? 0 : nil))
                }
            }
            self.is4D = is4D
            if (is4D) {
                bordersW = (min:-1, max: 1)
            }
            bordersZ = (min: -1, max: 1)
            bordersY = (min: -1, max: entries.count)
            bordersX = (min: -1, max: entries[0].count)
            self.activePositions = activePositions
        }
        
        func drawMap() {
            forEachPosition(
                inX:(min: 0, max: 0),
                transformBorders: { border in
                    border.map({ (min: $0.min + 1, max: $0.max - 1) })
                },
                forNextZ: { print("z: \($0)") },
                forNextW: { print("\n#### w: \($0)") }) { (x, y, z, w) in
                print(((bordersX.min + 1)...(bordersX.max - 1)).map { (x) in
                    isActive(x: x, y:y, z:z, w:w) ? "#" : "."
                }.joined())
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
            var checkedPosition: Set<Position> = []
            
            activePositions.forEach { (position) in
                forEachPosition(inX: (min:position.x - 1, max: position.x + 1),
                            inY: (min:position.y - 1, max: position.y + 1),
                            inZ: (min:position.z - 1, max: position.z + 1),
                            inW: position.w.map{ (min:$0 - 1, max: $0 + 1) }) { (x, y, z, w) in
                    let currentPosition = Position(x: x, y: y, z: z, w: w)
                    if !checkedPosition.contains(currentPosition) && checkIsPositionNowActive(pos: currentPosition) {
                        let currentPosition = Position(x: x, y: y, z: z, w: w)
                        newActivesPosition.insert(currentPosition)
                        newBordersX = extendBordersFrom(positionInAxe: x, currentBorders: newBordersX)
                        newBordersY = extendBordersFrom(positionInAxe: y, currentBorders: newBordersY)
                        newBordersZ = extendBordersFrom(positionInAxe: z, currentBorders: newBordersZ)
                        newBordersW = w.map{
                            extendBordersFrom(positionInAxe: $0, currentBorders: newBordersW)
                        }
                    }
                    checkedPosition.insert(currentPosition)
                }
            }
            activePositions = newActivesPosition
            bordersX = newBordersX ?? bordersX
            bordersY = newBordersY ?? bordersY
            bordersZ = newBordersZ ?? bordersZ
            bordersW = newBordersW ?? bordersW
        }
        
        
        
        func checkIsPositionNowActive(pos: Position) -> Bool {
            var actives = 0
            forEachPosition(
                inX: (min: pos.x - 1, max: pos.x + 1),
                inY: (min: pos.y - 1, max: pos.y + 1),
                inZ: (min: pos.z - 1, max: pos.z + 1),
                inW: pos.w.map({ (min: $0 - 1, max: $0 + 1) })
            ) { (nX, nY, nZ, nW) in
                if nZ == pos.z && nY == pos.y && nX == pos.x && nW == pos.w {
                    return
                }
                actives += isActive(x: nX, y: nY, z: nZ, w: nW) ? 1 : 0
            }
            return actives == 3 || (actives == 2 && activePositions.contains(pos))
        }
        
        func countActive() -> Int {
            return activePositions.count
        }
        
        func isActive(x: Int, y: Int, z: Int, w: Int?) -> Bool {
            let position = Position(x: x, y: y, z: z, w: w)
            return activePositions.contains(position)
        }
        
        func forEachPosition(
            inX: MinMax? = nil,
            inY: MinMax? = nil,
            inZ: MinMax? = nil,
            inW: MinMax? = nil,
            transformBorders: ((MinMax?) -> MinMax?)? = nil,
            forNextY: ((Int) -> ())? = nil,
            forNextZ: ((Int) -> ())? = nil,
            forNextW: ((Int) -> ())? = nil,
            completion: (Int, Int, Int, Int?) -> ()
        ) {
            let inX = inX ?? transformBorders?(bordersX) ?? bordersX
            let inY = inY ?? transformBorders?(bordersY) ?? bordersY
            let inZ = inZ ?? transformBorders?(bordersZ) ?? bordersZ
            let inW = inW ?? transformBorders?(bordersW) ?? bordersW ?? (min: 0, max: 0)
            for w in inW.min...inW.max {
                forNextW?(w)
                for z in inZ.min...inZ.max {
                    forNextZ?(z)
                    for y in inY.min...inY.max {
                        forNextY?(y)
                        for x in inX.min...inX.max {
                            completion(x, y, z, is4D ? w : nil)
                        }
                    }
                }
            }
        }
    }
}
   

//
//  Day10.swift
//  adventOfCode
//
//  Created by Céline on 10/12/2020.
//

import Foundation

enum Day10 {
    case step1
    case step2
    
    static let acceptedDiff = 3
    
    func run(inputName: String = "Day10") {
        let input = Input(inputName: inputName).contentByLine.compactMap({ Int($0) })
        switch self {
        case .step1:
            exercise1(entries: input)
        case .step2:
            exercise2(entries: input)
        }
    }
    
    func test() {
        run(inputName: "Day10test")
    }
    
    func exercise1(entries: [Int]) {
        let entries = entries.sorted()
        var prev = 0
        var diffCount = (three: 0, one: 0)
        for entry in entries {
            
            let diff = entry - prev
            if (diff > 3) {
                print("last is \(prev)")
                break
            } else if (diff == Day10.acceptedDiff) {
                prev = entry
                diffCount.three += 1
            } else if (diff == 1) {
                prev = entry
                diffCount.one += 1
            } else {
                prev = entry
            }
        }
        diffCount.three += 1 // adapter
        print("SUCCESS: \(diffCount) \(diffCount.three * diffCount.one)")
    }
    
    func exercise2(entries: [Int]) {
        var entries = entries.sorted()
        entries = [0] + entries + [entries.last! + Day10.acceptedDiff]
        var combinationFor: [Int: Int] = [0:1]
        for i in 0..<entries.count - 1 {
            for j in 1...Day10.acceptedDiff {
                if i + j < entries.count, entries[i + j] - entries[i] <= Day10.acceptedDiff {
                    let val = entries[i + j]
                    combinationFor[val] = (combinationFor[val] ?? 0) + combinationFor[entries[i]]!
                }
            }
        }
        let result = combinationFor[combinationFor.keys.max()!]!
        print("SUCCESS: \(result)")
    }
    
}


//
//  Day9.swift
//  adventOfCode
//
//  Created by Céline on 09/12/2020.
//

import Foundation

enum Day9 {
    case step1
    case step2
    
    func run() {
        let entries = Input(inputName: "Day9").contentByLine.compactMap { Int($0) }
        let preamble = entries[0..<25]
        switch self {
        case .step1:
            self.exercise1(entries: entries, preamble: preamble)
        case .step2:
            self.exercise2(entries: entries, preamble: preamble)
        }
    }
    
    private func exercise1(entries: [Int], preamble: ArraySlice<Int>) {
        guard let (weakness, _) = findWeakness(entries: entries, preamble: preamble) else {
            fatalError("unreachable")
        }
        print("SUCCESS \(weakness)")
    }
    
    private func exercise2(entries: [Int], preamble: ArraySlice<Int>) {
        guard let (weakness, browsedValues) = findWeakness(entries: entries, preamble: preamble) else {
            fatalError("unreachable")
        }
        var browsedArray = ArraySlice<Int>(preamble + browsedValues)
        var i = 0
        while let firstVal = browsedArray.popFirst() {
            if (firstVal > weakness) { break }
            var set: Set<Int> = [firstVal]
            var sumOfSet = firstVal
            for value in browsedArray {
                let sum = sumOfSet + value
                if (sum == weakness) {
                    set.insert(value)
                    print("SUCCESS \(set.min()! + set.max()!)")
                    return
                } else if (sum > weakness) {
                    break
                } else {
                    set.insert(value)
                    sumOfSet = sum
                }
            }
            i += 1
        }
        print("FAIL")
    }
    
    
    private func findWeakness(entries: [Int], preamble: ArraySlice<Int>) -> (weakness: Int, browsedValues: [Int])? {
        var preamble = preamble
        var browsedValues: [Int] = []
        for i in preamble.count..<entries.count {
            var hasMatch = false
            for value in preamble {
                if preamble.contains(entries[i] - value) {
                    hasMatch = true
                    break
                }
            }
            if !hasMatch {
                return (weakness:entries[i], browsedValues: browsedValues)
            }
            browsedValues.append(entries[i])
            _ = preamble.popFirst()
            preamble.append(entries[i])
        }
        return nil
    }

}

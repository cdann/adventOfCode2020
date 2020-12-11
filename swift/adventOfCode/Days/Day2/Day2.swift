//
//  Day2.swift
//  adventOfCode
//
//  Created by Céline on 04/12/2020.
//

import Foundation

enum Day2 {
    case step1
    case step2
    
    func run() {
        switch self {
        case .step1:
            print(getNumberOfAllowedPassord(Input.array, check: checkCharCount(_:)))
        case .step2:
            print(getNumberOfAllowedPassord(Input.array, check: checkCharPosition(_:)))
        }
    }
    
    
    typealias PolicyPasswordEntry = (min: Int, max: Int, char: String, str: String)

    func parseEntry(_ str: String) -> PolicyPasswordEntry {
        let stringParts = str.split(separator: " ")
        let minMaxStr = stringParts[0].split(separator: "-")
        let min = Int(truncating: NumberFormatter().number(from: String(minMaxStr[0])) ?? 0)
        let max = Int(truncating: NumberFormatter().number(from: String(minMaxStr[1])) ?? 0)
        let char = String(stringParts[1].first!)
        let str = String(stringParts[2])
        return (min: min, max: max, char: char, str: str)
    }
    
    func checkCharCount(_ entry: PolicyPasswordEntry) -> Bool {
        let charsearched = Character(entry.char)
        let count = entry.str.filter({ $0 == charsearched }).count
        //print("$filteredCount ::: ${password.searchedChar} ${password.min} ${password.max} ### ${password.pwd}");
//        if (!(count >= entry.min && count <= entry.max)) {
            print("\(count >= entry.min && count <= entry.max)   \(count) ::: \(charsearched) \(entry.min) \(entry.max) ### \(entry.str)")
//        }
        return count >= entry.min && count <= entry.max
    }

    func checkCharPosition(_ entry: PolicyPasswordEntry) -> Bool {
        let charsearched = Character(entry.char)
        // let count = entry.str.filter({ $0 == charsearched}).count

        let index1 = entry.str.index(entry.str.startIndex, offsetBy: entry.min - 1)
        let index2 = entry.str.index(entry.str.startIndex, offsetBy: entry.max - 1)
        
        let isChar1 = entry.str[index1] == charsearched
        let isChar2 = entry.str[index2] == charsearched
        return (isChar1 || isChar2) && (isChar2 != isChar1)
    }

    func getNumberOfAllowedPassord(_ entries: [String], check: (PolicyPasswordEntry) -> Bool ) -> Int {
        return entries.reduce(0) { (acc, entryStr) in
            let entry = parseEntry(entryStr)
            let isAllowed = check( entry)
            return isAllowed ? acc + 1 : acc
        }
    }
}

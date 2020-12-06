//
//  Day6.swift
//  adventOfCode
//
//  Created by Céline on 06/12/2020.
//

import Foundation

enum Day6 {
    case step1
    case step2
    
    func run() {
        let entriesGroups = Input.entries
            .components(separatedBy: "\n\n")
            .filter({ !$0.isEmpty })
        switch self {
        case .step1:
            print(exercise1(groups: entriesGroups))
        case .step2:
            print(exercise2(groups: entriesGroups))
        }
    }
    
    func exercise1(groups: [String]) -> Int {
        return groups.reduce(0) { (acc, group) -> Int in
            acc + Set<Character>(group.filter { !$0.isNewline }).count
        }
    }
    
    func exercise2(groups: [String]) -> Int {
        return groups.reduce(0) { (acc, group) -> Int in
            let persons = group.components(separatedBy: .newlines)
            let commonAnswers = persons.reduce(Set("a"..."z")) { (acc, person) -> Set<Character> in
                return Set<Character>(person).intersection(Set(acc))
            }
            return commonAnswers.count + acc
        }
    }
}

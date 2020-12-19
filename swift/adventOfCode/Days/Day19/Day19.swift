//
//  Day19.swift
//  adventOfCode
//
//  Created by celine dann on 19/12/2020.
//

import Foundation

import Foundation

class RegexEasy {
    func regexOnString(pattern:String, str: String, searchedGroupName: [String]) -> [String:String]? {
        guard
            let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
            let match = regex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.utf16.count))
        else {
            return nil
        }
        var result: [String:String] = [:]
        for groupName in searchedGroupName {
            if let range = Range(match.range(withName: groupName), in: str) {
                result[groupName] = String(str[range])
            }
        }
        return result
    }
}

enum Day19 {
    case step1
    case step2
    
    typealias RuleId = Int
    
    indirect enum Rule: Equatable {
        case character(Character)
        case order([RuleId])
        case or(Rule, Rule)
    }
    
    func run() {
        let entries = Input(inputName: "Day19").contentByParagraph
        let rules = entries[0].getLines()
        let datas = entries[1].getLines()
        switch self {
        case .step1:
            let result = exercise1(rulesEntries: rules, datas: datas)
            print("SUCCESS \(result) \n")
        break
        case .step2:
            let result = exercise2(rulesEntries: rules, datas: datas)
            print("SUCCESS \(result) \n")
        break
        }
    }
    
    func buildRules(rulesEntries: [String]) -> [Int : Rule] {
        let ruleIdGroupName = "ruleId"
        let charGroupName = "char"
        let firstOrderGroupName = "firstOrder"
        let secondOrderGroupName = "secondOrder"
        
        let pattern = "(?<\(ruleIdGroupName)>\\d+): ((\\\"(?<\(charGroupName)>[a-z])\\\")|(?<\(firstOrderGroupName)>(\\d[ ]*)+)(\\| (?<\(secondOrderGroupName)>(\\d[ ]*)+))*)"
        return Dictionary.init(uniqueKeysWithValues:
            rulesEntries.map { (entry) -> (RuleId, Rule) in
                guard let dict = RegexEasy().regexOnString(pattern: pattern, str: entry, searchedGroupName: [ruleIdGroupName, charGroupName, firstOrderGroupName, secondOrderGroupName]),
                      let ruleIdGroup = dict[ruleIdGroupName],
                      let ruleId = Int(ruleIdGroup)
                else {
                    fatalError("should not happen")
                }
                if let char = dict[charGroupName] {
                    return (ruleId, Rule.character(char.first!))
                }
                if let firstStr = dict[firstOrderGroupName] {
                    let firstOrder = firstStr.components(separatedBy: .whitespaces).compactMap({ Int($0) })
                    let firstRule = Rule.order(firstOrder)
                    guard let secondStr = dict[secondOrderGroupName] else {
                        return (ruleId, firstRule)
                    }
                    let secondOrder = secondStr.components(separatedBy: .whitespaces).compactMap({ Int($0) })
                    let secondRule = Rule.order(secondOrder)
                    return (ruleId, Rule.or(firstRule, secondRule))
                }
                fatalError("should not happen")
            }
        )
    }
    
    func buildPatternForRule(rules: [Int : Rule], ruleToSolve: Rule) -> String {
        switch ruleToSolve {
        case let .character(char):
            return String(char)
        case let .order(orderRules):
            return orderRules.reduce("") { (acc, ruleId) in
                acc + buildPatternForRule(rules: rules, ruleToSolve: rules[ruleId]!)
            }
        case let .or(firstOrderRule, secondOrderRule):
            let firstOrder = buildPatternForRule(rules: rules, ruleToSolve: firstOrderRule)
            let secondOrder = buildPatternForRule(rules: rules, ruleToSolve: secondOrderRule)
            return "(" + firstOrder + "|" + secondOrder + ")"
        }
    }

    func resolveRule(_ ruleToSolve: Rule, rules: [Int : Rule], str:String) -> String? {
        switch ruleToSolve {
        case let .character(char):
            if char == str.first {
                return String(str.dropFirst())
            }
            return nil
        case let .or(lrule, rrule):
            let result  = resolveRule(lrule, rules: rules, str: str) ?? resolveRule(rrule, rules: rules, str: str)
            return result
        case let .order(orderRules):
            return orderRules.reduce(str) { (acc, ruleId) -> String? in
                if let string = acc,
                   let leftStr = resolveRule(rules[ruleId]!, rules: rules, str: string) {
                    return leftStr
                }
                return nil
            }
        }
    }

    func exercise1(rulesEntries: [String], datas: [String]) -> Int {
        let rules = buildRules(rulesEntries: rulesEntries)
        let pattern = "^" + buildPatternForRule(rules: rules, ruleToSolve: rules[0]!) + "$"
        return datas.reduce(0) { (acc, data) in
            if let _ = RegexEasy().regexOnString(pattern: pattern, str: data, searchedGroupName: []) {
                print("\(data) OK")
                return acc + 1
            }
            print("\(data) NO")
            return acc
        }
    }
    
    func firstRule(rules: [Int : Rule], str:String) -> Bool {
        var strLeft: String? = nil
        // override rules[0] call
        while let tmp = resolveRule(rules[42]!, rules: rules, str: strLeft ?? str) {
            strLeft = tmp
            var i = 0
            var strLeft2: String? = nil
            while let tmp2 = resolveRule(rules[42]!, rules: rules, str: strLeft2 ?? strLeft!) {
                i += 1
                strLeft2 = tmp2
            }
            if i == 0 || strLeft2 == nil || strLeft2?.count == 0 {
                continue
            }
            while let tmp2 = resolveRule(rules[31]!, rules: rules, str: strLeft2!) {
                i -= 1
                strLeft2 = tmp2
            }
            if (i == 0 && strLeft2!.isEmpty) {
                return true
            }
        }
        return false
    }
    
    func exercise2(rulesEntries: [String], datas: [String]) -> Int {
        let rules = buildRules(rulesEntries: rulesEntries)
        return datas.reduce(0) { firstRule(rules: rules, str: $1) ? $0 + 1 : $0 }
    }
}

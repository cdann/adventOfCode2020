//
//  Day16.swift
//  adventOfCode
//
//  Created by Céline on 16/12/2020.
//

import Foundation

enum Day16 {
    case step1
    case step2
    
    func run() {
        let entries = Input(inputName: "Day16")
            .contentByLine
        switch self {
        case .step1:
            let tickets = TicketsData(lines: entries)
            print(tickets.ticketScanningError)
        break
        case .step2:
            let tickets = TicketsData(lines: entries)
            tickets.findFieldsOrder()
        break
        }
    }
}

extension Day16 {
    class TicketsData {
        var ticketsFieldRule : [String: [ClosedRange<Int>]] = [:]
        var nearbyValidTickets: [[Int]] = []
        var ticketScanningError: Int = 0
        var ownedTicket: [Int] = []
        
        enum Step {
            case rules(NSRegularExpression)
            case ownedTicket
            case nearbyTickets
        }
        
        enum FGroup: String {
            case name
            case r1Start
            case r1End
            case r2Start
            case r2End
            
            static let pattern = "(?<\(FGroup.name)>.*): (?<\(FGroup.r1Start)>\\d*)-(?<\(FGroup.r1End)>\\d*) or (?<\(FGroup.r2Start)>\\d*)-(?<\(FGroup.r2End)>\\d*)"
            
        }
        
        static func getGroup(_ group: FGroup, in str: String, with match: NSTextCheckingResult) -> Int? {
            guard let range = Range(match.range(withName: group.rawValue), in: str),
                  let value = Int(String(str[range])) else {
                return nil
            }
            return value
        }
        
        func parseRules(line: String, match: NSTextCheckingResult) {
            let getGroup = TicketsData.getGroup
            
            guard
                let nameRange = Range(match.range(withName: FGroup.name.rawValue), in: line),
                let r1Start = getGroup(.r1Start, line, match),
                let r1End = getGroup(.r1End, line, match),
                let r2Start = getGroup(.r2Start, line, match),
                let r2End = getGroup(.r2End, line, match)
                  else {
                print("No match field \(line)")
                return
            }
            ticketsFieldRule[String(line[nameRange])] = [r1Start...r1End, r2Start...r2End]
        }
        
        func checkNearByTickets(ticket: [Int]) {
            for value in ticket {
                var haveMatch = false
                for range in ticketsFieldRule.values.flatMap({ $0 }) {
                    if range.contains(value) {
                        haveMatch = true
                        break
                    }
                }
                if !haveMatch {
                    ticketScanningError += value
                    return
                }
            }
            nearbyValidTickets.append(ticket)
        }
        
        func datasFrom(line: String, step: Step) {
            let getTickets: (String) -> [Int] = { $0.components(separatedBy: ",").compactMap{ Int($0) } }
            switch step {
            case .rules(let regex):
                guard  let match = regex.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count)) else {
                    return
                }
                parseRules(line: line, match: match)
            case .nearbyTickets:
                let ticket = getTickets(line)
                checkNearByTickets(ticket: ticket)
            case .ownedTicket:
                ownedTicket = getTickets(line)
            }
        }
        
        init(lines: [String]) {
            let regex = try! NSRegularExpression(pattern: FGroup.pattern, options: .caseInsensitive)
            var step = Step.rules(regex)
            for line in lines {
                if line == "nearby tickets:" {
                    step = .nearbyTickets
                    continue
                }
                if line == "your ticket:" {
                    step = .ownedTicket
                    continue
                }
                self.datasFrom(line: line, step: step)
            }
        }
        
        func findFieldsOrder() {

            var possibleRulesForIndex: [Int: [String]] = Dictionary
                .init(uniqueKeysWithValues:
                        (0..<nearbyValidTickets[0].count)
                        .map({ ($0, Array(ticketsFieldRule.keys))})
                )
            
            for ticket in nearbyValidTickets {
                ticket.enumerated().forEach { (index, value) in
                    possibleRulesForIndex[index]! = possibleRulesForIndex[index]!
                        .filter({ (field) -> Bool in
                            for rule in ticketsFieldRule[field]! {
                                if rule.contains(value) {
                                    return true
                                }
                            }
                            return false
                        })
                }
            }
            
            var fieldforIndex:  [String: Int] = [:]
            var newMatchingField = true
            while newMatchingField {
                newMatchingField = false
                possibleRulesForIndex.forEach { (index, possibleRules) in
                    let firstCount = possibleRulesForIndex[index]!.count
                    possibleRulesForIndex[index] = possibleRules
                        .filter({ !fieldforIndex.keys.contains($0) })
                    if possibleRules.count == 1 {
                        fieldforIndex[possibleRules.first!] = index
                        possibleRulesForIndex.removeValue(forKey: index)
                        newMatchingField = true
                        return
                    }
                    if firstCount != possibleRulesForIndex[index]!.count {
                        newMatchingField = true
                    }
                }
            }
            
            let result = fieldforIndex.reduce(1) { (acc, field) in
                if field.key.contains("departure") {
                    return acc * ownedTicket[field.value]
                }
                return acc
            }
            print("Success \(result)")
        }
    }
}

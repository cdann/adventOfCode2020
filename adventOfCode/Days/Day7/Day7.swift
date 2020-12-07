//
//  Day7.swift
//  adventOfCode
//
//  Created by Céline on 07/12/2020.
//

import Foundation

enum Day7 {
    case step1
    case step2
    
    
    struct BagCondition {
        let bagColor: String
        let containedColor: Set<String>
        let countByColor: [String: Int]
        
        init(entry: String) {
            let words = entry.components(separatedBy: .whitespaces)
            self.bagColor = words[0] + " " + words[1]
            let colorList = Array(words.suffix(words.count - 4))
            if colorList.count < 4 {
                containedColor = []
                countByColor = [:]
                return
            }
            var i = 0
            var colors = [String: Int]()
            while i < colorList.count {
                let bagColor = colorList[i + 1] + " " + colorList[i + 2]
                colors[bagColor] = Int(colorList[i])!
                i += 4
            }
            containedColor = Set(colors.keys)
            countByColor = colors
        }
    }
    
    func run() {
        let bagConditionEntries = Input(inputName: "Day7").contentByLine
        switch self {
        case .step1:
            exercise1(entries: bagConditionEntries)
        case .step2:
            exercise2(entries: bagConditionEntries)
        }
    }
    
    func exercise1(entries: [String]) {
        let bagsConditions = entries.map({ BagCondition(entry: $0) })
        var searchingColors: Set<String> = ["shiny gold"]
        var nextColors: Set<String> = []
        var searchedColors: Set<String> = []

        while !searchingColors.isEmpty {
            bagsConditions.forEach { (condition) in
                let intersection = condition.containedColor.intersection(searchingColors)
                if !intersection.isEmpty && !searchedColors.contains(condition.bagColor) {
                    nextColors.insert(condition.bagColor)
                }
            }
            searchedColors = searchedColors.union(searchingColors)
            searchingColors = nextColors
            nextColors = []
        }
        print(searchedColors.count - 1) // minus "shiny gold"
    }
    
    func exercise2(entries: [String]) {
        let rules = getRules(entries: entries)
        let result = getCountForColor(color: "shiny gold", numberForThatColor: 1, allBagsRules: rules) - 1 // minus shiny Gold one
        print(result)
    }
    
    func getRules(entries: [String]) -> [String:[String: Int]] {
        return Dictionary.init(uniqueKeysWithValues: entries.map({ (entry) -> (String, [String: Int]) in
            let condition = BagCondition(entry: entry)
            return (condition.bagColor, condition.countByColor)
        }))
    }
    
    func getCountForColor(color: String, numberForThatColor: Int, allBagsRules: [String:[String: Int]]) -> Int {
        let currentColorRules = allBagsRules[color]!
        let contentBags = currentColorRules.reduce(0) { (acc, rule) -> Int in
            let (color, number) = rule
            return acc + self.getCountForColor(color: color, numberForThatColor: number, allBagsRules: allBagsRules)
        }
        print("COLOR \(color) :: \(numberForThatColor) + \(numberForThatColor) * \(contentBags)")
        return numberForThatColor + numberForThatColor * (contentBags)
    }
    
}

//
//  Day15.swift
//  adventOfCode
//
//  Created by Céline on 15/12/2020.
//

import Foundation

enum Day15 {
    case step1
    case step2
    
    func run() {
        let entries = Input(inputName: "Day15")
            .contentByLine[0]
            .components(separatedBy: ",")
            .compactMap { Int($0) }
        switch self {
        case .step1:
            play(start: entries, turns: 2020)
        case .step2:
            play(start: entries, turns: 30000000)
        break
        }
    }
}

extension Day15 {
    func play(start: [Int], turns: Int) {
        var saidNumbers: [Int: Int] = [:]
        var lastSaid : Int? = nil
        for i in 1...turns {
            let numberToSay: Int
            if i <= start.count {
                let number = start[i - 1]
                numberToSay = number
            } else if let lastSaidN = lastSaid, let number = saidNumbers[lastSaidN] {
                numberToSay = (i - 1) - number
            } else {
                numberToSay = 0
            }
            if let lastSaid = lastSaid {
                saidNumbers[lastSaid] = i - 1
            }
            lastSaid = numberToSay
        }
        print(lastSaid)
    }
}

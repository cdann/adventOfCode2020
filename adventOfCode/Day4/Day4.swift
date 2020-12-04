//
//  Day4.swift
//  adventOfCode
//
//  Created by Céline on 04/12/2020.
//

import Foundation

enum Day4 {
    case step1
    case step2
    
    func run() {
        switch self {
        case .step1:
            print(countValidatePasswords(keyValueValidation: {_, _ in true }))
        case .step2:
            print(countValidatePasswords(keyValueValidation: { validateField(key: $0, val: $1) }))
        }
    }
    
    
    private func countValidatePasswords(keyValueValidation: (String, String) -> Bool) -> Int {
        let passportsDatas = Input.passportsDatas.components(separatedBy: "\n\n")
        let passportsLines = passportsDatas.map{ $0.split(separator:"\n") }
        let validPassportCount = passportsLines.reduce(0) {
            acc, lines -> Int in
            let pairedData = lines.flatMap { (line) in
                line.split(separator: " ")
            }
            var requiredFields = ["ecl" : false, "pid": false, "hcl": false, "byr": false, "iyr": false, "eyr": false, "hgt": false]
            pairedData.forEach { (pair) in
                let splitDatas = pair.split(separator: ":")
                if splitDatas.count < 2 {
                    print("wrong datas : \(pair)")
                    return
                }
                let key = String(splitDatas[0])
                let value = String(splitDatas[1])
                requiredFields[key] = keyValueValidation(key, value) //validateField(key: key, val: value)
            }
            let isValid = requiredFields.values.reduce(true) { $0 && $1 }
            return isValid ? acc + 1 : acc
        }
        return validPassportCount
    }
    
    
    
    private func validateField(key: String, val: String) -> Bool {
        switch key {
        case "byr":
            return val.count == 4 &&
            Int(val).map{ $0 <= 2002 && $0 >= 1920 } ?? false
        case "iyr":
            return val.count == 4 &&
                Int(val).map{ $0 <= 2020 && $0 >= 2010 } ?? false
        case "eyr":
            return val.count == 4 &&
                Int(val).map{ $0 <= 2030 && $0 >= 2020 } ?? false
        case "hgt":
            var suffix: String? = nil
            var maxHeight: Int = 0
            var minHeight: Int = 0
            if val.hasSuffix("in") {
                suffix = "in"
                maxHeight = 76
                minHeight = 59
            } else if val.hasSuffix("cm") {
                suffix = "cm"
                maxHeight = 193
                minHeight = 150
            }
            guard let suff = suffix else { return false }
        
            var charTrim = CharacterSet(charactersIn: suff)
            charTrim.formUnion(.whitespaces)
            let valWtoutUnit = val.trimmingCharacters(in: charTrim)
            let isHeightValid = Int(valWtoutUnit).map {$0 <= maxHeight && $0 >= minHeight}
            
            return isHeightValid ?? false
        case "hcl":
            let pattern = "^\\#[0-9a-f]{6}$"
            return val.range(of: pattern, options: .regularExpression) != nil
        case "ecl":
            let validValues = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
            return validValues.contains(val)
        case "pid":
            let pattern = "^[0-9]{9}$"
            return val.range(of: pattern, options: .regularExpression) != nil
        default:
            return true
        }
    }

}

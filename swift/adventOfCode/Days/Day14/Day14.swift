//
//  Day14.swift
//  adventOfCode
//
//  Created by Céline on 14/12/2020.
//

import Foundation

enum Day14 {
    case step1
    case step2
    
    func run() {
        let rows = Input(inputName: "Day14").contentByLine
        switch self {
        case .step1:
            exercise1(entries: rows)
        case .step2:
            exercise2(entries: rows)
        break
        }
    }
}


extension Day14 {
    
    enum Entry {
        case mask(str: String, byPosition: [Int: Character])
        case memBytes(key: Int, val: Int)
        
        static let numberOfBytes = 36
        static let maskPrefix = "mask = "
        
        
        init?(str: String) {
            let memPrefix = "mem["
            if str.hasPrefix(Entry.maskPrefix) {
                let maskStr = str.suffix(str.count - Entry.maskPrefix.count)
                self = .mask(
                    str: String(maskStr),
                    byPosition: Dictionary.init(
                        uniqueKeysWithValues: maskStr
                        .enumerated()
                        .compactMap({$0.element == "1" || $0.element == "0" ? ($0.offset, $0.element) : nil})
                        )
                )
            } else if str.hasPrefix(memPrefix) {
                let memStrs = str.suffix(str.count - memPrefix.count).components(separatedBy: "] = ")
                guard memStrs.count == 2,
                      let key = Int(memStrs[0]),
                      let val = Int(memStrs[1])
                else {
                    fatalError("Should not happen \(memStrs) \(str)")
                }
                self = .memBytes(key: key, val:val)
            } else {
                return nil
            }
        }
        
        static func getBinary(val: Int) -> String {
            var binaryStr = String(val, radix: 2)
            if binaryStr.count < numberOfBytes {
                binaryStr = String(repeating: "0", count: numberOfBytes - binaryStr.count) + binaryStr
            }
            return binaryStr
        }
    }
    
    func getValueWithMask(mask: [Int: Character], binary: String) -> String {
        var result = binary
        mask.forEach { (index, val) in
            result[index] = val
        }
        return result
    }
    func exercise1(entries: [String]) {
        var maskTmp: String = ""
        var mask: [Int: Character] = [:]
        var valuesInMem: [Int: Int64] = [:]
        
        for i in 0..<entries.count {
            switch Entry(str: entries[i]) {
            case nil:
                fatalError("Should never happen")
            case .mask(_, let newMask):
                mask = newMask
                maskTmp = entries[i]
            case .memBytes(key: let key,val: let value):
                print("--> \(key)")
                print("\(maskTmp) \(value)")
                let strVal = getValueWithMask(mask: mask, binary: Entry.getBinary(val: value))
                guard let value = Int64(strVal, radix: 2) else {
                    fatalError("Should never happen \(#line)")
                }
                valuesInMem[key] = value
            }
        }
        let result = valuesInMem.values.reduce(0) { $0 + $1 }
        print("SUCCESS \(result)")
    }
    
    func getAllMemoriesAdress(mask: String, givenBinaryAddress: String) -> [String]{
        return mask.enumerated().reduce([]) { (acc, item) -> [String] in
            switch item.element {
            case "1":
                return acc.isEmpty ? ["1"] : acc.map{ $0 + "1" }
            case "0":
                let entry = String(givenBinaryAddress[item.offset])
                return acc.isEmpty ? [entry] : acc.map{ $0 + entry }
            case "X":
                return acc.isEmpty ? ["0", "1"] : acc.flatMap{ [$0 + "1", $0 + "0"] }
            default:
                fatalError("Should never happen")
            }
        }
    }
    
    func exercise2(entries: [String]) {
        var valuesInMem: [Int: Int] = [:]
        var mask: String = ""
        for i in 0..<entries.count {
            switch Entry(str: entries[i]) {
            case nil:
                fatalError("Should never happen")
            case .mask(let maskStr, _):
                mask = maskStr
            case .memBytes(let address, let value):
                let binaryAddress = Entry.getBinary(val: address)
                let addressesFromMask: [Int] = getAllMemoriesAdress(mask: mask, givenBinaryAddress: binaryAddress)
                    .compactMap({ Int($0, radix: 2) })
                addressesFromMask.forEach { (key) in
                    valuesInMem[key] = value
                }
            }
        }
        print("Success \(valuesInMem.values.reduce(0, +))")
    }
}

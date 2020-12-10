//
//  Day8.swift
//  adventOfCode
//
//  Created by Céline on 08/12/2020.
//

import Foundation



enum Day8 {
    case step1
    case step2
    
    func run() {
        let entries = Input(inputName: "Day8").contentByLine
        switch self {
        case .step1:
            self.exercise1(entries: entries)
        case .step2:
            self.exercise2(entries: entries)
        }
    }
    
    enum Operation {
        case acc(Int)
        case nop(Int)
        case jmp(Int)
        
        static func fromString(_ str: String) -> Operation {
            let parts = str.split(separator: " ")
            guard let int = Int(parts[1]) else {
                fatalError("unreachable")
            }
            if parts[0] == "nop" { return .nop(int)}
            if parts[0] == "acc" { return .acc(int)}
            if parts[0] == "jmp" { return .jmp(int)}
            fatalError("unreachable")
        }
        
        func browse(index: Int, acc: Int) -> (Int, Int) {
            switch self {
            case let .acc(n):
                return (index + 1, acc + n)
            case let .jmp(n):
                return (index + n, acc)
            case .nop:
                return (index + 1, acc)
            }
        }
        
        func replace() -> Operation? {
            switch self {
            case .acc:
                return nil
            case let .jmp(n):
                return .nop(n)
            case let .nop(n):
                return .jmp(n)
            }
        }
    }
    
    func exercise1(entries: [String]) {
        var browsedIndex: Set<Int> = []
        var index = 0
        var acc = 0
        while !browsedIndex.contains(index) && index < entries.count{
            browsedIndex.insert(index)
            let entry = entries[index]
            print(Operation.fromString(entry))
            let operation = Operation.fromString(entry)
            (index, acc) = operation.browse(index: index, acc: acc)
        }
        print(acc)
    }
    
    func exercise2(entries: [String]) {
        let operations = entries.map({ Operation.fromString($0) })
        
        var (browsedIndices, acc, didFail) = tryBrowsing(operations: operations)
        if (!didFail) {
            print("SUCCESS \(acc)")
            return
        }
        for index in browsedIndices {
            if let replaced = operations[index].replace() {
                var operations2 = operations
                operations2[index] = replaced
                (_, acc, didFail) = tryBrowsing(operations: operations2)
                if !didFail {
                    print("SUCCESS \(acc)")
                    return
                }
            }
        }
        print("FAIL")
        
    }
    
    func tryBrowsing(operations: [Operation]) -> (browsed: Set<Int>, acc: Int, didFail: Bool) {
        var index = 0
        var acc = 0
        var browsedIndex: Set<Int> = []
        while !browsedIndex.contains(index) && index < operations.count {
            browsedIndex.insert(index)
            (index, acc) = operations[index].browse(index: index, acc: acc)
        }
        if index == operations.count {
            return (browsed: [], acc: acc, didFail: false)
        }
        return (browsed: browsedIndex, acc: acc, didFail: true)
    }

}

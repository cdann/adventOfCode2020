//
//  Day1.swift
//  adventOfCode
//
//  Created by Céline on 04/12/2020.
//

import Foundation

enum Day1 {
    case step2
    
    func run() {
        print(multipliedValues(values: Input.array) ?? "none")
    }
    
    func findSummedValue(values: [Int]) -> (Int, Int, Int)? {
        let searchedSum = 2020
        var array = values
        var tuple: (Int, Int, Int)?
        while let v1 = array.popLast() {
            var array2 = array
            while let v2 = array2.popLast() {
                array2.forEach { v3 in
                    if v1 + v2 + v3 == searchedSum {
                        tuple = (v1, v2, v3)
                        return
                    }
                }
            }
            if let _ = tuple {
                break;
            }
        }
        return tuple
    }

    func multipliedValues(values: [Int]) -> Int? {
        if let tuple = findSummedValue(values: values) {
            return tuple.0 * tuple.1 * tuple.2
        }
        return nil
    }
}

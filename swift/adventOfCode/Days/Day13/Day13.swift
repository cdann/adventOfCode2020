//
//  Day13.swift
//  adventOfCode
//
//  Created by Céline on 13/12/2020.
//

import Foundation

enum Day13 {
    case step1
    case step2
    
    func run() {
        let rows = Input(inputName: "Day13").contentByLine
        switch self {
        case .step1:
            exercise1(entries: rows)
        case .step2:
            exercise2(busesIdLine: rows[1])
        }
    }
    
    func parse(entry: String) -> (letter: String, value: Int) {
        let instructChar = String(entry.first!)
        let value = Int(entry.dropFirst())!
        return (instructChar, value)
    }
    
    func exercise1(entries: [String]) {
        let possibleDeparture = Int(entries[0])!
        let busIds = entries[1].components(separatedBy: ",")//.compactMap{ Int($0) }
        let betterId = busIds.reduce(0, { (acc, idEntry) -> Int in
            if let id = Int(idEntry),
               acc == 0 || (id - (possibleDeparture % id)) < (acc - (possibleDeparture % acc)) {
                return id
            }
            return acc
        })
        let result = (betterId - (possibleDeparture % betterId)) * betterId
        print(result)
    }
    
    func waitTimeForBus(id: Double, from: Double) -> Double {
        if (from == 1068781) {
            print("\(id) - \(from) % \(id) = \(from.remainder(dividingBy: id))" )
        }
        return -1 * from.remainder(dividingBy: id)
    }
    
    func waitTimeForBus(id: Int, from: Int) -> Int {
        
        return id - (from % id)
    }
    
    
    func exercise2(busesIdLine: String) {
        let datas: [Double: Double] = Dictionary(uniqueKeysWithValues: busesIdLine.components(separatedBy: ",").enumerated().compactMap({ (item) -> (Double, Double)? in
            if let num = Double(item.element)  {
                return (Double(item.offset), num)
            }
            return nil
        }))
        
        var keys = ArraySlice(datas.keys.sorted())
        var t: Double = keys.first!
        var period: Double = datas[t]!
        keys = keys.dropFirst()
        while !keys.isEmpty {
            t += period
            let searchingKey = keys.first!
            let searchingId = datas[searchingKey]!
            if waitTimeForBus(id: searchingId, from: t + searchingKey) == 0 {
                period = period * searchingId
                keys = keys.dropFirst()
                print("found result with \(datas[searchingKey]!) from \(t) every \(period)")
            }
        }
        print("Success \(t)")
        
    }
    
    
}

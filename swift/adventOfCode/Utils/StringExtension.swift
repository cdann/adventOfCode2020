//
//  StringExtension.swift
//  adventOfCode
//
//  Created by Céline on 07/12/2020.
//

import Foundation

extension String {
    subscript(offset: Int) -> Character {
        get {
            self[index(startIndex, offsetBy: offset)]
        }
        set {
            let charIndex = index(startIndex, offsetBy: offset)
            self.remove(at: charIndex)
            self.insert(newValue, at: charIndex)
        }
        
    }
    
    func getLines() -> [String] {
        self.components(separatedBy: .newlines).compactMap({ $0.isEmpty ? nil : $0.trimmingCharacters(in: .whitespaces)})
    }
}

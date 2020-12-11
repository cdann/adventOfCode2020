//
//  StringExtension.swift
//  adventOfCode
//
//  Created by Céline on 07/12/2020.
//

import Foundation

extension String {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    
    func getLines() -> [String] {
        self.components(separatedBy: .newlines).compactMap({ $0.isEmpty ? nil : $0.trimmingCharacters(in: .whitespaces)})
    }
}

//
//  StringExtension.swift
//  adventOfCode
//
//  Created by Céline on 07/12/2020.
//

import Foundation

extension String {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
}

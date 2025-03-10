//
//  Input.swift
//  adventOfCode
//
//  Created by Céline on 07/12/2020.
//

import Foundation

class Input {
    let content: String
    
    var contentByLine: [String] {
        return content.getLines()
    }
    
    var contentByParagraph: [String] {
        return content.components(separatedBy: "\n\n")
    }
    
    var contentByWord: [String] {
        return content
            .components(separatedBy: .whitespaces)
            .compactMap({ $0.isEmpty ? nil : $0 })
    }
    
    init(inputName: String) {
        let url = URL(fileURLWithPath: "inputsTxt/\(inputName).txt")
        content = try! String(contentsOf: url)
    }
}

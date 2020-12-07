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
        return content.split(separator: "\n")
            .compactMap({ $0.isEmpty ? nil : String($0) })
    }
    
    var contentByParagraph: [String] {
        return content.components(separatedBy: "\n\n")
    }
    
    init(inputName: String) {
        let url = URL(fileURLWithPath: "inputsTxt/\(inputName).txt")
        content = try! String(contentsOf: url)
    }
}

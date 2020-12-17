
import Foundation

class Ferry {
    
    let moveInDirection = [
        "E": CGPoint(x: 1, y: 0),
        "S": CGPoint(x: 0, y: -1),
        "W": CGPoint(x: -1, y: 0),
        "N": CGPoint(x: 0, y: 1)
    ]
    let directions = ["E", "S", "W", "N"]
    
    var coordinate: CGPoint = CGPoint(x: 0, y: 0)
    
    var manhattanDistance: Int {
            return Int(abs(coordinate.x) + abs(coordinate.y))
    }
    
    // part1
    var boatDirectionIndex = 0
    
    func followDirection(instruction: String, value : Int) {
        let moveInstruction = instruction == "F" ? directions[boatDirectionIndex] : instruction
        if let move = moveInDirection[moveInstruction] {
            self.coordinate.y += move.y * CGFloat(value)
            self.coordinate.x += move.x * CGFloat(value)
        }
        if instruction == "L" {
            turnBoat(degrees: 360 - (value % 360))
        }
        if instruction == "R" {
            turnBoat(degrees: (value % 360))
        }
    }
    
    func turnBoat(degrees: Int) {
        let quarter = degrees / 90
        boatDirectionIndex = (boatDirectionIndex + quarter) % directions.count
    }
    
    // part 2
    var wayPoint: CGPoint = CGPoint(x: 10, y: 1)
    
    func turnWayPoint(degrees: Int) {
        let quarter = degrees / 90
        switch quarter {
        case 1:
            wayPoint = CGPoint(x: wayPoint.y, y: -1 * wayPoint.x)
        case 2:
            wayPoint = CGPoint(x: -1 * wayPoint.x, y: -1 * wayPoint.y)
        case 3:
            wayPoint = CGPoint(x: -1 * wayPoint.y, y: wayPoint.x)
        default:
            break
        }
    }
    
    func followWayPoint(instruction: String, value : Int) {
//        let moveInstruction = instruction == "F" ? directions[boatDirectionIndex] : instruction
        if let move = moveInDirection[instruction] {
            wayPoint.y += move.y * CGFloat(value)
            wayPoint.x += move.x * CGFloat(value)
        }
        if instruction == "L" {
            turnWayPoint(degrees: 360 - (value % 360))
        }
        if instruction == "R" {
            turnWayPoint(degrees: (value % 360))
        }
        if instruction == "F" {
            coordinate.x += wayPoint.x * CGFloat(value)
            coordinate.y += wayPoint.y * CGFloat(value)
        }
    }

}

enum Day12 {
    case step1
    case step2
    
    func run() {
        let rows = Input(inputName: "Day12").contentByLine
        switch self {
        case .step1:
            exercise1(entries: rows)
        case .step2:
            exercise2(entries: rows)
        }
    }
    
    func parse(entry: String) -> (letter: String, value: Int) {
        let instructChar = String(entry.first!)
        let value = Int(entry.dropFirst())!
        return (instructChar, value)
    }
    
    func exercise1(entries: [String]) {
        let boat = Ferry()
        entries.forEach { (entry) in
            let instruction = parse(entry: entry)
            boat.followDirection(instruction: instruction.letter, value: instruction.value)
        }
        print(boat.manhattanDistance)
    }
    
    func exercise2(entries: [String]) {
        let boat = Ferry()
        entries.forEach { (entry) in
            let instruction = parse(entry: entry)
            boat.followWayPoint(instruction: instruction.letter, value: instruction.value)
        }
        print(boat.manhattanDistance)
    }
}

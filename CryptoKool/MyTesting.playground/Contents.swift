import UIKit
import Algorithms

struct Student {
    let name: String
    let grade: String
}

var results = [
    Student(name: "Taylor", grade: "A"),
    Student(name: "Sophie", grade: "A"),
    Student(name: "Bella", grade: "B"),
    Student(name: "Rajesh", grade: "C"),
    Student(name: "Tony", grade: "C"),
    Student(name: "Theresa", grade: "D"),
    Student(name: "Boris", grade: "F"),
    Student(name: "Hentai", grade: "C")
]

results = results.sorted { $0.grade < $1.grade }

let studentsByGrade = results.chunked(on: \.grade)

for (grade, students) in studentsByGrade {
    print("Grade \(grade)")
    
    for student in students {
        print("\t\(student.name)")
    }
    
    print()
}

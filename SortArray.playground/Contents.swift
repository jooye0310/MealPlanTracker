import UIKit

struct MealInfo {
    var date: String
    var type: String
    var amount: Double
}

var array = [MealInfo]()

array.append(MealInfo(date: "04/28/2018", type: "Breakfast", amount: 8.99))
array.append(MealInfo(date: "03/10/2018", type: "Lunch", amount: 12.01))
array.append(MealInfo(date: "03/10/2018", type: "Breakfast", amount: 12.01))
array.append(MealInfo(date: "04/01/2018", type: "Dinner", amount: 10.00))

//array.sort {
//    if $0.date != $1.date {
//        $0.date < $1.date
//    } else {
//        var typeA: Int
//        switch $0.type {
//        case "Breakfast":
//            typeA = 0
//        case "Lunch":
//            typeA = 1
//        case "Dinner":
//            typeA = 2
//        default: // Other
//            typeA = 3
//        }
//
//        var typeB: Int
//        switch $1.type {
//        case "Breakfast":
//            typeB = 0
//        case "Lunch":
//            typeB = 1
//        case "Dinner":
//            typeB = 2
//        default: // Other
//            typeB = 3
//        }
//
//        return typeA < typeB
//    }
//}

for meal in array {
    print("Date: \(meal.date), type: \(meal.type), amount: \(meal.amount)")
}

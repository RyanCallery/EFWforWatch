//
//  WeightsInterfaceController.swift
//  EFWforWatch WatchKit Extension
//
//  Created by Ryan Callery on 10/23/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//

import WatchKit
import Foundation

struct ButtonTitle {
    var poundsUnit: String = "lb"
    var gramsUnit: String = "G"
    var grams: Bool = true
    var pounds: Bool = false
    
    var currentUnit: String {
        if grams {
            return gramsUnit
        } else {
            return poundsUnit
        }
    }
}

class WeightsInterfaceController: WKInterfaceController {

    
    @IBOutlet var weeksLabel: WKInterfaceLabel!
    
    @IBOutlet var unitsButton: WKInterfaceButton!
    
    @IBOutlet var tenthWt: WKInterfaceLabel!
    
    @IBOutlet var fiftiethWt: WKInterfaceLabel!
    
    
    @IBOutlet var nintiethWt: WKInterfaceLabel!
    
 
    
    var buttonTitle = ButtonTitle()
    
    var poundsString = [NSAttributedString]()
    var gramsString = [String]()
    
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let weights = context as? [Int: [Int]] {
            var weightArray = [Int]()
            for array in weights.values {
                weightArray = array
            }
            gramsString = weightArray.map { String($0)}
            poundsString = poundsConverterToStringArray(weightArray)
            print("\(gramsString) and \(poundsString) ")
            
            var weeks = String()
            for i in weights.keys {
                weeks = String(i)
            }
            
            weeksLabel.setText("\(weeks)w")
            
            tenthWt.setText(gramsString[1])
            fiftiethWt.setText(gramsString[2])
            nintiethWt.setText(gramsString[4])
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        setButtonTitle()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func convertUnits() {
        
        if buttonTitle.grams {
            //convert to pounds
            buttonTitle.grams = !buttonTitle.grams
            unitsButton.setTitle(buttonTitle.poundsUnit)
            tenthWt.setAttributedText(poundsString[1])
            fiftiethWt.setAttributedText(poundsString[2])
            nintiethWt.setAttributedText(poundsString[4])
            
        } else {
            //convert back to grams
            buttonTitle.grams = !buttonTitle.grams
            unitsButton.setTitle(buttonTitle.gramsUnit)
            tenthWt.setText(gramsString[1])
            fiftiethWt.setText(gramsString[2])
            nintiethWt.setText(gramsString[4])
            
        }
        
        
    }
    
    func setButtonTitle() {
        unitsButton.setTitle(buttonTitle.gramsUnit)
    }
    

}

    // convert all members of array to pounds
    
    func poundsConverterToStringArray(_ weightInGrams: [Int]) -> [NSAttributedString] {
        let weightsInGramsDouble = weightInGrams.map{Double($0)}
        let weightsInPounds = weightsInGramsDouble.map {poundsConverter($0)}
        let weightsInPoundsAsInt = weightsInPounds.map { Int($0)}
        let weightsInPoundsAsIntAsDouble = weightsInPoundsAsInt.map{Double($0)}
        let weightRemainder = remainder(weightsInPounds, weightsInPoundsAsIntAsDouble)
        let ounces = createPoundsToOuncesArray(weightRemainder)
        let finalPoundsString = createPoundsAndOuncesString(weightsInPoundsAsInt, ounces)
        return finalPoundsString
        
        }
    
    
    func poundsConverter(_ weight: Double) -> Double {
        var double = 1.0
        double = weight / 454
        return double
    }

func poundsToOunces( _ weight: Double) -> Double {
    var double = 1.0
    double = weight * 16
    return double
}

func remainder(_ first : [Double], _ second : [Double] ) -> [Double] {
    var remainderArray = Array<Double>()
    for index in 0..<first.count {
        let remainder = first[index] - second[index]
        remainderArray.append(remainder)
        
    }
    
    return remainderArray
}

func createPoundsToOuncesArray(_ weightRemainder: [Double]) -> [Int] {
    var ouncesArray = Array<Int>()
    for item in weightRemainder {
        let ounce = Int(poundsToOunces(item).rounded())
        ouncesArray.append(ounce)
    }
    return ouncesArray
}

func createPoundsAndOuncesString(_ int1: [Int], _ int2: [Int]) -> [NSAttributedString] {
    var stringArray = [NSMutableAttributedString]()
    
    for index in 0..<int1.count {
        let combination = NSMutableAttributedString()
        let font1 = UIFont.systemFont(ofSize: 12)
        let font2 = UIFont.systemFont(ofSize: 16)
        let lbString = NSMutableAttributedString(string: "lb", attributes: [NSAttributedString.Key.font: font1])
        let ozString = NSMutableAttributedString(string: "oz", attributes: [NSAttributedString.Key.font : font1])
        let lbInt = NSMutableAttributedString(string: String(int1[index]), attributes: [NSAttributedString.Key.font : font2])
        let ozInt = NSMutableAttributedString(string: String(int2[index]), attributes: [NSAttributedString.Key.font : font2])
        combination.append(lbInt)
        combination.append(lbString)
        combination.append(ozInt)
        combination.append(ozString)
        print("This is the \(combination) ")
        stringArray.append(combination)
      
        
    }
    return stringArray
    
}


//
//  InterfaceController.swift
//  EFWforWatch WatchKit Extension
//
//  Created by Ryan Callery on 10/23/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

   
    @IBOutlet var weekTable: WKInterfaceTable!
    
    var weeksArray = [Int]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        weeksArray = Array(gestationalWeight.keys)
        weeksArray.sort()
        
        weekTable.setNumberOfRows(weeksArray.count, withRowType: "Row")
        
        for i in 0 ..< weeksArray.count {
            let rowController = weekTable.rowController(at: i)  as? WeekSelectRow
            let weekString = String(weeksArray[i])
            rowController?.weeksLabel.setText(weekString)
        }
    
        
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        let weeks = weeksArray[rowIndex]
        return [weeks : gestationalWeight[weeks] ]
        
    }

    
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

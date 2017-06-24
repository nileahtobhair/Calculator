//
//  ViewController.swift
//  Calculator
//
//  Created by Niamh Lawlor on 28/03/2015.
//  Copyright (c) 2015 Niamh Lawlor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    var brain = CalcuatorModel()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping{
            display.text = display.text! + digit
        } else{
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        _ = sender.currentTitle!
        if (userIsInTheMiddleOfTyping){
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
        
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTyping = false
     //   println("operand stack = \(operandStack)")
        if let result =  brain.pushOperand(displayValue){
            displayValue = result
        } else{
            displayValue = 0
        }
    }
    
    var displayValue : Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTyping = false
        }
    }
}


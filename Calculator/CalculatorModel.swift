//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Niamh Lawlor on 07/04/2015.
//  Copyright (c) 2015 Niamh Lawlor. All rights reserved.
//

import Foundation

class CalcuatorModel {
    
    
    private enum Op: CustomStringConvertible // Protocol 
    {
        case Operand(Double) //associating data with case
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) ->Double)
        var description : String{
            get {
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
            
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]() //dictionary containing operations
    
    init(){
        knownOps["x"] = Op.BinaryOperation("x"){ $0 * $1 }
        knownOps["/"] = Op.BinaryOperation("/"){ $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+"){ $0 + $1 }
        knownOps["-"] = Op.BinaryOperation("-"){ $0 - $1 }
        knownOps["√"] = Op.UnaryOperation("√"){ sqrt($0) }
    }
    
    var program: AnyObject{ //guaranteed to be a Poroperty List
        get{
            return opStack.map { $0.description }
        }
        set{
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol]{
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue{
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    private func evaluate(ops: [Op]) -> (result:Double?,remainingOps:[Op]){
        if !ops.isEmpty {
            var remainingOps = ops // mutable
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand,remainingOps)
            case .UnaryOperation(_,let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                return (operation(operand), operandEvaluation.remainingOps)
            }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return(nil,ops)
    }
  
    func evaluate() -> Double? {
        let (result,remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over ")
        return result
    }
    
    
    func pushOperand(operand : Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
   
}

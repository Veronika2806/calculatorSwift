import Foundation


struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> =
        [
            "π" : Operation.constant(Double.pi),
            "e" : Operation.constant(M_E),
            "√" : Operation.unaryOperation(sqrt),
            "cos" : Operation.unaryOperation(cos),
            "∓" : Operation.unaryOperation({ -$0 }),
            "×" : Operation.binaryOperation({ $0 * $1 }),
            "÷" : Operation.binaryOperation({ $0 / $1 }),
            "-" : Operation.binaryOperation({ $0 - $1 }),
            "+" : Operation.binaryOperation({ $0 + $1 }),
            "=" : Operation.equals
        ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                break
            case .unaryOperation(let unaryMethod):
                if accumulator != nil {
                    accumulator = unaryMethod(accumulator!)
                }
            case .binaryOperation(let binaryMethod):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: binaryMethod, firstOperand: accumulator!)
                    accumulator = nil
                }
                break
            case .equals:
                performPendingBinaryOperation()
                break
            }
        }
    }
    
  
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation?.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}

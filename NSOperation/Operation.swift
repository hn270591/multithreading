import Foundation

/// Custom wrapper of NSOperation
///
class Operation: Foundation.Operation {
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }

    override func start() {
        _executing = true
        execute()
    }
    
    func execute() {
        fatalError("You must override this")
    }
    
    func finish() {
        _executing = false
        _finished = true
    }
}

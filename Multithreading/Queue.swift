//
//  Queue.swift
//  GCD
//

import Foundation

protocol ExecutableQueue {
    var queue: DispatchQueue { get }
}

extension ExecutableQueue {
    func execute(_ closure: @escaping () -> Void) {
        queue.async {
            closure()
        }
    }
}

enum Queue {
    case main
    case userInteractive
    case userInitiated
    case utility
    case background
}

extension Queue: ExecutableQueue {
    var queue: DispatchQueue {
        switch self {
        case .main:
            return DispatchQueue.main
        case .userInteractive:
            return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:
            return DispatchQueue.global(qos: .userInitiated)
        case .utility:
            return DispatchQueue.global(qos: .utility)
        case .background:
            return DispatchQueue.global(qos: .background)
        }
    }
}

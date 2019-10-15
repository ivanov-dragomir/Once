//
//  Once.swift
//  Name Day
//
//  Created by Dragomir Ivanov on 13.10.19.
//  Copyright © 2019 Name Day. All rights reserved.
//

import Foundation
import QuartzCore

public final class Once {
    public enum Per {
        case app
        case launch
        case interval(TimeInterval)
        case persistentInterval(TimeInterval)
        
        fileprivate static var perLaunchHistory = Set<Token>()
        fileprivate static var timeHistory = [Token: CFTimeInterval]()
    }
    
    public struct Token : Hashable, Equatable, RawRepresentable {
        public let rawValue: String
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    /// Perform operation once. Identified by a token.
    /// - Parameter token: Identification token of the operation.
    /// - Parameter closure: The operation itself.
    /// - Returns: `true` if the operation has been executed, otherwise `false`
    @discardableResult
    public static func perform(_ token: Token, operation: () -> Void) -> Bool {
        return perform(token, per: .launch, operation: operation)
    }
    
    /// Perform operation once. Identified by a token. Control how long the token should be persisted.
    /// - Parameter token: Identification token of the operation.
    /// - Parameter per: Control over execution frequency.
    /// - Parameter closure: The operation itself.
    /// - Returns: `true` if the operation has been executed, otherwise `false`
    @discardableResult
    public static func perform(_ token: Token, per: Per, operation: () -> Void) -> Bool {
        switch per {
        case .app:
            guard UserDefaults.standard.bool(forKey: token.rawValue) == false else { return false }
            UserDefaults.standard.set(true, forKey: token.rawValue)
            operation()
            
        case .launch:
            guard Per.perLaunchHistory.contains(token) == false else { return false }
            Per.perLaunchHistory.insert(token)
            operation()
            
        case .interval(let interval):
            let now = CACurrentMediaTime()
            let next = now + interval
            let extendedToken = Token(rawValue: "\(token.rawValue) every \(interval)\(interval == 1 ? "second" : "seconds")")
            if let until = Per.timeHistory[extendedToken] {
                guard until < now else { return false }
                Per.timeHistory[extendedToken] = next
                operation()
            } else {
                Per.timeHistory[extendedToken] = next
                operation()
            }
            
        case .persistentInterval(let interval):
            let now = CACurrentMediaTime()
            let next = now + interval
            let extendedToken = Token(rawValue: "\(token.rawValue) every \(interval)\(interval == 1 ? "second" : "seconds")")
            guard UserDefaults.standard.double(forKey: extendedToken.rawValue) < now else { return false }
            UserDefaults.standard.set(next, forKey: extendedToken.rawValue)
            operation()
        }
        
        return true
    }
}

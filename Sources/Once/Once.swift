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
    
    public static func perform(_ token: Token, closure: () -> Void) {
        perform(token, per: .launch, closure: closure)
    }
    
    public static func perform(_ token: Token, per: Per, closure: () -> Void) {
        switch per {
        case .app:
            guard UserDefaults.standard.bool(forKey: token.rawValue) == false else { return }
            UserDefaults.standard.set(true, forKey: token.rawValue)
            closure()
            
        case .launch:
            guard Per.perLaunchHistory.contains(token) == false else { return }
            Per.perLaunchHistory.insert(token)
            closure()
            
        case .interval(let interval):
            let now = CACurrentMediaTime()
            let next = now + interval
            let extendedToken = Token(rawValue: "\(token.rawValue) every \(interval)\(interval == 1 ? "second" : "seconds")")
            if let until = Per.timeHistory[extendedToken] {
                guard until < now else { return }
                Per.timeHistory[extendedToken] = next
                closure()
            } else {
                Per.timeHistory[extendedToken] = next
                closure()
            }
            
        case .persistentInterval(let interval):
            let now = CACurrentMediaTime()
            let next = now + interval
            let extendedToken = Token(rawValue: "\(token.rawValue) every \(interval)\(interval == 1 ? "second" : "seconds")")
            guard UserDefaults.standard.double(forKey: extendedToken.rawValue) < now else { return }
            UserDefaults.standard.set(next, forKey: extendedToken.rawValue)
            closure()
        }
    }
}

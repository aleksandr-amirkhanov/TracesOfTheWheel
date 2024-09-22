//
//  Hypotrochoid.swift
//  GenerativeArt00
//
//  Created by Aleksandr Amirkhanov on 09.06.2024.
//

import Foundation

// https://en.wikipedia.org/wiki/Hypotrochoid
class Hypotrochoid 	{
    
    public let r_fixed: Int
    public let r_rolling: Int
    public let d: Int
    public let theta_max: Float
    
    // Divide the input value by two until it becomes odd
    fileprivate static func toOdd(_ a: inout Int) {
        while a % 2 == 0 {
            a /= 2
        }
    }
    
    // Binary GCD algorithm
    // https://en.wikipedia.org/wiki/Greatest_common_divisor#Binary_GCD_algorithm
    static fileprivate func GCD(x: Int, y: Int) -> Int {
        var a = x
        var b = y
        var d = 0
        
        while a % 2 == 0 && b % 2 == 0 {
            a /= 2
            b /= 2
            d += 1
        }
        
        toOdd(&a)
        toOdd(&b)
        
        while a != b {
            if a > b {
                a = a - b
                toOdd(&a)
            }
            else {
                b = b - a
                toOdd(&b)
            }
        }
        
        return NSDecimalNumber(decimal: pow(Decimal(2), d)).intValue * a
    }
    
    static fileprivate func LCM(x: Int, y: Int) -> Int {
        return abs(x * y) / GCD(x: x, y: y)
    }
    
    init(r_fixed: Int, r_rolling: Int, d: Int) {
        self.r_fixed = r_fixed
        self.r_rolling = r_rolling
        self.d = d
        self.theta_max = 2 * Float.pi * Float(Hypotrochoid.LCM(x: r_rolling, y: r_fixed)) / Float(r_fixed)
    }
    
    func point(theta: Float) -> (Float, Float) {
        let a = Float(r_fixed - r_rolling)
        let b = Float(r_fixed - r_rolling) / Float(r_rolling) * theta
        
        let x = a * cos(theta) + Float(d) * cos(b)
        let y = a * sin(theta) - Float(d) * sin(b)
        
        return (x, y)
    }
}

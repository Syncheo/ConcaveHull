//
//  Format.swift
//  Hull
//
//  Created by Sany Maamari on 09/03/2017.
//  Copyright © 2017 AppProviders. All rights reserved.
//  (c) 2014-2016, Andrii Heonia
//  Hull.js, a JavaScript library for concave hull generation by set of points.
//  https://github.com/AndriiHeonia/hull
//

import Foundation

class Format {

    func toXy(_ pointSet: [Any], _ format: [String]?) -> [[Double]] {
        if format == nil {
            return (pointSet as? [[Any]])!.map {
                (pt: [Any]) -> [Double] in
                if pt[0] is Int {
                    return [Double((pt[0] as? Int)!), Double((pt[1] as? Int)!)]
                }
                if pt[0] is Double {
                    return [(pt[0] as? Double)!, (pt[1] as? Double)!]
                }
                return [Double]()
            }
        }
        if pointSet is [[String: Int]] {
            return (pointSet as? [[String: Int]])!.map {
                (pt: [String: Int]) -> [Double] in
                return [Double(pt[format![0]]!), Double(pt[format![1]]!)]
            }
        }
        if pointSet is [[String: Double]] {
            return (pointSet as? [[String: Double]])!.map {
                (pt: [String: Double]) -> [Double] in
                return [pt[format![0]]!, pt[format![1]]!]
            }
        }
        return [[Double]] ()
    }

    func fromXy(_ pointSet: [Any], _ format: [String]?) -> [Any] {
        if format == nil {
            return pointSet
        } else {
            if pointSet is[[Int]] {
                return (pointSet as? [[Int]])!.map {
                    (pt: [Int]) -> [String: Int] in
                    var o: [String: Int] = [String: Int]()
                    o[format![0]] = pt[0]
                    o[format![1]] = pt[1]
                    return o
                }
            }
            if pointSet is [[Double]] {
                return (pointSet as? [[Double]])!.map {
                    (pt: [Double]) -> [String: Double] in
                    var o: [String: Double] = [String: Double]()
                    o[format![0]] = pt[0]
                    o[format![1]] = pt[1]
                    return o
                }
            }
            return [Any]()
        }
    }

}

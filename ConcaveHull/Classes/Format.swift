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

    func toXy(_ pointSet: [Any], _ format: [String]?) -> [Point] {
        if format == nil {
            return (pointSet as? [[Any]])!.map { (point: [Any]) -> Point in
                if point[0] is Int {
                    return Point(xxx: Double((point[0] as? Int)!), yyy: Double((point[1] as? Int)!))
                }
                if point[0] is Double {
                    return Point(xxx: (point[0] as? Double)!, yyy: (point[1] as? Double)!)
                }
                return Point(xxx: 0, yyy: 0)
            }
        }
        if pointSet is [[String: Int]] {
            return (pointSet as? [[String: Int]])!.map { (point: [String: Int]) -> Point in
                return Point(xxx: Double(point[format![0]]!), yyy: Double(point[format![1]]!))
            }
        }
        if pointSet is [[String: Double]] {
            return (pointSet as? [[String: Double]])!.map { (point: [String: Double]) -> Point in
                return Point(xxx: point[format![0]]!, yyy: point[format![1]]!)
            }
        }
        return [Point]()
    }

    func fromXy(_ pointSet: [Point], _ format: [String]?) -> [Any] {
        if let format = format {
            return pointSet.map { (point: Point) -> [String: Double] in
                var origin: [String: Double] = [String: Double]()
                origin[format[0]] = point.xxx
                origin[format[1]] = point.yyy
                return origin
            }
        } else {
            return pointSet.map { (point: Point) -> [Double] in
                return [point.xxx, point.yyy]
            }
        }
    }

}

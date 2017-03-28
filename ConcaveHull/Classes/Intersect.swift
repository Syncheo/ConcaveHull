//
//  Intersect.swift
//  Hull
//
//  Created by Sany Maamari on 09/03/2017.
//  Copyright © 2017 AppProviders. All rights reserved.
//  (c) 2014-2016, Andrii Heonia
//  Hull.js, a JavaScript library for concave hull generation by set of points.
//  https://github.com/AndriiHeonia/hull
//

import Foundation

class Intersect {
    var isIntersect: Bool = false

    init(_ seg1: [[Double]], _ seg2: [[Double]]) {
        let x1 = seg1[0][0]
        let x2 = seg1[1][0]
        let x3 = seg2[0][0]
        let x4 = seg2[1][0]
        let y1 = seg1[0][1]
        let y2 = seg1[1][1]
        let y3 = seg2[0][1]
        let y4 = seg2[1][1]
        isIntersect = ccw(x1, y1, x3, y3, x4, y4) != ccw(x2, y2, x3, y3, x4, y4) && ccw(x1, y1, x2, y2, x3, y3) != ccw(x1, y1, x2, y2, x4, y4)
    }

    private func ccw(_ x1: Double, _ y1: Double,
             _ x2: Double, _ y2: Double,
             _ x3: Double, _ y3: Double) -> Bool {
        let cw = ((y3 - y1) * (x2 - x1)) - ((y2 - y1) * (x3 - x1))
        return cw > 0 ? true : cw < 0 ? false : true
    }


}

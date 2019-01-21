//
//  Convex.swift
//  Hull
//
//  Created by Sany Maamari on 09/03/2017.
//  Copyright © 2017 AppProviders. All rights reserved.
//  (c) 2014-2016, Andrii Heonia
//  Hull.js, a JavaScript library for concave hull generation by set of points.
//  https://github.com/AndriiHeonia/hull
//

import Foundation

class Convex {
    var convex: [Point] = [Point]()

    init(_ pointSet: [Point]) {
        let upper = upperTangent(pointSet)
        let lower = lowerTangent(pointSet)
        convex = lower + upper
        convex.append(convex[0])
    }

    private func cross(_ ooo: Point, _ aaa: Point, _ bbb: Point) -> Double {
        return (aaa.xxx - ooo.xxx) * (bbb.yyy - ooo.yyy) - (aaa.yyy - ooo.yyy) * (bbb.xxx - ooo.xxx)
    }

    private func upperTangent(_ pointSet: [Point]) -> [Point] {
        var lower = [Point]()
        for point in pointSet {
            while lower.count >= 2 && (cross(lower[lower.count - 2], lower[lower.count - 1], point) <= 0) {
                _ = lower.popLast()
            }
            lower.append(point)
        }
        _ = lower.popLast()
        return lower
    }

    private func lowerTangent(_ pointSet: [Point]) -> [Point] {
        let reversed = pointSet.reversed()
        var upper = [Point]()
        for point in reversed {
            while upper.count >= 2 && (cross(upper[upper.count - 2], upper[upper.count - 1], point) <= 0) {
                _ = upper.popLast()
            }
            upper.append(point)
        }
        _ = upper.popLast()
        return upper
    }

}

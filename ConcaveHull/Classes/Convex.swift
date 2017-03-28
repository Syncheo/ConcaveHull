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
    var convex: [[Double]] = [[Double]]()

    init(_ pointSet: [[Double]]) {
        let upper = upperTangent(pointSet)
        let lower = lowerTangent(pointSet)
        convex = lower + upper
        convex.append(convex[0])
    }

    private func cross(_ o: [Double], _ a: [Double], _ b: [Double]) -> Double {
        return (a[0] - o[0]) * (b[1] - o[1]) - (a[1] - o[1]) * (b[0] - o[0])
    }

    private func upperTangent(_ pointSet: [[Double]]) -> [[Double]] {
        var lower = [[Double]]()
        for p in pointSet {
            while lower.count >= 2 && (cross(lower[lower.count - 2], lower[lower.count - 1], p) <= 0) {
                _ = lower.popLast()
            }
            lower.append(p)
        }
        _ = lower.popLast()
        return lower
    }

    private func lowerTangent(_ pointSet: [[Double]]) -> [[Double]] {
        let reversed = pointSet.reversed()
        var upper = [[Double]]()
        for p in reversed {
            while upper.count >= 2 && (cross(upper[upper.count - 2], upper[upper.count - 1], p) <= 0) {
                _ = upper.popLast()
            }
            upper.append(p)
        }
        _ = upper.popLast()
        return upper
    }

}

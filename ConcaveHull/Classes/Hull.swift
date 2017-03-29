//
//  Hull.swift
//  Hull
//
//  Created by Sany Maamari on 09/03/2017.
//  Copyright © 2017 AppProviders. All rights reserved.
//  (c) 2014-2016, Andrii Heonia
//  Hull.js, a JavaScript library for concave hull generation by set of points.
//  https://github.com/AndriiHeonia/hull
//

import Foundation

public class Hull {
    public let MaxConcaveAngleCos = cos(90 / (180 / Double.pi)) // angle = 90 deg
    public let MaxSearchBboxSizePercent = 0.6

    public init() {
    }

    public func hull(_ pointSet: [Any], _ concavity: Double?, _ format: [String]?) -> [Any] {
        var convex: [[Double]]
        var concave: [[Double]]
        var innerPoints: [[Double]]
        var occupiedArea: [Double]
        var maxSearchArea: [Double]
        var cellSize: Double
        var points: [[Double]]
        let maxEdgeLen: Double = concavity ?? 20
        var skipList: [String: Bool] = [String: Bool]()

        if pointSet.count < 4 {
            return pointSet
        }
        points = filterDuplicates(sortByX(Format().toXy(pointSet, format)))
        occupiedArea = occupiedAreaFunc(points)
        maxSearchArea = [occupiedArea[0] * MaxSearchBboxSizePercent,
                         occupiedArea[1] * MaxSearchBboxSizePercent]

        convex = Convex(points).convex

        innerPoints = points.filter {
            (p: [Double]) -> Bool in
            let idx = convex.index(where: {
                (i: [Double]) -> Bool in
                return i[0] == p[0] && i[1] == p[1]
            })
            return idx == nil
        }

        innerPoints.sort(by: {
            (a: [Double], b: [Double]) -> Bool in
            if a[0] != b[0] {
                return a[0] > b[0]
            } else {
                return a[1] > b[1]
            }
        })

        cellSize = ceil(occupiedArea[0] * occupiedArea[1] / Double(points.count))

        let g = Grid(innerPoints, cellSize)

        concave = concaveFunc(&convex, pow(maxEdgeLen, 2), maxSearchArea, g, &skipList)

        return Format().fromXy(concave, format)
    }

    func filterDuplicates(_ pointSet: [[Double]]) -> [[Double]] {
        return pointSet.filter {
            (p: [Double]) -> Bool  in
            let index = pointSet.index(where: {
                (i: [Double]) -> Bool in
                return i == p
            })
            if index == 0 {
                return true
            } else {
                let prevEl = pointSet[index! - 1]
                if prevEl[0] != p[0] || prevEl[1] != p[1] {
                    return true
                }
                return false
            }
        }
    }

    func sortByX(_ pointSet: [[Double]]) -> [[Double]] {
        return pointSet.sorted(by: {
            (a, b) -> Bool in
            if a[0] == b[0] {
                return a[1] - b[1] < 0
            } else {
                return a[0] - b[0] < 0
            }
        })
    }

    func sqLength(_ a: [Double], _ b: [Double]) -> Double {
        return pow(b[0] - a[0], 2) + pow(b[1] - a[1], 2)
    }

    func cosFunc(_ o: [Double], _ a: [Double], _ b: [Double]) -> Double {
        let aShifted = [a[0] - o[0], a[1] - o[1]]
        let bShifted = [b[0] - o[0], b[1] - o[1]]
        let sqALen = sqLength(o, a)
        let sqBLen = sqLength(o, b)
        let dot = aShifted[0] * bShifted[0] + aShifted[1] * bShifted[1]
        return dot / sqrt(sqALen * sqBLen)
    }

    func intersectFunc(_ segment: [[Double]], _ pointSet: [[Double]]) -> Bool {
        for i in 0..<pointSet.count - 1 {
            let seg = [pointSet[i], pointSet[i + 1]]
            if segment[0][0] == seg[0][0] && segment[0][1] == seg[0][1] ||
                segment[0][0] == seg[1][0] && segment[0][1] == seg[1][1] {
                    continue
            }
            if Intersect(segment, seg).isIntersect {
                return true
            }
        }
        return false
    }

    func occupiedAreaFunc(_ pointSet: [[Double]]) -> [Double] {
        var minX = Double.infinity
        var minY = Double.infinity
        var maxX = -Double.infinity
        var maxY = -Double.infinity
        for i in 0..<pointSet.reversed().count {
            if pointSet[i][0] < minX {
                minX = pointSet[i][0]
            }
            if pointSet[i][1] < minY {
                minY = pointSet[i][1]
            }
            if pointSet[i][0] > maxX {
                maxX = pointSet[i][0]
            }
            if pointSet[i][1] > maxY {
                maxY = pointSet[i][1]
            }
        }
        return [maxX - minX, maxY - minY]
    }

    func bBoxAroundFunc(_ edge: [[Double]]) -> [Double] {
        return [min(edge[0][0], edge[1][0]),
                min(edge[0][1], edge[1][1]),
                max(edge[0][0], edge[1][0]),
                max(edge[0][1], edge[1][1])]
    }

    func midPointFunc(_ edge: [[Double]], _ innerPoints: [[Double]], _ convex: [[Double]]) -> [Double]? {
        var points: [Double]? = nil
        var angle1Cos = MaxConcaveAngleCos
        var angle2Cos = MaxConcaveAngleCos
        var a1Cos: Double = 0
        var a2Cos: Double = 0
        for innerPoint in innerPoints {
            a1Cos = cosFunc(edge[0], edge[1], innerPoint)
            a2Cos = cosFunc(edge[1], edge[0], innerPoint)
            if a1Cos > angle1Cos &&
                a2Cos > angle2Cos &&
                !intersectFunc([edge[0], innerPoint], convex) &&
                !intersectFunc([edge[1], innerPoint], convex) {
                angle1Cos = a1Cos
                angle2Cos = a2Cos
                points = innerPoint
            }
        }
        return points
    }

    func concaveFunc( _ convex: inout [[Double]], _ maxSqEdgeLen: Double, _ maxSearchArea: [Double], _ grid: Grid, _ edgeSkipList: inout [String: Bool]) -> [[Double]] {

        var edge: [[Double]]
        var keyInSkipList: String = ""
        var scaleFactor: Double
        var midPoint: [Double]?
        var bBoxAround: [Double]
        var bBoxWidth: Double = 0
        var bBoxHeight: Double = 0
        var midPointInserted: Bool = false

        for i in 0..<convex.count - 1 {
            edge = [convex[i], convex[i+1]]
            keyInSkipList = edge[0].description.appending(", ").appending(edge[1].description)

            scaleFactor = 0
            bBoxAround = bBoxAroundFunc(edge)

            if sqLength(edge[0], edge[1]) < maxSqEdgeLen || edgeSkipList[keyInSkipList] == true {
                continue
            }

            repeat {
                bBoxAround = grid.extendBbox(bBoxAround, scaleFactor)
                bBoxWidth = bBoxAround[2] - bBoxAround[0]
                bBoxHeight = bBoxAround[3] - bBoxAround[1]
                midPoint = midPointFunc(edge, grid.rangePoints(bBoxAround), convex)
                scaleFactor = scaleFactor + 1
            } while midPoint == nil && (maxSearchArea[0] > bBoxWidth || maxSearchArea[1] > bBoxHeight)

            if bBoxWidth >= maxSearchArea[0] && bBoxHeight >= maxSearchArea[1] {
                edgeSkipList[keyInSkipList] = true
            }
            if midPoint != nil {
                convex.insert(midPoint!, at: i + 1)
                grid.removePoint(midPoint!)
                midPointInserted = true
            }
        }

        if midPointInserted {
            return concaveFunc(&convex, maxSqEdgeLen, maxSearchArea, grid, &edgeSkipList)
        }

        return convex
    }

}

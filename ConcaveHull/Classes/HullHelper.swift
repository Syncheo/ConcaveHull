//
//  HullHelper.swift
//  Pods
//
//  Created by Sany Maamari on 04/04/2017.
//
//

import Foundation

struct Point {
    let xxx: Double
    let yyy: Double
    func description() -> String {
        return xxx.description + "," + yyy.description
    }
}

class HullHelper {
    let maxConcaveAngleCos = cos(90 / (180 / Double.pi)) // angle = 90 deg
    let maxSearchBboxSizePercent = 0.6

    func getHull(_ pointSet: [Any], concavity: Double, format: [String]?) -> [Any] {
        var convex: [Point]
        var innerPoints: [Point]
        var occupiedArea: Point
        var maxSearchArea: [Double]
        var cellSize: Double
        var points: [Point]
        var skipList: [String: Bool] = [String: Bool]()

        points = filterDuplicates(Format().toXy(pointSet, format))
        occupiedArea = occupiedAreaFunc(points)
        maxSearchArea = [occupiedArea.xxx * maxSearchBboxSizePercent,
                         occupiedArea.yyy * maxSearchBboxSizePercent]

        convex = Convex(points).convex

        innerPoints = points.filter { (point: Point) -> Bool in
            let idx = convex.index(where: { (idx: Point) -> Bool in
                return idx.xxx == point.xxx && idx.yyy == point.yyy
            })
            return idx == nil
        }

        innerPoints.sort(by: { (aaa: Point, bbb: Point) -> Bool in
            if aaa.xxx == bbb.xxx {
                return aaa.yyy > bbb.yyy
            } else {
                return aaa.xxx > bbb.xxx
            }
        })

        cellSize = ceil(occupiedArea.xxx * occupiedArea.yyy / Double(points.count))

        let grid = Grid(innerPoints, cellSize)

        let concave: [Point] = concaveFunc(&convex, pow(concavity, 2), maxSearchArea, grid, &skipList)

        return Format().fromXy(concave, format)
    }

    func filterDuplicates(_ pointSet: [Point]) -> [Point] {
        let sortedSet = sortByX(pointSet)
        return sortedSet.filter { (point: Point) -> Bool in
            let index = pointSet.index(where: {(idx: Point) -> Bool in
                return idx.xxx == point.xxx && idx.yyy == point.yyy
            })
            if index == 0 {
                return true
            } else {
                let prevEl = pointSet[index! - 1]
                if prevEl.xxx != point.xxx || prevEl.yyy != point.yyy {
                    return true
                }
                return false
            }
        }
    }

    func sortByX(_ pointSet: [Point]) -> [Point] {
        return pointSet.sorted(by: { (aaa, bbb) -> Bool in
            if aaa.xxx == bbb.xxx {
                return aaa.yyy < bbb.yyy
            } else {
                return aaa.xxx < bbb.xxx
            }
        })
    }

    func sqLength(_ aaa: Point, _ bbb: Point) -> Double {
        return pow(bbb.xxx - aaa.xxx, 2) + pow(bbb.yyy - aaa.yyy, 2)
    }

    func cosFunc(_ ooo: Point, _ aaa: Point, _ bbb: Point) -> Double {
        let aShifted = [aaa.xxx - ooo.xxx, aaa.yyy - ooo.yyy]
        let bShifted = [bbb.xxx - ooo.xxx, bbb.yyy - ooo.yyy]
        let sqALen = sqLength(ooo, aaa)
        let sqBLen = sqLength(ooo, bbb)
        let dot = aShifted[0] * bShifted[0] + aShifted[1] * bShifted[1]
        return dot / sqrt(sqALen * sqBLen)
    }

    func intersectFunc(_ segment: [Point], _ pointSet: [Point]) -> Bool {
        for idx in 0..<pointSet.count - 1 {
            let seg = [pointSet[idx], pointSet[idx + 1]]
            if segment[0].xxx == seg[0].xxx && segment[0].yyy == seg[0].yyy ||
                segment[0].xxx == seg[1].xxx && segment[0].yyy == seg[1].yyy {
                continue
            }
            if Intersect(segment, seg).isIntersect {
                return true
            }
        }
        return false
    }

    func occupiedAreaFunc(_ pointSet: [Point]) -> Point {
        var minX = Double.infinity
        var minY = Double.infinity
        var maxX = -Double.infinity
        var maxY = -Double.infinity
        for idx in 0..<pointSet.reversed().count {
            if pointSet[idx].xxx < minX {
                minX = pointSet[idx].xxx
            }
            if pointSet[idx].yyy < minY {
                minY = pointSet[idx].yyy
            }
            if pointSet[idx].xxx > maxX {
                maxX = pointSet[idx].xxx
            }
            if pointSet[idx].yyy > maxY {
                maxY = pointSet[idx].yyy
            }
        }
        return Point(xxx: maxX - minX, yyy: maxY - minY)
    }

    func bBoxAroundFunc(_ edge: [Point]) -> [Double] {
        return [min(edge[0].xxx, edge[1].xxx),
                min(edge[0].yyy, edge[1].yyy),
                max(edge[0].xxx, edge[1].xxx),
                max(edge[0].yyy, edge[1].yyy)]
    }

    func midPointFunc(_ edge: [Point], _ innerPoints: [Point], _ convex: [Point]) -> Point? {
        var point: Point?
        var angle1Cos = maxConcaveAngleCos
        var angle2Cos = maxConcaveAngleCos
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
                point = innerPoint
            }
        }
        return point
    }

    func concaveFunc(_ convex: inout [Point], _ maxSqEdgeLen: Double, _ maxSearchArea: [Double],
                     _ grid: Grid, _ edgeSkipList: inout [String: Bool]) -> [Point] {

        var edge: [Point]
        var keyInSkipList: String = ""
        var scaleFactor: Double
        var midPoint: Point?
        var bBoxAround: [Double]
        var bBoxWidth: Double = 0
        var bBoxHeight: Double = 0
        var midPointInserted: Bool = false

        for idx in 0..<convex.count - 1 {
            edge = [convex[idx], convex[idx+1]]
            keyInSkipList = edge[0].description().appending(", ").appending(edge[1].description())

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
                scaleFactor += 1
            } while midPoint == nil && (maxSearchArea[0] > bBoxWidth || maxSearchArea[1] > bBoxHeight)

            if bBoxWidth >= maxSearchArea[0] && bBoxHeight >= maxSearchArea[1] {
                edgeSkipList[keyInSkipList] = true
            }
            if let midPoint = midPoint {
                convex.insert(midPoint, at: idx + 1)
                grid.removePoint(midPoint)
                midPointInserted = true
            }
        }

        if midPointInserted {
            return concaveFunc(&convex, maxSqEdgeLen, maxSearchArea, grid, &edgeSkipList)
        }

        return convex
    }

}

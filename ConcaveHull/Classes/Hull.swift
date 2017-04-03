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
import MapKit

/**
 Only public class of this pod, Use it to call the hull function Hull().hull(_, _, _)
 */
public class Hull {
    let MaxConcaveAngleCos = cos(90 / (180 / Double.pi)) // angle = 90 deg
    let MaxSearchBboxSizePercent = 0.6

    /**
     A public polygon created with the getPolygon Functions
     */
    public var polygon: MKPolygon = MKPolygon()

    /**
     The hull created with the hull functions
     */
    public var hull: [Any] = [Any]()

    var format: [String]?

    /**
     The concavity paramater for the hull function, 20 is the default
    */
    public var concavity: Double = 20

    /**
     Init function
     */
    public init() {
    }

    /**
     Init function and set the concavity, if nil, the concavity will be equal to 20
     */
    public init(concavity: Double?) {
        if concavity != nil {
            self.concavity = concavity!
        }
    }

    /**
     This main function allows to create the hull of a set of point by defining the desired concavity of the return hull.

     - parameter pointSet: The list of point, can be of type [Int], [Double], [[String: Double]] or [[String: Int]]
     - parameter concavity: The concavity from > 0 to Infinity (Infinity being a convexe Hull
     - parameter format: The name of String in [[String: Double]] or [[String: Int]] in an array, nil of pointSet is [Int] or [Double]
     - returns: An array of point in the same format as poinSet, which is the hull of the pointSet
     */
    public func hull(_ pointSet: [Any], _ format: [String]?) -> [Any] {
        self.format = format

        var convex: [[Double]]
        var innerPoints: [[Double]]
        var occupiedArea: [Double]
        var maxSearchArea: [Double]
        var cellSize: Double
        var points: [[Double]]
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

        let concave: [[Double]] = concaveFunc(&convex, pow(concavity, 2), maxSearchArea, g, &skipList)

        hull = Format().fromXy(concave, format)
        return hull
    }

    /**
     This main function allows to create the hull of a set of point by defining the desired concavity of the return hull. In this function, there is no need for the format

     - parameter mapPoints: The list of point as MKMapPoint
     - returns: An array of point in the same format as pointSet, which is the hull of the pointSet
     */
    public func hull(mapPoints: [MKMapPoint]) -> [MKMapPoint] {

        var convex: [[Double]]
        var innerPoints: [[Double]]
        var occupiedArea: [Double]
        var maxSearchArea: [Double]
        var cellSize: Double
        var points: [[Double]]
        var skipList: [String: Bool] = [String: Bool]()

        if mapPoints.count < 4 {
            return mapPoints
        }

        let newPointSet = mapPoints.map {
            (mp: MKMapPoint) -> [Double] in
            return [mp.x, mp.y]
        }

        points = filterDuplicates(sortByX(Format().toXy(newPointSet, format)))
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

        let concave: [[Double]] = concaveFunc(&convex, pow(concavity, 2), maxSearchArea, g, &skipList)

        hull = Format().fromXy(concave, format)
        return (hull as? [[Double]])!.map {
            (p: [Double]) -> MKMapPoint in
            return MKMapPoint(x: p[0], y: p[1])
        }
    }

    /**
     This main function allows to create the hull of a set of point by defining the desired concavity of the return hull. In this function, there is no need for the format

     - parameter coordinates: The list of point as CLLocationCoordinate2D
     - returns: An array of point in the same format as pointSet, which is the hull of the pointSet
     */
    public func hull(coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {

        var convex: [[Double]]

        var innerPoints: [[Double]]
        var occupiedArea: [Double]
        var maxSearchArea: [Double]
        var cellSize: Double
        var points: [[Double]]
        var skipList: [String: Bool] = [String: Bool]()

        if coordinates.count < 4 {
            return coordinates
        }

        let newPointSet = coordinates.map {
            (mp: CLLocationCoordinate2D) -> [Double] in
            return [mp.latitude, mp.longitude]
        }

        points = filterDuplicates(sortByX(Format().toXy(newPointSet, format)))
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

        let concave: [[Double]] = concaveFunc(&convex, pow(concavity, 2), maxSearchArea, g, &skipList)

        hull = Format().fromXy(concave, format)
        return (hull as? [[Double]])!.map {
            (p: [Double]) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(latitude: p[0], longitude: p[1])
        }
    }

    /**
     Create and set in the class a polygon from the hull extracted from the hull function, the hull needs to be in [[Int]] or [[Double]]
     or needs to have a format equal to ["x", "y"] or ["y", "x"]
     - returns: An MKPolygon for direct reuse and set it in the class for future use
     */
    public func getPolygonWithHull() -> MKPolygon {
        if format != nil {
            if !(format?[0] == "x" && format?[1] == "y" || format?[1] == "x" && format?[0] == "y") {
                return polygon
            }
        }

        if format != nil {
            if hull is [[String: Int]] {
                let points: [MKMapPoint] = (hull as? [[String: Int]])!.map {
                    (pt: [String: Int]) -> MKMapPoint in
                    return MKMapPoint(x: Double(pt["x"]!), y: Double(pt["y"]!))
                }
                polygon = MKPolygon(points: UnsafePointer(points), count: points.count)
            }
            if hull is [[String: Double]] {
                let points: [MKMapPoint] = (hull as? [[String: Double]])!.map {
                    (pt: [String: Double]) -> MKMapPoint in
                    return MKMapPoint(x: pt["x"]!, y: pt["y"]!)
                }
                polygon = MKPolygon(points: UnsafePointer(points), count: points.count)
            }

            return polygon
        }

        let points: [MKMapPoint] = (hull as? [[Any]])!.map {
            (pt: [Any]) -> MKMapPoint in
            if pt[0] is Int {
                return MKMapPoint(x: Double((pt[0] as? Int)!), y: Double((pt[1] as? Int)!))
            }
            if pt[0] is Double {
                return MKMapPoint(x: (pt[0] as? Double)!, y: (pt[1] as? Double)!)
            }
            return MKMapPoint()
        }
        polygon = MKPolygon.init(points: UnsafePointer(points), count: points.count)

        return polygon
    }

    /**
     Create and set in the class a polygon from the hull extracted from the hull function with a specified format, in order for this function to work, you should specify, which value of the format is the lat value and which value is the lng value.
     If you don't have a format variable of type [String], meaning, your using a pointSet of type [[Int]] or [[Double]], you should the getPolygonWithHull without arguments
     - parameter latFormat: the value of the format array to represent the latitude
     - parameter lngFormat: the value of the format array to represent the longitude
     - returns: An MKPolygon for direct reuse and set it in the class for future use
     */
    public func getPolygonWithHull(latFormat: String, lngFormat: String) -> MKPolygon {
        if format == nil {
            return getPolygonWithHull()
        }

        if hull is [[String: Int]] {
            let coords: [CLLocationCoordinate2D] = (hull as? [[String: Int]])!.map {
                (pt: [String: Int]) -> CLLocationCoordinate2D in
                return CLLocationCoordinate2D(latitude: Double(pt[latFormat]!), longitude: Double(pt[lngFormat]!))
            }
            polygon = MKPolygon(coordinates: UnsafePointer(coords), count: coords.count)
        }
        if hull is [[String: Double]] {
            let coords: [CLLocationCoordinate2D] = (hull as? [[String: Double]])!.map {
                (pt: [String: Double]) -> CLLocationCoordinate2D in
                return CLLocationCoordinate2D(latitude: pt[latFormat]!, longitude: pt[lngFormat]!)
            }
            polygon = MKPolygon(coordinates: UnsafePointer(coords), count: coords.count)
        }

        return polygon
    }

    /**
     Create and set in the class a polygon from an array of CLLocationCoordinate2D
     - parameter coords: An array of CLLocationCoordinate2D
     - returns: An MKPolygon for direct reuse and set it in the class for future use
     */
    public func getPolygon(coords: [CLLocationCoordinate2D]) -> MKPolygon {
        polygon = MKPolygon.init(coordinates: UnsafePointer(coords), count: coords.count)
        return polygon
    }

    /**
     Create and set in the class a polygon from an array of MKMapPoint
     - parameter points: An array of MKMapPoint
     - returns: An MKPolygon for direct reuse and set it in the class for future use
     */
    public func getPolygon(points: [MKMapPoint]) -> MKPolygon {
        polygon = MKPolygon.init(points: UnsafePointer(points), count: points.count)
        return polygon
    }

    /**
     Check if CLLocationCoordinate2D is inside a polygon
     - parameter coord: A CLLocationCoordinate2D variable
     - returns: A Boolean value, true if CLLocationCoordinate2D is in polygon, false if not
     */
    public func coordInPolygon(coord: CLLocationCoordinate2D) -> Bool {
        let mapPoint: MKMapPoint = MKMapPointForCoordinate(coord)
        return self.pointInPolygon(mapPoint: mapPoint)
    }

    /**
     Check if MKMapPoint is inside a polygon
     - parameter mapPoint: An MKMapPoint variable
     - returns: A Boolean value, true if MKMapPoint is in polygon, false if not
     */
    public func pointInPolygon(mapPoint: MKMapPoint) -> Bool {
        let polygonRenderer: MKPolygonRenderer = MKPolygonRenderer(polygon: polygon)
        let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)
        if polygonRenderer.path == nil {
            return false
        }
        return polygonRenderer.path.contains(polygonViewPoint)
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

    func concaveFunc(_ convex: inout [[Double]], _ maxSqEdgeLen: Double, _ maxSearchArea: [Double], _ grid: Grid, _ edgeSkipList: inout [String: Bool]) -> [[Double]] {

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

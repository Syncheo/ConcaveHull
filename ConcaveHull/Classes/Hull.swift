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
        if let concavity = concavity {
            self.concavity = concavity
        }
    }

    /**
     This main function allows to create the hull of a set of point by defining the desired concavity of the return 
     hull.
     - parameter pointSet: The list of point, can be of type [Int], [Double], [[String: Double]] or [[String: Int]]
     - parameter format: The name of String in [[String: Double]] or [[String: Int]] in an array, nil of pointSet 
     is [Int] or [Double]
     - returns: An array of point in the same format as poinSet, which is the hull of the pointSet
     */
    public func hull(_ pointSet: [Any], _ format: [String]?) -> [Any] {
        self.format = format

        if pointSet.count < 4 {
            return pointSet
        }

        hull = HullHelper().getHull(pointSet, concavity: self.concavity, format: self.format)

        return hull
    }

    /**
     This main function allows to create the hull of a set of point by defining the desired concavity of the return 
     hull.
     In this function, there is no need for the format
     - parameter mapPoints: The list of point as MKMapPoint
     - returns: An array of point in the same format as pointSet, which is the hull of the pointSet
     */
    public func hull(mapPoints: [MKMapPoint]) -> [MKMapPoint] {

        if mapPoints.count < 4 {
            return mapPoints
        }

        let pointSet = mapPoints.map { (point: MKMapPoint) -> [Double] in
            return [point.x, point.y]
        }

        hull = HullHelper().getHull(pointSet, concavity: self.concavity, format: self.format)

        return (hull as? [[Double]])!.map { (point: [Double]) -> MKMapPoint in
            return MKMapPoint(x: point[0], y: point[1])
        }
    }

    /**
     This main function allows to create the hull of a set of point by defining the desired concavity of the return 
     hull. In this function, there is no need for the format
     - parameter coordinates: The list of point as CLLocationCoordinate2D
     - returns: An array of point in the same format as pointSet, which is the hull of the pointSet
     */
    public func hull(coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {

        if coordinates.count < 4 {
            return coordinates
        }

        let pointSet = coordinates.map { (point: CLLocationCoordinate2D) -> [Double] in
            return [point.latitude, point.longitude]
        }

        hull = HullHelper().getHull(pointSet, concavity: self.concavity, format: self.format)

        return (hull as? [[Double]])!.map { (point: [Double]) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(latitude: point[0], longitude: point[1])
        }
    }

    /**
     Create and set in the class a polygon from the hull extracted from the hull function, the hull needs to be in 
     [[Int]] or [[Double]] or needs to have a format equal to ["x", "y"] or ["y", "x"]
     - returns: An MKPolygon for direct reuse and set it in the class for future use
     */
    public func getPolygonWithHull() -> MKPolygon {
        if let format = format {
            if !(format[0] == "x" && format[1] == "y" || format[1] == "x" && format[0] == "y") {
                return polygon
            }
            if hull is [[String: Int]] {
                let points: [MKMapPoint] = (hull as? [[String: Int]])!.map { (point: [String: Int]) -> MKMapPoint in
                    return MKMapPoint(x: Double(point["x"]!), y: Double(point["y"]!))
                }
                polygon = MKPolygon(points: UnsafePointer(points), count: points.count)
            }
            if hull is [[String: Double]] {
                let points = (hull as? [[String: Double]])!.map { (point: [String: Double]) -> MKMapPoint in
                    return MKMapPoint(x: point["x"]!, y: point["y"]!)
                }
                polygon = MKPolygon(points: UnsafePointer(points), count: points.count)
            }

            return polygon
        }

        let points: [MKMapPoint] = (hull as? [[Any]])!.map { (point: [Any]) -> MKMapPoint in
            if point[0] is Int {
                return MKMapPoint(x: Double((point[0] as? Int)!), y: Double((point[1] as? Int)!))
            }
            if point[0] is Double {
                return MKMapPoint(x: (point[0] as? Double)!, y: (point[1] as? Double)!)
            }
            return MKMapPoint()
        }
        polygon = MKPolygon(points: UnsafePointer(points), count: points.count)

        return polygon
    }

    /**
     Create and set in the class a polygon from the hull extracted from the hull function with a specified format, 
     in order for this function to work, you should specify, which value of the format is the lat value and which
     value is the lng value.
     If you don't have a format variable of type [String], meaning, your using a pointSet of type [[Int]] or 
     [[Double]], you should use the getPolygonWithHull without arguments
     - parameter latFormat: the value of the format array to represent the latitude
     - parameter lngFormat: the value of the format array to represent the longitude
     - returns: An MKPolygon for direct reuse and set it in the class for future use
     */
    public func getPolygonWithHull(latFormat: String, lngFormat: String) -> MKPolygon {
        if format == nil {
            return getPolygonWithHull()
        }

        if hull is [[String: Int]] {
            let coords = (hull as? [[String: Int]])!.map { (point: [String: Int]) -> CLLocationCoordinate2D in
                return CLLocationCoordinate2D(latitude: Double(point[latFormat]!), longitude: Double(point[lngFormat]!))
            }
            polygon = MKPolygon(coordinates: UnsafePointer(coords), count: coords.count)
        }
        if hull is [[String: Double]] {
            let coords = (hull as? [[String: Double]])!.map { (point: [String: Double]) -> CLLocationCoordinate2D in
                return CLLocationCoordinate2D(latitude: point[latFormat]!, longitude: point[lngFormat]!)
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
    public func getPolygonWithCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> MKPolygon {
        polygon = MKPolygon(coordinates: UnsafePointer(coordinates), count: coordinates.count)
        return polygon
    }

    /**
     Create and set in the class a polygon from an array of MKMapPoint
     - parameter points: An array of MKMapPoint
     - returns: An MKPolygon for direct reuse and set it in the class for future use
     */
    public func getPolygonWithMapPoints(_ mapPoints: [MKMapPoint]) -> MKPolygon {
        polygon = MKPolygon(points: UnsafePointer(mapPoints), count: mapPoints.count)
        return polygon
    }

    /**
     Check if CLLocationCoordinate2D is inside a polygon
     - parameter coord: A CLLocationCoordinate2D variable
     - returns: A Boolean value, true if CLLocationCoordinate2D is in polygon, false if not
     */
    public func coordInPolygon(coord: CLLocationCoordinate2D) -> Bool {
        let mapPoint: MKMapPoint = MKMapPoint(coord)
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

}

//
//  Station.swift
//  ConcaveHull
//
//  Created by Sany Maamari on 03/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import MapKit

class Station: NSObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    public var mkStation: MKStation?
    public var coreStation: CoreStation = CoreStation.init()
    public var title: String?
    public var subtitle: String?

    convenience init(coords: CLLocationCoordinate2D) {
        self.init()
        self.coordinate = coords
        self.initMKStation()
    }

    convenience init(currentLocation: CLLocationCoordinate2D) {
        self.init(coords: currentLocation)
        self.coreStation.name = "Current Location"
        self.title = coreStation.name
    }

    convenience init(dictionary: [String: Any]) {
        var coords: CLLocationCoordinate2D = Station.getCoordinates(dictionary: dictionary)

        if !Station.coordsAreValid(coord: coords) {
            coords = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        }
        self.init(coords: coords)
        self.initStationsWithOutputDictionary(dictOfStation: dictionary)
        self.title = coreStation.name
    }

    func initStationsWithOutputDictionary(dictOfStation: [String: Any]) {
        self.coreStation.idx = dictOfStation["number"] as? String ?? "-1"
        self.coreStation.name = dictOfStation["name"] as? String ?? " "
    }

    static func initAllStations(station: [Station], isGoogle: Bool) {
        for stat in station {
            stat.initMKStation()
        }
    }

    func getTitle() -> String {
        return coreStation.name
    }

    static func getCoordinates(dictionary: [String: Any]) -> CLLocationCoordinate2D {
        var coords: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)

        let position = dictionary["position"] as? [String: Any]
        if position == nil {
            return CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        }
        if position!["lat"] is String {
            if isNumeric(inputString: position!["lat"] as? String ?? "0") &&
                isNumeric(inputString: position!["lng"] as? String ?? "0") {
                coords.latitude = Double(position!["lat"] as? String ?? "0")!
                coords.latitude = Double(position!["lng"] as? String ?? "0")!
            } else {
                return CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
            }
        } else {
            if position!["lat"] is Double && position!["lng"] is Double {
                coords.latitude = position!["lat"] as? CLLocationDegrees ?? 0
                coords.longitude = position!["lng"] as? CLLocationDegrees ?? 0
            }
        }
        return coords
    }

    func initMKStation() {
        self.mkStation = MKStation.init()
        self.mkStation?.coreStation = coreStation
    }

    static func coordsAreValid(coord: CLLocationCoordinate2D) -> Bool {
        if fabs(coord.latitude) < 90 && fabs(coord.longitude) < 180 {
            if coord.latitude != 0 || coord.longitude != 0 {
                return true
            }
        }
        return false
    }

    static func isNumeric(inputString: String) -> Bool {
        var isValid: Bool = false
        let alphanum: CharacterSet = CharacterSet.init(charactersIn: "0123456789.,-+")
        let string: CharacterSet = CharacterSet.init(charactersIn: inputString)
        isValid = alphanum.isSuperset(of: string)
        return isValid
    }

}

class CoreStation: NSObject {
    var idx: String = ""
    var name: String = ""
}

class MKStation: NSObject {
    var coreStation: CoreStation = CoreStation()
}

//
//  HullTests.swift
//  ConcaveHull
//
//  Created by Sany Maamari on 15/03/2017.
//  Copyright © 2017 AppProviders. All rights reserved.
//

import Quick
import Nimble
import MapKit
@testable import ConcaveHull

class HullTests: QuickSpec {

    override func spec() {
        describe("First Full Hull Test") {
            let h : Hull = Hull(concavity: 50)
            
            let points = [[162, 332], [182, 299], [141, 292], [158, 264], [141, 408], [160, 400], [177, 430], [151, 442], [155, 425], [134, 430], [126, 447], [139, 466], [160, 471], [167, 447], [182, 466], [192, 442], [187, 413], [173, 403], [168, 425], [153, 413], [179, 275], [163, 292], [134, 270], [143, 315], [177, 320], [163, 311], [162, 281], [182, 255], [141, 226], [156, 235], [173, 207], [187, 230], [204, 194], [165, 189], [145, 201], [158, 167], [190, 165], [206, 145], [179, 153], [204, 114], [221, 138], [243, 112], [248, 139], [177, 122], [179, 99], [196, 82], [219, 90], [240, 75], [218, 61], [228, 53], [211, 34], [197, 51], [179, 65], [155, 70], [165, 85], [134, 80], [124, 58], [153, 44], [173, 34], [192, 27], [156, 19], [119, 32], [128, 17], [138, 36], [100, 58], [112, 73], [100, 92], [78, 100], [83, 78], [61, 63], [80, 44], [100, 26], [60, 39], [43, 71], [34, 54], [32, 90], [53, 104], [60, 82], [66, 99], [247, 94], [187, 180], [221, 168]]
            
            let expected: [[Double]] = [[248, 139], [221, 168], [204, 194], [187, 230], [182, 255], [182, 299], [177, 320], [160, 400], [173, 403], [187, 413], [192, 442], [182, 466], [160, 471], [139, 466], [126, 447], [141, 408], [162, 332], [143, 315], [141, 292], [134, 270], [141, 226], [145, 201], [158, 167], [177, 122], [179, 99], [165, 85], [134, 80], [100, 92], [78, 100], [53, 104], [32, 90], [34, 54], [60, 39], [100, 26], [128, 17], [156, 19], [192, 27], [211, 34], [228, 53], [240, 75], [247, 94], [248, 139]]
            
            let out = h.hull(points, nil) as? [[Double]]
            
            for r in expected {
                let rex = out!.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
                        return true
                    }
                    return false
                })
                
                it("should return correct hull") {
                    expect(rex) == true
                }
            }
            
            for r in out! {
                let rex = expected.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
                        return true
                    }
                    return false
                })
                
                it("should return correct hull") {
                    expect(rex) == true
                }
            }
            
            it(expected.count.description.appending(" should be equal to ").appending(out!.count.description)) {
                expect(out!.count) == expected.count
            }
            
            _ = h.getPolygonWithHull()
            
            
            for p in points {
                it(p.description.appending(" should be in the polygon")) {
                    expect(h.pointInPolygon(mapPoint: MKMapPoint(x: Double(p[0]), y: Double(p[1])))) == true
                }
            }
            
            it([0, 0].description.appending(" shouldn't be in the polygon")) {
                expect(h.pointInPolygon(mapPoint: MKMapPoint(x: 0.0, y: 0.0))) == false
            }
            
        }
        
        describe("Second Full Hull Test") {
            let h : Hull = Hull(concavity: 50)
            
            let points2 = [[141, 408], [160, 400], [177, 430], [151, 442], [155, 425], [134, 430], [126, 447], [139, 466], [160, 471], [167, 447], [182, 466], [192, 442], [187, 413], [173, 403], [165, 430], [171, 430], [177, 437], [175, 443], [172, 444], [163, 448], [156, 447], [153, 438], [154, 431], [160, 428]]
            let expected2: [[Double]] = [[192, 442], [182, 466], [160, 471], [139, 466], [126, 447], [141, 408], [160, 400], [173, 403], [187, 413], [192, 442]]
            
            let out = h.hull(points2, nil) as? [[Double]]
            
            for r in expected2 {
                let rex = out!.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
                        return true
                    }
                    return false
                })
                
                it("should return only outer hull of the polygon with hole") {
                    expect(rex) == true
                }
            }
        
    
            for r in out! {
                let rex = expected2.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
                        return true
                    }
                    return false
                })
                
                it("should return only outer hull of the polygon with hole") {
                    expect(rex) == true
                }
            }
            
            it(expected2.count.description.appending(" should be equal to ").appending(out!.count.description)) {
                expect(out!.count) == expected2.count
            }
            
            _ = h.getPolygonWithHull()
            
            
            for p in points2 {
                it(p.description.appending(" should be in the polygon")) {
                    expect(h.pointInPolygon(mapPoint: MKMapPoint(x: Double(p[0]), y: Double(p[1])))) == true
                }
            }
            
            it([0, 0].description.appending(" shouldn't be in the polygon")) {
                expect(h.pointInPolygon(mapPoint: MKMapPoint(x: 0.0, y: 0.0))) == false
            }

        }
        
        describe("Lat, Lng Full Hull Test") {
            
            let h : Hull = Hull(concavity: 0.0011)
            
            let points3 = [["lng": -0.206792373176235, "lat": 51.4911165465815 ],
                           ["lng": -0.207062672933557, "lat": 51.4915703125214 ],
                           ["lng": -0.207465840096923, "lat": 51.4912077781219 ],
                           ["lng": -0.210193421020222, "lat": 51.4918159814458 ],
                           ["lng": -0.214944392455692, "lat": 51.4929945001276 ],
                           ["lng": -0.208133371509344, "lat": 51.4910830915252 ],
                           ["lng": -0.214162055384851, "lat": 51.4905275966855 ],
                           ["lng": -0.208161917730384, "lat": 51.4903551232517 ],
                           ["lng": -0.209680931181673, "lat": 51.4901894811742 ],
                           ["lng": -0.212571431609104, "lat": 51.4903145141462 ],
                           ["lng": -0.216849005460861, "lat": 51.4921781720221 ]]
            let expected3:
                [[String: Double]] = [["lng": -0.206792373176235, "lat": 51.4911165465815 ],
                                      ["lng": -0.207062672933557, "lat": 51.4915703125214 ],
                                      ["lng": -0.207465840096923, "lat": 51.4912077781219 ],
                                      ["lng": -0.210193421020222, "lat": 51.4918159814458 ],
                                      ["lng": -0.214944392455692, "lat": 51.4929945001276 ],
                                      ["lng": -0.216849005460861, "lat": 51.4921781720221 ],
                                      ["lng": -0.214162055384851, "lat": 51.4905275966855 ],
                                      ["lng": -0.212571431609104, "lat": 51.4903145141462 ],
                                      ["lng": -0.209680931181673, "lat": 51.4901894811742 ],
                                      ["lng": -0.208161917730384, "lat": 51.4903551232517 ],
                                      ["lng": -0.208133371509344, "lat": 51.4910830915252 ],
                                      ["lng": -0.206792373176235, "lat": 51.4911165465815 ]]
            
            let out: [[String: Double]]? = h.hull(points3, ["lng", "lat"]) as? [[String: Double]]
            
            for r in expected3 {
                let rex = out!.contains(where: {
                    (i: [String: Double]) -> Bool in
                    if r["lat"] == i["lat"] && r["lng"] == i["lng"] {
                        return true
                    }
                    return false
                })
                
                it("should return only outer hull of the polygon with hole") {
                    expect(rex) == true
                }
            }
            
            for r in out! {
                let rex = expected3.contains(where: {
                    (i: [String: Double]) -> Bool in
                    if r["lat"] == i["lat"] && r["lng"] == i["lng"] {
                        return true
                    }
                    return false
                })
                
                it("should return only outer hull of the polygon with hole") {
                    expect(rex) == true
                }
            }
            
            it(expected3.count.description.appending(" should be equal to ").appending(out!.count.description)) {
                expect(expected3.count) == out!.count
            }
            
            _ = h.getPolygonWithHull(latFormat: "lat", lngFormat: "lng")
            
            
            for p in points3 {
                it(p.description.appending(" should be in the polygon")) {
                    expect(h.coordInPolygon(coord: CLLocationCoordinate2D(latitude: p["lat"]!, longitude: p["lng"]!))) == true
                }
            }
            
            it([0, 0].description.appending(" shouldn't be in the polygon")) {
                expect(h.coordInPolygon(coord: CLLocationCoordinate2D(latitude: 0, longitude: 0))) == false
            }
        }
        
        describe("CLLocationCoordinate Full Hull Test") {
            
            let h : Hull = Hull(concavity: 0.0011)
            
            let points3 = [["lng": -0.206792373176235, "lat": 51.4911165465815 ],
                           ["lng": -0.207062672933557, "lat": 51.4915703125214 ],
                           ["lng": -0.207465840096923, "lat": 51.4912077781219 ],
                           ["lng": -0.210193421020222, "lat": 51.4918159814458 ],
                           ["lng": -0.214944392455692, "lat": 51.4929945001276 ],
                           ["lng": -0.208133371509344, "lat": 51.4910830915252 ],
                           ["lng": -0.214162055384851, "lat": 51.4905275966855 ],
                           ["lng": -0.208161917730384, "lat": 51.4903551232517 ],
                           ["lng": -0.209680931181673, "lat": 51.4901894811742 ],
                           ["lng": -0.212571431609104, "lat": 51.4903145141462 ],
                           ["lng": -0.216849005460861, "lat": 51.4921781720221 ]]
            let expected3:
                [[String: Double]] = [["lng": -0.206792373176235, "lat": 51.4911165465815 ],
                                      ["lng": -0.207062672933557, "lat": 51.4915703125214 ],
                                      ["lng": -0.207465840096923, "lat": 51.4912077781219 ],
                                      ["lng": -0.210193421020222, "lat": 51.4918159814458 ],
                                      ["lng": -0.214944392455692, "lat": 51.4929945001276 ],
                                      ["lng": -0.216849005460861, "lat": 51.4921781720221 ],
                                      ["lng": -0.214162055384851, "lat": 51.4905275966855 ],
                                      ["lng": -0.212571431609104, "lat": 51.4903145141462 ],
                                      ["lng": -0.209680931181673, "lat": 51.4901894811742 ],
                                      ["lng": -0.208161917730384, "lat": 51.4903551232517 ],
                                      ["lng": -0.208133371509344, "lat": 51.4910830915252 ],
                                      ["lng": -0.206792373176235, "lat": 51.4911165465815 ]]
            
            
            let coords: [CLLocationCoordinate2D] = points3.map {
                (p: [String: Double]) -> CLLocationCoordinate2D in
                return CLLocationCoordinate2D(latitude: p["lat"]!, longitude: p["lng"]!)
            }
            let out: [CLLocationCoordinate2D]? = h.hull(coordinates: coords)
            
            for r in expected3 {
                let rex = out!.contains(where: {
                    (i: CLLocationCoordinate2D) -> Bool in
                    if r["lat"] == i.latitude && r["lng"] == i.longitude {
                        return true
                    }
                    return false
                })
                
                it("should return only outer hull of the polygon with hole") {
                    expect(rex) == true
                }
            }
            
            for r in out! {
                let rex = expected3.contains(where: {
                    (i: [String: Double]) -> Bool in
                    if r.latitude == i["lat"] && r.longitude == i["lng"] {
                        return true
                    }
                    return false
                })
                
                it("should return only outer hull of the polygon with hole") {
                    expect(rex) == true
                }
            }
            
            it(expected3.count.description.appending(" should be equal to ").appending(out!.count.description)) {
                expect(expected3.count) == out!.count
            }
            
             _ = h.getPolygon(coords: out!)
            
            
            for p in coords {
                it(stringify(p).appending(" should be in the polygon")) {
                    expect(h.coordInPolygon(coord: CLLocationCoordinate2D(latitude: p.latitude, longitude: p.longitude))) == true
                }
            }
            
            it([0, 0].description.appending(" shouldn't be in the polygon")) {
                expect(h.coordInPolygon(coord: CLLocationCoordinate2D(latitude: 0, longitude: 0))) == false
            }
        }
        
        describe("MKMapPoint Full Hull Test") {
            
            let h : Hull = Hull(concavity: 50)
            
            let points: [[Double]] = [[162, 332], [182, 299], [141, 292], [158, 264], [141, 408], [160, 400], [177, 430], [151, 442], [155, 425], [134, 430], [126, 447], [139, 466], [160, 471], [167, 447], [182, 466], [192, 442], [187, 413], [173, 403], [168, 425], [153, 413], [179, 275], [163, 292], [134, 270], [143, 315], [177, 320], [163, 311], [162, 281], [182, 255], [141, 226], [156, 235], [173, 207], [187, 230], [204, 194], [165, 189], [145, 201], [158, 167], [190, 165], [206, 145], [179, 153], [204, 114], [221, 138], [243, 112], [248, 139], [177, 122], [179, 99], [196, 82], [219, 90], [240, 75], [218, 61], [228, 53], [211, 34], [197, 51], [179, 65], [155, 70], [165, 85], [134, 80], [124, 58], [153, 44], [173, 34], [192, 27], [156, 19], [119, 32], [128, 17], [138, 36], [100, 58], [112, 73], [100, 92], [78, 100], [83, 78], [61, 63], [80, 44], [100, 26], [60, 39], [43, 71], [34, 54], [32, 90], [53, 104], [60, 82], [66, 99], [247, 94], [187, 180], [221, 168]]
            
            let expected: [[Double]] = [[248, 139], [221, 168], [204, 194], [187, 230], [182, 255], [182, 299], [177, 320], [160, 400], [173, 403], [187, 413], [192, 442], [182, 466], [160, 471], [139, 466], [126, 447], [141, 408], [162, 332], [143, 315], [141, 292], [134, 270], [141, 226], [145, 201], [158, 167], [177, 122], [179, 99], [165, 85], [134, 80], [100, 92], [78, 100], [53, 104], [32, 90], [34, 54], [60, 39], [100, 26], [128, 17], [156, 19], [192, 27], [211, 34], [228, 53], [240, 75], [247, 94], [248, 139]]
            
            
            let coords: [MKMapPoint] = points.map {
                (p: [Double]) -> MKMapPoint in
                return MKMapPoint(x: p[0], y: p[1])
            }
            let out: [MKMapPoint]? = h.hull(mapPoints: coords)
            
            for r in expected {
                let rex = out!.contains(where: {
                    (i: MKMapPoint) -> Bool in
                    if r[0] == i.x && r[1] == i.y {
                        return true
                    }
                    return false
                })
                
                it("should return only outer hull of the polygon with hole") {
                    expect(rex) == true
                }
            }
            
            for r in out! {
                let rex = expected.contains(where: {
                    (i: [Double]) -> Bool in
                    if r.x == i[0] && r.y == i[1] {
                        return true
                    }
                    return false
                })
                
                it("should return only outer hull of the polygon with hole") {
                    expect(rex) == true
                }
            }
            
            it(expected.count.description.appending(" should be equal to ").appending(out!.count.description)) {
                expect(expected.count) == out!.count
            }
            
            _ = h.getPolygon(points: out!)
            
            
            for p in coords {
                it(stringify(p).appending(" should be in the polygon")) {
                    expect(h.pointInPolygon(mapPoint: p)) == true
                }
            }
            
            it([0, 0].description.appending(" shouldn't be in the polygon")) {
                expect(h.pointInPolygon(mapPoint: MKMapPointMake(0, 0))) == false
            }
        }


    }
    
    
}

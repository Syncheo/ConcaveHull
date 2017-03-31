//
//  IntersectTests.swift
//  ConcaveHull
//
//  Created by Sany Maamari on 15/03/2017.
//  Copyright © 2017 AppProviders. All rights reserved.
//

import Quick
import Nimble
import MapKit
@testable import ConcaveHull

class IntersectSpec: QuickSpec {
    override func spec() {
        
        let h = Hull()
        h.polygon = MKPolygon()
        describe("Intersect Test") {
            
            it("should return false for the parallel segments") {
                expect(false) == Intersect([[0, 0], [0, 10]], [[10, 0], [10, 10]]).isIntersect
            }
            
            it("should return false for collinear segments") {
                expect(false) == Intersect([[0.0, 0.0], [0.0, 10.0]], [[0.0, 11.0], [0, 20]]).isIntersect
            }
            
            it("should return false for intersecting lines but nonintersecting segments") {
                expect(false) == Intersect([[0.0, 0.0], [0.0, 10.0]], [[-10.0, 11.0], [10, 11]]).isIntersect
            }
            
            it("should return true for intersecting segments") {
                expect(true) == Intersect([[0.0, 0.0], [0.0, 10.0]], [[-10.0, 5.0], [10, 5]]).isIntersect
            }
            
            it("should return true for touching segments") {
                expect(true) == Intersect([[0, 0], [0, 10]], [[-10, 10], [10, 10]]).isIntersect
            }
        }
    }
}

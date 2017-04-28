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

        describe("Intersect Test") {

            it("should return false for the parallel segments") {
                expect(Intersect([Point(xxx: 0, yyy: 0), Point(xxx:0, yyy: 10)],
                    [Point(xxx: 10, yyy: 0), Point(xxx:10, yyy: 10)]).isIntersect) == false
            }

            it("should return false for collinear segments") {
                expect(Intersect([Point(xxx: 0, yyy: 0), Point(xxx:0, yyy: 10)],
                    [Point(xxx: 0, yyy: 11), Point(xxx:10, yyy: 20)]).isIntersect) == false
            }

            it("should return false for intersecting lines but nonintersecting segments") {
                expect(Intersect([Point(xxx: 0, yyy: 0), Point(xxx:0, yyy: 10)],
                    [Point(xxx: -10, yyy: 11), Point(xxx:10, yyy: 11)]).isIntersect) == false
            }

            it("should return true for intersecting segments") {
                expect(Intersect([Point(xxx: 0, yyy: 0), Point(xxx:0, yyy: 10)],
                    [Point(xxx: -10, yyy: 5), Point(xxx:10, yyy: 5)]).isIntersect) == true
            }

            it("should return true for touching segments") {
                expect(Intersect([Point(xxx: 0, yyy: 0), Point(xxx:0, yyy: 10)],
                    [Point(xxx: -10, yyy: 10), Point(xxx:10, yyy: 10)]).isIntersect) == true
            }
        }
    }
}

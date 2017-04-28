//
//  GridTests.swift
//  ConcaveHull
//
//  Created by Sany Maamari on 15/03/2017.
//  Copyright © 2017 AppProviders. All rights reserved.
//

import Quick
import Nimble
@testable import ConcaveHull

class GridSpecs: QuickSpec {

    override func spec() {
        let points: [Point] = [
            // cell 0,0
            Point(xxx: 0, yyy: 0), Point(xxx: 1, yyy: 1), Point(xxx: 9, yyy: 5),
            // cell 0,1
            Point(xxx: 1, yyy: 11), Point(xxx: 5, yyy: 15),
            // cell 1,0
            Point(xxx: 11, yyy: 0), Point(xxx: 11, yyy: 1), Point(xxx: 19, yyy: 5),
            // cell 1,1
            Point(xxx: 10, yyy: 10), Point(xxx: 11, yyy: 11)]
        let g: Grid = Grid(points, 10)

        describe("Test of Cell Points") {
            var input = g.cellPoints(0, 0)
            var output = [Point(xxx: 0, yyy: 0), Point(xxx: 1, yyy: 1), Point(xxx: 9, yyy: 5)]
            for r in input {
                let rex = output.contains(where: { (idx: Point) -> Bool in
                    if (r.xxx == idx.xxx && r.yyy == idx.yyy) || (r.xxx == idx.yyy && r.yyy == idx.xxx) {
                        return true
                    }
                    return false
                })
                it("should return true for point [0, 0]") {
                    expect(true) == rex
                }
            }

            for r in output {
                let rex = input.contains(where: { (idx: Point) -> Bool in
                    if (r.xxx == idx.xxx && r.yyy == idx.yyy) || (r.xxx == idx.yyy && r.yyy == idx.xxx) {
                        return true
                    }
                    return false
                })
                it("should return true for point [0, 0]") {
                    expect(true) == rex
                }
            }

            input = g.cellPoints(0, 1)
            output = [Point(xxx: 1, yyy: 11), Point(xxx: 5, yyy: 15)]

            for r in input {
                let rex = output.contains(where: { (idx: Point) -> Bool in
                    if (r.xxx == idx.xxx && r.yyy == idx.yyy) || (r.xxx == idx.yyy && r.yyy == idx.xxx) {
                        return true
                    }
                    return false
                })
                it("should return true for point [0, 1]") {
                    expect(true) == rex
                }
            }

            for r in output {
                let rex = input.contains(where: { (idx: Point) -> Bool in
                    if (r.xxx == idx.xxx && r.yyy == idx.yyy) || (r.xxx == idx.yyy && r.yyy == idx.xxx) {
                        return true
                    }
                    return false
                })
                it("should return true for point [0, 1]") {
                    expect(true) == rex
                }
            }

            input = g.cellPoints(1, 0)
            output = [Point(xxx: 11, yyy: 0), Point(xxx: 11, yyy: 1), Point(xxx: 19, yyy: 5)]

            for r in input {
                let rex = output.contains(where: { (idx: Point) -> Bool in
                    if (r.xxx == idx.xxx && r.yyy == idx.yyy) || (r.xxx == idx.yyy && r.yyy == idx.xxx) {
                        return true
                    }
                    return false
                })
                it("should return true for point [1, 0]") {
                    expect(true) == rex
                }
            }

            for r in output {
                let rex = input.contains(where: { (idx: Point) -> Bool in
                    if (r.xxx == idx.xxx && r.yyy == idx.yyy) || (r.xxx == idx.yyy && r.yyy == idx.xxx) {
                        return true
                    }
                    return false
                })
                it("should return true for point [1, 0]") {
                    expect(true) == rex
                }
            }

            input = g.cellPoints(1, 1)
            output = [Point(xxx: 10, yyy: 10), Point(xxx: 11, yyy: 11)]

            for r in input {
                let rex = output.contains(where: { (idx: Point) -> Bool in
                    if (r.xxx == idx.xxx && r.yyy == idx.yyy) || (r.xxx == idx.yyy && r.yyy == idx.xxx) {
                        return true
                    }
                    return false
                })
                it("should return true for point [1, 1]") {
                    expect(true) == rex
                }
            }

            for r in output {
                let rex = input.contains(where: { (idx: Point) -> Bool in
                    if (r.xxx == idx.xxx && r.yyy == idx.yyy) || (r.xxx == idx.yyy && r.yyy == idx.xxx) {
                        return true
                    }
                    return false
                })
                it("should return true for point [1, 1]") {
                    expect(true) == rex
                }
            }
        }

        describe("Test Of Point to Cell XY") {

            var r = g.point2CellXY(Point(xxx:1, yyy: 1))
            var i = [0, 0]

            it("should return ".appending(i.description)) {
                expect(r) == i
            }

            r = g.point2CellXY(Point(xxx:1, yyy: 11))
            i = [0, 1]

            it("should return ".appending(i.description)) {
                expect(r) == i
            }

            r = g.point2CellXY(Point(xxx:11, yyy: 1))
            i = [1, 0]

            it("should return ".appending(i.description)) {
                expect(r) == i
            }

            r = g.point2CellXY(Point(xxx:10, yyy: 10))
            i = [1, 1]

            it("should return ".appending(i.description)) {
                expect(r) == i
            }

            r = g.point2CellXY(Point(xxx:11, yyy: 11))
            i = [1, 1]

            it("should return ".appending(i.description)) {
                expect(r) == i
            }
        }

        describe("Test Of Range Of Points") {
            for r in g.rangePoints([1, 0, 6, 16]) {
                let testArray = [Point(xxx: 0, yyy: 0), Point(xxx: 1, yyy: 1), Point(xxx: 9, yyy: 5),
                                 Point(xxx: 1, yyy: 11), Point(xxx: 5, yyy: 15)]
                let rex = testArray.contains(where: { (idx: Point) -> Bool in
                    if (r.xxx == idx.xxx && r.yyy == idx.yyy) || (r.xxx == idx.yyy && r.yyy == idx.xxx) {
                        return true
                    }
                    return false
                })
                it("should return points from cells [0,0] and [0,1]") {
                    expect(true) == rex
                }
            }

            for r in g.rangePoints([0, 0, 11, 11]) {
                let rex = points.contains(where: { (idx: Point) -> Bool in
                    if (r.xxx == idx.xxx && r.yyy == idx.yyy) || (r.xxx == idx.yyy && r.yyy == idx.xxx) {
                        return true
                    }
                    return false
                })

                it("should return points from cells [0,0] and [1,1]") {
                    expect(true) == rex
                }
            }
        }

        describe("Test of Extend Bounding box") {
            var r = g.extendBbox([0, 0, 11, 11], 1)
            var i: [Double] = [-10, -10, 21, 21]
            it("should increase bBox to 1 cell") {
                expect(r) == i
            }

            r = g.extendBbox([0, 0, 11, 11], 2)
            i = [-20, -20, 31, 31]

            it("should increase bBox to 2 cells") {
                expect(r) == i
            }

        }
    }

}

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
        let points: [[Double]] = [
            // cell 0,0
            [0, 0], [1, 1], [9, 5],
            // cell 0,1
            [1, 11], [5, 15],
            // cell 1,0
            [11, 0], [11, 1], [19, 5],
            // cell 1,1
            [10, 10], [11, 11]]
        let g: Grid = Grid(points, 10)
        
        describe("Test of Cell Points") {
            var input = g.cellPoints(0, 0)
            var output = [[0, 0], [1, 1], [9, 5]] as [[Double]]
            
            for r in input {
                let rex = output.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
                        return true
                    }
                    return false
                })
                it("should return true for point [0, 0]") {
                    expect(true) == rex
                }
                
            }
            
            for r in output {
                let rex = input.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
                        return true
                    }
                    return false
                })
                it("should return true for point [0, 0]") {
                    expect(true) == rex
                }
               
            }
            
            input = g.cellPoints(0, 1)
            output = [[1, 11], [5, 15]] as [[Double]]
            
            for r in input {
                let rex = output.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
                        return true
                    }
                    return false
                })
                it("should return true for point [0, 1]") {
                    expect(true) == rex
                }
            }
            
            for r in output {
                let rex = input.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
                        return true
                    }
                    return false
                })
                it("should return true for point [0, 1]") {
                    expect(true) == rex
                }
            }
            
            input = g.cellPoints(1, 0)
            output = [[11, 0], [11, 1], [19, 5]] as [[Double]]
            
            for r in input {
                let rex = output.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
                        return true
                    }
                    return false
                })
                it("should return true for point [1, 0]") {
                    expect(true) == rex
                }
            }
            
            for r in output {
                let rex = input.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
                        return true
                    }
                    return false
                })
                it("should return true for point [1, 0]") {
                    expect(true) == rex
                }
            }
            
            input = g.cellPoints(1, 1)
            output = [[10, 10], [11, 11]] as [[Double]]
            
            for r in input {
                let rex = output.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
                        return true
                    }
                    return false
                })
                it("should return true for point [1, 1]") {
                    expect(true) == rex
                }
            }
            
            for r in output {
                let rex = input.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
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

            var r = g.point2CellXY([1, 1])
            var i = [0, 0]
            
            it("should return ".appending(i.description)) {
                expect(r) == i
            }
        
            
            r = g.point2CellXY([1, 11])
            i = [0, 1]
            
            it("should return ".appending(i.description)) {
                expect(r) == i
            }
            
            r = g.point2CellXY([11, 1])
            i = [1, 0]
            
            it("should return ".appending(i.description)) {
                expect(r) == i
            }
            
            r = g.point2CellXY([10, 10])
            i = [1, 1]
            
            it("should return ".appending(i.description)) {
                expect(r) == i
            }
            
            r = g.point2CellXY([11, 11])
            i = [1, 1]
            
            it("should return ".appending(i.description)) {
                expect(r) == i
            }
        }
        
        describe("Test Of Range Of Points") {
            
            for r in g.rangePoints([1, 0, 6, 16]) {
                let rex = [[0, 0], [1, 1], [9, 5], [1, 11], [5, 15]].contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
                        return true
                    }
                    return false
                })
                it("should return points from cells [0,0] and [0,1]") {
                    expect(true) == rex
                }
            }
            
            for r in g.rangePoints([0, 0, 11, 11]) {
                let rex = points.contains(where: {
                    (i: [Double]) -> Bool in
                    if (r[0] == i[0] && r[1] == i[1]) || (r[0] == i[1] && r[1] == i[0]) {
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

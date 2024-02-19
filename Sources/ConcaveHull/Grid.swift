//
//  Grid.swift
//  Hull
//
//  Created by Sany Maamari on 09/03/2017.
//  Copyright © 2017 AppProviders. All rights reserved.
//  (c) 2014-2016, Andrii Heonia
//  Hull.js, a JavaScript library for concave hull generation by set of points.
//  https://github.com/AndriiHeonia/hull
//

import Foundation

class Grid {
    var cells = [Int: [Int: [Point]]]()
    var cellSize: Double = 0

    init(_ points: [Point], _ cellSize: Double) {
        self.cellSize = cellSize
        for point in points {
            let cellXY = point2CellXY(point)
            let xxx = cellXY[0]
            let yyy = cellXY[1]
            if cells[xxx] == nil {
                cells[xxx] = [Int: [Point]]()
            }
            if cells[xxx]![yyy] == nil {
                cells[xxx]![yyy] = [Point]()
            }
            cells[xxx]![yyy]!.append(point)
        }
    }

    func point2CellXY(_ point: Point) -> [Int] {
        let xxx = Int(point.xxx / self.cellSize)
        let yyy = Int(point.yyy / self.cellSize)
        return [xxx, yyy]
    }

    func extendBbox(_ bbox: [Double], _ scaleFactor: Double) -> [Double] {
        return [
            bbox[0] - (scaleFactor * self.cellSize),
            bbox[1] - (scaleFactor * self.cellSize),
            bbox[2] + (scaleFactor * self.cellSize),
            bbox[3] + (scaleFactor * self.cellSize)
        ]
    }

    func removePoint(_ point: Point) {
        let cellXY = point2CellXY(point)
        var cell = cells[cellXY[0]]![cellXY[1]]!
        var pointIdxInCell = 0
        for idx in 0..<cell.count {
            if cell[idx].xxx == point.xxx && cell[idx].yyy == point.yyy {
                pointIdxInCell = idx
                break
            }
        }
        cells[cellXY[0]]![cellXY[1]]!.remove(at: pointIdxInCell)
    }

    func rangePoints(_ bbox: [Double]) -> [Point] {
        let tlCellXY = point2CellXY(Point(xxx: bbox[0], yyy: bbox[1]))
        let brCellXY = point2CellXY(Point(xxx: bbox[2], yyy: bbox[3]))
        var points = [Point]()

        for xxx in tlCellXY[0]..<brCellXY[0]+1 {
            for yyy in tlCellXY[1]..<brCellXY[1]+1 {
                points += cellPoints(xxx, yyy)
            }
        }
        return points
    }

    func cellPoints(_ xAbs: Int, _ yOrd: Int) -> [Point] {
        if let xxx = cells[xAbs] {
            if let yyy = xxx[yOrd] {
                return yyy
            }
        }
        return [Point]()
    }

}

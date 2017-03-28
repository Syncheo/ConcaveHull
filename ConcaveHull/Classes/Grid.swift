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
    var cells = [Int: [Int: [[Double]]]]()
    var cellSize: Double = 0

    init(_ points: [[Double]], _ cellSize: Double) {
        self.cellSize = cellSize
        for point in points {
            let cellXY = point2CellXY(point)
            let x = cellXY[0]
            let y = cellXY[1]
            if cells[x] == nil {
                cells[x] = [Int: [[Double]]]()
            }
            if cells[x]![y] == nil {
                cells[x]![y] = [[Double]]()
            }
            cells[x]![y]!.append(point)
        }
    }

    func point2CellXY(_ point: [Double]) -> [Int] {
        let x = Int(point[0] / self.cellSize)
        let y = Int(point[1] / self.cellSize)
        return [x, y]
    }

    func extendBbox(_ bbox: [Double], _ scaleFactor: Double) -> [Double] {
        return [
            bbox[0] - (scaleFactor * self.cellSize),
            bbox[1] - (scaleFactor * self.cellSize),
            bbox[2] + (scaleFactor * self.cellSize),
            bbox[3] + (scaleFactor * self.cellSize)
        ]
    }

    func removePoint(_ point: [Double]) {
        let cellXY = point2CellXY(point)
        var cell = cells[cellXY[0]]![cellXY[1]]!
        var pointIdxInCell = 0
        for i in 0..<cell.count {
            if cell[i][0] == point[0] && cell[i][1] == point[1] {
                pointIdxInCell = i
                break
            }
        }
        cells[cellXY[0]]![cellXY[1]]!.remove(at: pointIdxInCell)
    }

    func rangePoints(_ bbox: [Double]) -> [[Double]] {
        let tlCellXY = point2CellXY([bbox[0], bbox[1]])
        let brCellXY = point2CellXY([bbox[2], bbox[3]])
        var points = [[Double]]()

        for x in tlCellXY[0]..<brCellXY[0]+1 {
            for y in tlCellXY[1]..<brCellXY[1]+1 {
                points = points + cellPoints(x, y)
            }
        }
        return points
    }

    func cellPoints(_ x: Int, _ y: Int) -> [[Double]] {
        if cells[x] != nil {
            if cells[x]![y] != nil {
                return cells[x]![y]!
            }
        }
        return [[Double]]()
    }

}

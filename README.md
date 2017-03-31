# ConcaveHull - A Swift Library that builds concave hull by set of points 

[![CI Status](http://img.shields.io/travis/SanyM/ConcaveHull.svg?style=flat)](https://travis-ci.org/SanyM/ConcaveHull)
[![Version](https://img.shields.io/cocoapods/v/ConcaveHull.svg?style=flat)](http://cocoapods.org/pods/ConcaveHull)
[![License](https://img.shields.io/cocoapods/l/ConcaveHull.svg?style=flat)](http://cocoapods.org/pods/ConcaveHull)
[![Platform](https://img.shields.io/cocoapods/p/ConcaveHull.svg?style=flat)](http://cocoapods.org/pods/ConcaveHull)

## Usage

	let points = [[162, 332], [182, 299], [141, 292], [158, 264], ... ];
	let hull = Hull().hull(points, 50, nil)

## Params
 public func hull(_ pointSet: [Any], _ concavity: Double?, _ format: [String]?) -> [Any] {
 
 
* 1st param - array of coordinates in format: `[Any]`, `[Any]` can be [[Int]], [[Double]], [[String: Int]], [[String: Double]];
* 2nd param - concavity. `1` - thin shape. `Infinity` - convex hull. By default `20`;
* 3rd param - the format of the array of coordinates For example: `["lng", "lat"]` if you have `["lng": x, "lat": y]` points. If your are using [[Int]] or [[Double]], the value can be nil

## How it works

This step by step guide was taken as the original code from <a href="https://github.com/AndriiHeonia/hull/blob/master/README.md">https://github.com/AndriiHeonia/hull</a>
Let's see step by step what happens when you call `hull()` function:

<ol>
    <li>
        <div>Hull.js takes your source points of the shape:</div>
        <div><img src="https://raw.githubusercontent.com/SanyM/ConcaveHull/master/readme-imgs/0.png" /></div>
    </li>
    <li>
        <div>Builds convex hull:</div>
        <div><img src="https://raw.githubusercontent.com/SanyM/ConcaveHull/master/readme-imgs/1.png" /></div>
    </li>
    <li>
        <div>After that, the edges flex inward (according to the `concavity` param). For example:</div>
        <div>
            <img src="https://raw.githubusercontent.com/SanyM/ConcaveHull/master/readme-imgs/2_1.png" />
            `concavity = 80`<br/>
            <img src="https://raw.githubusercontent.com/SanyM/ConcaveHull/master/readme-imgs/2_2.png" />
            `concavity = 40`<br/>
            <img src="https://raw.githubusercontent.com/SanyM/ConcaveHull/master/readme-imgs/2_3.png" />
            `concavity = 20`
        </div>
    </li>
</ol>
## Installation

ConcaveHull is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ConcaveHull"
```

## CHANGELOG

### 1.0.0
Add new function to create a polygon from the created hull and to check if a point is in the polygon

public func getPolygonWithHull() -> MKPolygon {
public func getPolygonWithHull(latFormat: String, lngFormat: String) -> MKPolygon {

These functions create a polygon from the hull extracted from the hull function

public func getPolygon(coords: [CLLocationCoordinate2D]) -> MKPolygon {
public func getPolygon(points: [MKMapPoint]) -> MKPolygon {

These functions create a polygon from a specific array of coordinates

public func coordInPolygon(coord: CLLocationCoordinate2D) -> Bool {
public func pointInPolygon(mapPoint: MKMapPoint) -> Bool {

These functions check if a coordinate or point is in a polygon

### 0.1.1
First version with correct metadata

### 0.1.0
Initial Version



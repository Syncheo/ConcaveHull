## 1.3.0
Add Package.swift and change the file structure to the usual SPM structure.
## 1.2.0
Swift 4.2 compatibility

## 1.1.0
Swift 4 compatibility, chance

## 1.0.0
Add new function to create a polygon from the created hull and to check if a point is in the polygon

These functions create a polygon from the hull extracted from the hull function
* public func getPolygonWithHull() -> MKPolygon {
* public func getPolygonWithHull(latFormat: String, lngFormat: String) -> MKPolygon {

These functions create a polygon from a specific array of coordinates
* public func getPolygon(coords: [CLLocationCoordinate2D]) -> MKPolygon {
* public func getPolygon(points: [MKMapPoint]) -> MKPolygon {

These functions check if a coordinate or point is in a polygon
* public func coordInPolygon(coord: CLLocationCoordinate2D) -> Bool {
* public func pointInPolygon(mapPoint: MKMapPoint) -> Bool {


## 0.1.1
First version with correct metadata

## 0.1.0
Initial Version

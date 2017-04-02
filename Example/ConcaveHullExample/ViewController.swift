//
//  ViewController.swift
//  ConcaveHullExample
//
//  Created by Sany Maamari on 02/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import MapKit
//import ConcaveHull

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var slider : UISlider?
    @IBOutlet weak var map : MKMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        map?.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        
    }


}


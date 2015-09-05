//
//  LeftViewController.swift
//  MiBeacon
//
//  Created by silver on 15/9/4.
//  Copyright (c) 2015年 silver. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController,GDFSlideControllerChild,GDFSlideControllerStatus{
    var sliderController: GDFSlideController?;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.redColor();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func slideControllerDidClose(slideController: GDFSlideController!) {
    }
    func slideControllerDidOpen(slideController: GDFSlideController!) {
    }
    func slideControllerTapClose(slideController: GDFSlideController!) {
    }
    func slideControllerWillClose(slideController: GDFSlideController!) {
    }
    func slideControllerWillOpen(slideController: GDFSlideController!) {
    }
    
    func printLog(str: String){
        println("\(str)");
    }
}

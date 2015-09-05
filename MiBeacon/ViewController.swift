//
//  ViewController.swift
//  MiBeacon
//
//  Created by silver on 15/9/4.
//  Copyright (c) 2015年 silver. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    weak var leftPage : GDFSlideController?;
    var navBar:UINavigationBar?;

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        navBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 69));
        navBar?.barTintColor = UIColor.blueColor();
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()];
        navBar?.translucent = false;
        self.view.addSubview(navBar!);
        var barItems = UINavigationItem(title: "MiBeacon");
        var leftItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("MenuAction"));
        barItems.leftBarButtonItem = leftItem;
        navBar?.pushNavigationItem(barItems, animated: true);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.grayColor();
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func MenuAction(){
        println("MenuAction");
        if (leftPage != nil) {
            if leftPage?.drawerState == GDFDrawerControllerState.Open{
                leftPage?.close();
            }else if leftPage?.drawerState == GDFDrawerControllerState.Closed{
                leftPage?.open();
            }
        }
    }

}


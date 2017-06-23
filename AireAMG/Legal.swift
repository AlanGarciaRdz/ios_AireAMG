//
//  Legal.swift
//  AireAMG
//
//  Created by Alan Garcia on 9/25/16.
//  Copyright © 2016 ShadowForge. All rights reserved.
//

import Foundation

class Legal: UIViewController{
    
    
    
    @IBOutlet weak var Menu: UIBarButtonItem!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        //Menu.target = self.revealViewController()
        //Menu.action = Selector("revealToggle:")
        
        
        /*self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())*/
        
        ScrollView.contentSize.height = 3000;
    
    }
}

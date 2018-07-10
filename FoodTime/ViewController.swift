//
//  ViewController.swift
//  FoodTime
//
//  Created by Sanchis Floriane on 7/10/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ret : DatabaseReference! = Database.database().reference(withPath: "user")
        print("oooooooooook : \(ret)")

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


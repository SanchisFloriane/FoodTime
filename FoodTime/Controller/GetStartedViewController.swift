//
//  GetStartedViewController.swift
//  FoodTime
//
//  Created by bob on 7/11/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {

    @IBOutlet weak var LogginButton: UIButton!
    @IBOutlet weak var GetStartedButton: UIButton!
    @IBOutlet weak var TaglineText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LogginButton.setTitle(UILabels.localizeWithoutComment(key: UILabels.LogginButton), for: .normal)
        LogginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        GetStartedButton.setTitle(UILabels.localizeWithoutComment(key: UILabels.GetStartedButton), for: .normal)
        TaglineText.text = UILabels.localizeWithoutComment(key: UILabels.TaglineTextMainPage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

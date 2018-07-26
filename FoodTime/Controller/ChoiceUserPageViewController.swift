//
//  ChoiceUserPageViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 24/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class ChoiceUserPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageControl = UIPageControl()
    var typePlace : [Int] = [Int]()
    var typeDrink : [Int] = [Int]()
    var typeFood : [Int] = [Int]()
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: Service.ChoicePlaceViewController), self.newVc(viewController: Service.ChoiceTypeFoodViewController), self.newVc(viewController: Service.ChoiceTypeDrinkViewController), self.newVc(viewController: Service.ChoiceNotificationViewController)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        configurePageControl()
        
         NotificationCenter.default.addObserver(self, selector: #selector(pageViewController(_:viewControllerAfter:)), name: Service.Scroll, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func configurePageControl()
    {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = self.orderedViewControllers.count
        pageControl = configurePageControl(pageControl: pageControl)
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newVc(viewController: String) -> UIViewController {
        let child = UIStoryboard(name: Service.MainStoryboard, bundle: nil).instantiateViewController(withIdentifier:viewController)
        let parent = child as! PageObservation
        parent.getParentUIPageViewController(parentRef: self)
        return child
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}

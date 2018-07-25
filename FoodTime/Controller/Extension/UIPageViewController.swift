//
//  UIPageViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 24/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation
import UIKit

extension UIPageViewController
{
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil)
    {
        if let currentViewController = viewControllers?[0]
        {
            if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController)
            {                
                setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
            }
        }
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil)
    {
        if let currentViewController = viewControllers?[0]
        {
            if let nextPage = dataSource?.pageViewController(self, viewControllerBefore: currentViewController)
            {
                setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
            }
        }
    }
    
    func configurePageControl(pageControl: UIPageControl) -> UIPageControl
    {
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        return pageControl
    }
    
}

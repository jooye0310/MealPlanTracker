//
//  PageVC.swift
//  MealPlanTracker
//
//  Created by Yehoon on 4/28/18.
//  Copyright © 2018 Yehoon Joo. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
    
    var currentPage = 1
    var mealsArray = [MealInfo]()
    var pageControl: UIPageControl!
    var barButtonWidth: CGFloat = 44
    var barButtonHeight: CGFloat = 44
//    var manageButton: UIButton!
//    var manageButtonSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        delegate = self
        dataSource = self
        
        let listVC = createVC(forPage: 2)
        let graphVC = createVC(forPage: 0)
        let summaryVC = createVC(forPage: 1)
        
        setViewControllers([listVC], direction: .forward, animated: false, completion: nil)
        setViewControllers([graphVC], direction: .forward, animated: false, completion: nil)
        setViewControllers([summaryVC], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configurePageControl()
//        configureManageButton()
    }
    
    //MARK:- Segues
//    @objc func segueToListVC() {
//        performSegue(withIdentifier: "ToListVC", sender: nil)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ToListVC" {
//            let destination = segue.destination as! ListVC
//            destination.mealsArray = mealsArray
//            destination.currentPage = currentPage
//        }
//    }
    
    //MARK:- UI functions
    func configurePageControl() {
        let pageControlHeight: CGFloat = barButtonHeight
        let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth * 2)
        
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2, y: safeHeight - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = 3
        if let currentViewController = self.viewControllers?[0] as? ListVC {
            pageControl.currentPage = currentViewController.currentPage
        } else {
            pageControl.currentPage = currentPage
        }
        
//        pageControl.addTarget(self, action: #selector(pageControlPressed), for: .touchUpInside)
        view.addSubview(pageControl)
    }
    
//    func configureManageButton() {
//        let manageButtonText = "Manage Meals"
//        let manageButtonFont = UIFont.systemFont(ofSize: 15)
//        let fontAttributes = [NSAttributedStringKey.font: manageButtonFont]
//        manageButtonSize = manageButtonText.size(withAttributes: fontAttributes)
//        manageButtonSize.height += 16
//        manageButtonSize.width += 16
//        
//        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
//        manageButton = UIButton(frame: CGRect(x: 8, y: (safeHeight - 5) - manageButtonSize.height, width: manageButtonSize.width, height: manageButtonSize.height))
//        manageButton.setTitle(manageButtonText, for: .normal)
//        manageButton.setTitleColor(UIColor.darkText, for: .normal)
//        manageButton.titleLabel?.font = manageButtonFont
//        manageButton.addTarget(self, action: #selector(segueToListVC), for: .touchUpInside)
//        view.addSubview(manageButton)
//    }
    
    //MARK:- Create View Controller for UIPageViewController
    func createVC(forPage page: Int) -> UIViewController { // creating a new VC
        switch page {
        case 0: // GraphVC
            let newVC = storyboard!.instantiateViewController(withIdentifier: "GraphVC") as! GraphVC
            return newVC
        case 1: // SummaryVC
            let newVC = storyboard!.instantiateViewController(withIdentifier: "SummaryVC") as! SummaryVC
            return newVC
        default: // ListVC
            let newVC = storyboard!.instantiateViewController(withIdentifier: "ListVC") as! ListVC
            return newVC
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension PageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if (pageViewController.viewControllers?[0] as? GraphVC) != nil {
            return createVC(forPage: 1)
        }
        if (pageViewController.viewControllers?[0] as? SummaryVC) != nil {
            return createVC(forPage: 2)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if (pageViewController.viewControllers?[0] as? SummaryVC) != nil {
            return createVC(forPage: 0)
        }
        if (pageViewController.viewControllers?[0] as? ListVC) != nil {
            return createVC(forPage: 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?[0] as? GraphVC {
            pageControl.currentPage = currentViewController.currentPage
        } else if let currentViewController = pageViewController.viewControllers?[0] as? SummaryVC {
            pageControl.currentPage = currentViewController.currentPage
        } else if let currentViewController = pageViewController.viewControllers?[0] as? ListVC {
            pageControl.currentPage = currentViewController.currentPage
        }
    }
    
//    @objc func pageControlPressed() {
//        if let currentViewController = self.viewControllers?[0] as? GraphVC {
//            currentPage = currentViewController.currentPage
//            if pageControl.currentPage > currentPage {
//                setViewControllers([createVC(forPage: 1)], direction: .forward, animated: true, completion: nil)
//            }
//        } else if let currentViewController = self.viewControllers?[0] as? SummaryVC {
//            currentPage = currentViewController.currentPage
//            if pageControl.currentPage < currentPage {
//                setViewControllers([createVC(forPage: 0)], direction: .reverse, animated: true, completion: nil)
//            } else if pageControl.currentPage > currentPage {
//                setViewControllers([createVC(forPage: 2)], direction: .reverse, animated: true, completion: nil)
//            }
//        } else if let currentViewController = self.viewControllers?[0] as? ListVC {
//            currentPage = currentViewController.currentPage
//            if pageControl.currentPage < currentPage {
//                setViewControllers([createVC(forPage: 1)], direction: .reverse, animated: true, completion: nil)
//            }
//        }
//    }
}

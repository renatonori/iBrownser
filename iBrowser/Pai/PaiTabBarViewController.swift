

//
//  PaiTabBarViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 23/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class PaiTabBarViewController: UITabBarController,UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        var titleView : UIImageView
        // set the dimensions you want here
        titleView = UIImageView(frame:CGRect(x: 0, y: 0, width: 100, height: 40))
        // Set how do you want to maintain the aspect
        titleView.contentMode = .scaleAspectFit
        titleView.image = UIImage(named: "title-image")
        
        self.navigationItem.titleView = titleView
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScrollingTransitionAnimator(tabBarController: tabBarController, lastIndex: tabBarController.selectedIndex)
    }
    class ScrollingTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        weak var transitionContext: UIViewControllerContextTransitioning?
        var tabBarController: UITabBarController!
        var lastIndex = 0
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.2
        }
        
        init(tabBarController: UITabBarController, lastIndex: Int) {
            self.tabBarController = tabBarController
            self.lastIndex = lastIndex
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            self.transitionContext = transitionContext
            
            let containerView = transitionContext.containerView
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            
            containerView.addSubview(toViewController!.view)
            
            var viewWidth = toViewController!.view.bounds.width
            
            if tabBarController.selectedIndex < lastIndex {
                viewWidth = -viewWidth
            }
            
            toViewController!.view.transform = CGAffineTransform(translationX: viewWidth, y: 0)
            
            UIView.animate(withDuration: self.transitionDuration(using: (self.transitionContext)), delay: 0.0, usingSpringWithDamping: 1.2, initialSpringVelocity: 2.5, options: .overrideInheritedOptions, animations: {
                toViewController!.view.transform = CGAffineTransform.identity
                fromViewController!.view.transform = CGAffineTransform(translationX: -viewWidth, y: 0)
            }, completion: { _ in
                self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled)
                fromViewController!.view.transform = CGAffineTransform.identity
            })
        }
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

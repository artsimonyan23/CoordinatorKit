//
//  TabRouter.swift
//
//
//  Created by Arthur on 31.05.21.
//

import UIKit

open class TabRouter {
    private let tabBarController: UITabBarController

    public var selectedViewController: UIViewController? {
        return tabBarController.selectedViewController
    }
    
    public var selectedIndex: Int {
        set {
            tabBarController.selectedIndex = newValue
        }
        get {
            tabBarController.selectedIndex
        }
    }
    
    public init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    public func present(_ module: Presentable, animated: Bool = true, completion: CompletionHandler? = nil) {
        tabBarController.present(module.toPresentable(), animated: animated, completion: completion)
    }

    public func dismissModule(animated: Bool = true, completion: CompletionHandler? = nil) {
        tabBarController.dismiss(animated: animated, completion: completion)
    }
    
    public func setModules(_ modules: [Presentable], animated: Bool = false) {
        tabBarController.setViewControllers(modules.map { $0.toPresentable() }, animated: animated)
    }
    
    public func changeModule(index: Int, with module: Presentable) {
        tabBarController.viewControllers?[index] = module.toPresentable()
    }
}

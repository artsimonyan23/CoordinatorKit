//
//  NavigationRouter.swift
//
//
//  Created by Arthur on 31.05.21.
//

import UIKit

open class NavigationRouter: NSObject {
    private var popHandlers = [UIViewController: CompletionHandler]()

    public var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }

    public var topViewController: UIViewController? {
        return navigationController.topViewController
    }

    public var visibleViewController: UIViewController? {
        return navigationController.visibleViewController
    }

    private let navigationController: UINavigationController

    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }

    public func present(_ module: Presentable, animated: Bool = true, completion: CompletionHandler? = nil) {
        navigationController.present(module.toPresentable(), animated: animated, completion: completion)
    }

    public func dismissModule(animated: Bool = true, completion: CompletionHandler? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }

    public func push(_ module: Presentable..., animated: Bool = true, completion: CompletionHandler? = nil, popHandler: CompletionHandler? = nil) {
        guard let controller = module.last?.toPresentable() else { return }

        // Avoid pushing UINavigationController onto stack
        guard !module.contains(where: { $0 is UINavigationController }) else { return }

        if let popHandler = popHandler {
            module.forEach({ popHandlers[$0.toPresentable()] = popHandler })
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.pushViewController(controller, animated: animated)
        var module = module
        module.removeLast()
        let index = navigationController.viewControllers.count - 1
        navigationController.viewControllers.insert(contentsOf: module.map({ $0.toPresentable() }), at: index)
        CATransaction.commit()
    }

    public func popModule(animated: Bool = true) {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }

    public func setRootModule(_ module: Presentable, hideBar: Bool = false, animated: Bool = false) {
        // Call all completions so all coordinators can be deallocated
        popHandlers.forEach { runCompletion(for: $0.key) }
        navigationController.setViewControllers([module.toPresentable()], animated: animated)
        navigationController.isNavigationBarHidden = hideBar
    }

    public func popToRootModule(animated: Bool) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }

    public func popToModule(_ module: Presentable, animated: Bool) {
        if let controllers = navigationController.popToViewController(module.toPresentable(), animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }

    private func runCompletion(for controller: UIViewController) {
        guard let completion = popHandlers[controller] else { return }
        completion()
        popHandlers.removeValue(forKey: controller)
    }
}

extension NavigationRouter: Presentable {
    public func toPresentable() -> UIViewController {
        return navigationController
    }
}

extension NavigationRouter: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(poppedViewController) else {
            return
        }
        runCompletion(for: poppedViewController)
    }
}

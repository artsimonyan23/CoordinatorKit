//
//  LazyCoordinatorViewController.swift
//
//
//  Created by Arthur on 31.05.21.
//

import UIKit

open class LazyCoordinatorViewController: UIViewController {
    public weak var coordinator: Coordinator?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        coordinator?.start()
    }
}

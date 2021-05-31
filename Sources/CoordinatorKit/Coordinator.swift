//
//  Coordinator.swift
//
//
//  Created by Arthur on 31.05.21.
//

import Foundation

open class Coordinator {
    private final var childCoordinators = [Coordinator]()
    public final let isFinished: CompletionHandlerWith<Coordinator>

    public init(isFinished: @escaping CompletionHandlerWith<Coordinator>) {
        self.isFinished = isFinished
    }

    open func start() {
    }

    public final func addDependency(_ coordinator: Coordinator) {
        if !childCoordinators.contains(where: { $0 === coordinator }) {
            childCoordinators.append(coordinator)
        }
    }

    public final func removeDependency(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator else { return }
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}

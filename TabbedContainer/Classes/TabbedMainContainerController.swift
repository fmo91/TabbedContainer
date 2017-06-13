//
//  TabbedMainContainerController.swift
//  Pods
//
//  Created by Fernando on 12/6/17.
//
//

import UIKit

protocol TabbedMainContainerControllerDelegate: class {
    func tabbedMainContainerControllerDidScroll(to index: Int)
}

final class TabbedMainContainerController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: - Attributes -
    private(set) public var _viewControllers: [Int: UIViewController] = [:]
    private(set) public var viewControllerCreators: [Int: () -> UIViewController] = [:]
    weak var tabDelegate: TabbedMainContainerControllerDelegate?
    private var destinationViewControllerIndex: Int = 0
    
    // MARK: - Init -
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        commonInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        self.delegate = self
        self.dataSource = self
    }
    
    // MARK: - Configuration -
    private func reset () {
        if let firstController = self.viewController(at: 0) {
            self.setViewControllers([firstController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
    }
    
    public func setControllerCreators(_ controllerCreators: [() -> UIViewController]) {
        self._viewControllers = [:]
        self.viewControllerCreators = [:]
        for (index, creator) in controllerCreators.enumerated() {
            self.viewControllerCreators[index] = creator
        }
        reset()
    }
    
    // MARK: - Utils -
    public func viewController(at index: Int) -> UIViewController? {
        if !_viewControllers.keys.contains(index) {
            if let creator = viewControllerCreators[index] {
                let controller = creator()
                controller.view.tag = index
                _viewControllers[index] = controller
            }
        }
        return _viewControllers[index]
    }
    
    // MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource -
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let destinationViewController = pendingViewControllers.first else { return }
        self.destinationViewControllerIndex = destinationViewController.view.tag
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished && completed {
            self.tabDelegate?.tabbedMainContainerControllerDidScroll(to: self.destinationViewControllerIndex)
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let tag = viewController.view.tag
        return self.viewController(at: tag - 1)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let tag = viewController.view.tag
        return self.viewController(at: tag + 1)
    }
    
}

//
//  PageViewController.swift
//
//  Created on 8/07/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @Binding var currentPage: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
            navigationOrientation: .horizontal)

        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        if let firstController = controllers.first {
            pageViewController.setViewControllers([firstController], direction: .forward, animated: true, completion: nil)
        }

        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: false)
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController

        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }

        func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }

            let previousIndex = viewControllerIndex - 1

            guard previousIndex >= 0 else {
                return parent.controllers.last
            }

            guard parent.controllers.count > previousIndex else {
                return nil
            }

            return parent.controllers[previousIndex]
        }

        func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }

            let nextIndex = viewControllerIndex + 1
            guard parent.controllers.count != nextIndex else {
                return parent.controllers.first
            }

            guard parent.controllers.count > nextIndex else {
                return nil
            }

            return parent.controllers[nextIndex]
        }

        func pageViewController(_ pageViewController: UIPageViewController,
                                didFinishAnimating finished: Bool,
                                previousViewControllers: [UIViewController],
                                transitionCompleted completed: Bool) {
            if completed {
                if let visibleViewController = pageViewController.viewControllers?.first,
                   let index = parent.controllers.firstIndex(of: visibleViewController) {
                    parent.currentPage = index
                }
            }
        }
    }
}

struct PageViewController_Previews: PreviewProvider {
    static var previews: some View {
        PageViewController(controllers: [UIHostingController(rootView: Text("First")),
                                         UIHostingController(rootView: Text("Second")),
                                         UIHostingController(rootView: Text("Third"))],
            currentPage: .constant(0))
    }
}

//
//  ContentView.swift
//  maxcodesUIVCRepresentable
//
//  Created by Max Nelson on 5/27/20.
//  Copyright © 2020 Maxcodes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct PageViewController: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource {
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = self.parent.controllers.firstIndex(of: viewController) else { return nil }
            if index == 0 {
                return self.parent.controllers.last
            }
            return self.parent.controllers[index - 1]
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = self.parent.controllers.firstIndex(of: viewController) else { return nil }
            if index == self.parent.controllers.count - 1 {
                return self.parent.controllers.first
            }
            return self.parent.controllers[index + 1]
        }
            
        
        let parent: PageViewController

        init(_ parent: PageViewController) {
            self.parent = parent
        }
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers([controllers[0]], direction: .forward, animated: true)
    }
    
    typealias UIViewControllerType = UIPageViewController
    
    var controllers: [UIViewController] = []

}

struct TitlePage: View {
    var title: String
    
    var body: some View {
        Text(title)
    }
}

struct ContainerView: View {
    
    var controllers: [UIHostingController<TitlePage>]
    
    init(_ titles: [String]) {
        self.controllers = titles.map { UIHostingController(rootView: TitlePage(title: $0)) }
    }
    
    var body: some View {
        PageViewController(controllers: self.controllers)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView(["Subscribe", "Comment", "Maxcodes.io"])
    }
}

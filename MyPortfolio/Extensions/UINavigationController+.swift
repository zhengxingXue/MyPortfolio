//
//  UINavigationController+.swift
//  UINavigationController+
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import UIKit

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

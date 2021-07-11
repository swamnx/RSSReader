//
//  UtilsUi.swift
//  RSSReader
//
//  Created by swamnx on 11.07.21.
//

import Foundation
import UIKit

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

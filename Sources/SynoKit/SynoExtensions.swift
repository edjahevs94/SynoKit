//
//  SynoExtensions.swift
//  SynoKit
//
//  Created by EdgardVS on 14/12/22.
//

import Foundation
import UIKit

extension UIImage {
    func aspectFittedToHeight( newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _  in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

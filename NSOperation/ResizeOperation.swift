//
//  ResizeOperation.swift
//  NSOperation
//

import UIKit

class ResizeImageOperation: Operation {

    enum Error {
        case fileReadError
        case resizeError
        case writeError
    }

    let targetSize: CGSize
    let path: URL
    var error: Error?

    init(size: CGSize, path: URL) {
        self.targetSize = size
        self.path = path
    }

    override func execute() {
        // Need to signal KVO notifications for operation completion
        defer {
            finish()
        }
        
        guard let sourceImage = UIImage(contentsOfFile: path.path) else {
            error = Error.fileReadError
            return
        }

        let finalWidth: CGFloat, finalHeight: CGFloat
        let ratio = sourceImage.size.width / sourceImage.size.height

        // Scale aspect fit the image
        if sourceImage.size.width >= sourceImage.size.height {
            finalWidth = targetSize.width
            finalHeight = finalWidth / ratio
        } else {
            finalHeight = targetSize.height
            finalWidth = finalHeight * ratio
        }

        let imageSize = CGSize(width: finalWidth, height: finalHeight)
        UIGraphicsBeginImageContextWithOptions(imageSize, true, 0.0)
        defer { UIGraphicsEndImageContext() }

        let rect = CGRect(origin: .zero, size: imageSize)
        sourceImage.draw(in: rect)

        guard
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext(),
            let imageData = resizedImage.jpegData(compressionQuality: 1.0)
        else {
            error = Error.resizeError
            return
        }

        do {
            try imageData.write(to: path)
        } catch {
            self.error = Error.writeError
        }
    }
}

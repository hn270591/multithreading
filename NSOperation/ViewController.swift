//
//  ViewController.swift
//  NSOperation
//
import UIKit

class ViewController: UIViewController {
    
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 100, y: 100, width: 200, height: 300)
        
        //let queue = OperationQueue()
        //queue.maxConcurrentOperationCount = 1
        //
        //let url = "https://picsum.photos/200/300"
        //loadWallpaper(queue: queue, url: url)
        
        downloadAndCacheImage()
    }

    // MARK: - Basic of Operation
    
    private func loadWallpaper(queue: OperationQueue, url: String) {
        guard let wallpaperURL = URL(string: url) else { return }

        let downloadOperation = BlockOperation {
            guard let imageData = try? Data(contentsOf: wallpaperURL) else { return }

            OperationQueue.main.addOperation { [weak self] in
                self?.imageView.image = UIImage(data: imageData)
            }
        }

        queue.addOperation(downloadOperation)
    }

    // MARK: - Download & Cache
    
    func downloadAndCacheImage() {
        if let cacheDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let targetURL = cacheDirectoryURL.appendingPathComponent("wallpaper.jpg")
            let downloadOperation = downloadWallpaper(url: URL(string: "https://picsum.photos/200/300")!, path: targetURL)

            let resizeOperation = ResizeImageOperation(size: CGSize(width: imageView.bounds.size.width * 2, height: imageView.bounds.size.height * 2), path: targetURL)
            resizeOperation.addDependency(downloadOperation)

            resizeOperation.completionBlock = { [weak self, weak resizeOperation] in
                if let error = resizeOperation?.error {
                    print(error)
                    return
                }

                guard
                    let path = resizeOperation?.path,
                    let imageData = try? Data(contentsOf: path)
                else {
                    return
                }

                OperationQueue.main.addOperation {
                    self?.imageView.image = UIImage(data: imageData)
                }
            }
            
            // Create new queue
            let wallpaperQueue = OperationQueue()

            wallpaperQueue.isSuspended = true // Do not start util all operations added
            wallpaperQueue.addOperation(downloadOperation)
            wallpaperQueue.addOperation(resizeOperation)
            wallpaperQueue.isSuspended = false // Resume queue
        }
    }
    
    // Download and cache to disk
    private func downloadWallpaper(url: URL, path: URL) -> Foundation.Operation {
        return BlockOperation {
            guard
                let imageData = try? Data(contentsOf: url),
                let image = UIImage(data: imageData)
            else { return }

            do {
                try image.jpegData(compressionQuality: 1.0)?.write(to: path)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


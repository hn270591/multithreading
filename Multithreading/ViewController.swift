//
//  ViewController.swift
//  Multithreading
//

import UIKit

class ViewController: UIViewController {
    
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 100, y: 100, width: 200, height: 300)
        
        // Download single image in background.
        // loadWallpaper()
        
        // Download list of images in background and notify.
        fetchAllWallpapers()
    }

    private func loadWallpaper() {
        /* Use GCD natively */
        //DispatchQueue.global().async {
        //    guard let wallpaperURL = URL(string: "https://picsum.photos/200/300"),
        //        let imageData = try? Data(contentsOf: wallpaperURL)
        //    else {
        //        return
        //    }
        //    DispatchQueue.main.async {
        //        self.imageView.image = UIImage(data: imageData)
        //    }
        //}
        
        /* Use Queue Wrapper */
        Queue.background.execute {
            guard let wallpaperURL = URL(string: "https://picsum.photos/200/300"),
                  let imageData = try? Data(contentsOf: wallpaperURL)
            else {
                return
            }
            
            Queue.main.execute {
                self.imageView.image = UIImage(data: imageData)
            }
        }
    }
    
    private func loadWallpaper(_ group: DispatchGroup, url: String) {
        defer {
            group.leave()
        }
        
        DispatchQueue.global().async(group: group) {
            guard let wallpaperURL = URL(string: "https://picsum.photos/200/300"),
                let _ = try? Data(contentsOf: wallpaperURL)
            else {
                // In production scenarios, we would want error handing here
                return
            }
            // Use imageData in some manner, e.g. persisting to a cache, present in view hierarchy, etc.
            print("Image downloaded \(url)")
        }
    }
    
    private func fetchAllWallpapers() {
        let urls = [
            "https://picsum.photos/200/300",
            "https://picsum.photos/200/300",
            "https://picsum.photos/200/300"
        ]
        
        let wallpaperGroup = DispatchGroup()
        
        urls.forEach {
            wallpaperGroup.enter()
            loadWallpaper(wallpaperGroup, url: $0)
        }
        
        wallpaperGroup.notify(queue: .main) {
            let alertController = UIAlertController(title: "Done!", message: "All images have downloaded", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true)
        }
    }
}


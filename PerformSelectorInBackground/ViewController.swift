//
//  ViewController.swift
//  PerformSelectorInBackground
//


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        performSelector(inBackground: #selector(sleepAndPrint(_:)), with: ["supsup", "sup"])

    }

    @objc func sleepAndPrint(_ args: [String]) {
        Thread.sleep(forTimeInterval: 1)
        print(args)
    }
}


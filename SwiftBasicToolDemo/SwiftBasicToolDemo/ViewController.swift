//
//  ViewController.swift
//  SwiftBasicToolDemo
//
//  Created by Stephen.Zeng on 2022/1/20.
//

import UIKit
import SwiftBasicTool

class ViewController: UIViewController {
    
    let ImageQueue = DispatchQueue(label: "ImageQueue", qos: .userInteractive)

    var imageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView.frame = SafeArea.screenBounds
        view.addSubview(imageView)
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        button.addTarget(self, action: #selector(self.click), for: .touchUpInside)
        button.backgroundColor = UIColor.systemRed
        view.addSubview(button)
        
        let testB = UIButton(frame: CGRect(x: 100, y: 200, width: 50, height: 50))
        testB.addTarget(self, action: #selector(self.cli), for: .touchUpInside)
        testB.backgroundColor = UIColor.systemRed
        view.addSubview(testB)
    }

    @objc
    func click() {
        DispatchQueue.global(qos: .background).async {
            var image: UIImage?
            self.ImageQueue.async {
                image = self.fetchImage()
            }
            self.ImageQueue.sync {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    @objc
    func cli() {
        print("action")
    }
    
    func fetchImage() -> UIImage? {
        if let url = URL(string: "https://w.wallhaven.cc/full/pk/wallhaven-pkgkkp.png"),
            let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }

}


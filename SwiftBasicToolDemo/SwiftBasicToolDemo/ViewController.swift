//
//  ViewController.swift
//  SwiftBasicToolDemo
//
//  Created by Stephen.Zeng on 2022/1/20.
//

import UIKit
import SwiftBasicTool

class ViewController: BaseViewController {
    
    let ImageQueue = DispatchQueue(label: "ImageQueue", qos: .userInteractive)

    var imageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        statusBarStyle = .hidden
        view.backgroundColor = UIColor.yellow
        
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: SafeArea.screenWidth, height: SafeArea.top))
        topView.backgroundColor = UIColor.systemRed
        view.addSubview(topView)
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        button.addTarget(self, action: #selector(self.click), for: .touchUpInside)
        button.backgroundColor = UIColor.systemRed
        view.addSubview(button)
        
//
//        let testB = UIButton(frame: CGRect(x: 100, y: 200, width: 50, height: 50))
//        testB.addTarget(self, action: #selector(self.cli), for: .touchUpInside)
//        testB.backgroundColor = UIColor.systemRed
//        view.addSubview(testB)
    }

    @objc
    func click() {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.systemBlue
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc
    func cli() {
        
    }

}


//
//  ViewController.swift
//  TCWebView
//
//  Created by wzh on 16/6/15.
//  Copyright © 2016年 谈超. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy private  var urlBtn: UIButton = {
        let object = UIButton()
        object.setTitle("进入百度", forState: .Normal)
        object.setTitleColor(UIColor.blueColor(), forState: .Normal)
        object.titleLabel?.font = UIFont.systemFontOfSize(13)
        object.addTarget(self, action: #selector(urldidClick), forControlEvents: .TouchUpInside)
        return object
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(urlBtn)
        urlBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: urlBtn, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: urlBtn, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: urlBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: 100))
        view.addConstraint(NSLayoutConstraint(item: urlBtn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 100))
    }
    func urldidClick() {
        let vc = TCWebViewController()
        vc.url = NSURL(string: "https://m.baidu.com")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


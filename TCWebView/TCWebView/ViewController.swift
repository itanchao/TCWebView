//
//  ViewController.swift
//  TCWebView
//
//  Created by wzh on 16/6/15.
//  Copyright © 2016年 谈超. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy fileprivate  var urlBtn: UIButton = {
        let object = UIButton()
        object.setTitle("进入百度", for: UIControlState())
        object.setTitleColor(UIColor.blue, for: UIControlState())
        object.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        object.addTarget(self, action: #selector(urldidClick), for: .touchUpInside)
        return object
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(urlBtn)
        urlBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: urlBtn, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: urlBtn, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: urlBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 100))
        view.addConstraint(NSLayoutConstraint(item: urlBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100))
    }
    func urldidClick() {
        let vc = TCWebViewController()
        vc.url = URL(string: "https://m.baidu.com")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ViewController.swift
//  TCWebView
//
//  Created by wzh on 16/6/15.
//  Copyright © 2016年 谈超. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextViewDelegate {
    lazy private  var textView: UILabel = {
        let object = UILabel()
//        object.dataDetectorTypes = .All
//        object.editable = false
//        object.scrollEnabled = false
        object.font = UIFont.systemFontOfSize(13)
        object.text = "我的GitHub主页"
        object.sizeToFit()
        return object
    }()
    lazy private  var urlBtn: UIButton = {
        let object = UIButton()
        object.setTitle("https://github.com/tankco", forState: .Normal)
        object.setTitleColor(UIColor.blueColor(), forState: .Normal)
        object.titleLabel?.font = UIFont.systemFontOfSize(13)
        object.sizeToFit()
        object.addTarget(self, action: #selector(urldidClick), forControlEvents: .TouchUpInside)
        return object
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: view,attribute: .Left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 30))
        view.addSubview(urlBtn)
        urlBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: urlBtn, attribute: .Left, relatedBy: .Equal, toItem: textView, attribute: .Right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: urlBtn, attribute: .CenterY, relatedBy: .Equal, toItem: textView, attribute: .CenterY, multiplier: 1, constant: 0))
        
    }
    func urldidClick() {
        print("ddddd")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


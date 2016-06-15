//
//  TCWebViewController.swift
//  TCWebView
//
//  Created by wzh on 16/6/15.
//  Copyright © 2016年 谈超. All rights reserved.
//

import UIKit
//protocol TCWebViewProgressDelegate:NSObjectProtocol {
//     func webViewProgress(webprogress:TCWebViewProgress, updateProgress:Double)
//}
//let completeRPCURLPath = "/tcwebviewprogressproxy/complete";
//
//let TCInteractiveProgressValue:Double = 0.5
//let TCFinalProgressValue :Double = 0.9
//class TCWebViewProgress: NSObject {
//    weak var  progressDelegate:TCWebViewProgressDelegate?
//    weak var  webViewProxyDelegate:UIWebViewDelegate?
//    var progressCallBack:((Double?)->Void)?
//    var maxLoadCount = 0.0
//    var loadingCount = 0.0
//    var interactive = false
//
//    var progress :Double{
//        set{
//            let defaults = NSUserDefaults.standardUserDefaults()
//            if newValue > progress || newValue == 0{
//                defaults.setDouble(newValue, forKey: "tcprogresskey")
//                defaults.synchronize()
//                progressDelegate?.webViewProgress(self, updateProgress: newValue)
//                    progressCallBack?(newValue)
//            }
//        }
//        get{
//            return NSUserDefaults.standardUserDefaults().doubleForKey("tcprogresskey") ?? 0
//        }
//    }
//    let TCInitialProgressValue = 0.1
//    func startProgress () {
//        if progress < TCInitialProgressValue {
//            progress = TCInitialProgressValue
//        }
//    }
//    func incrementProgress() {
//        let maxProgress = interactive ? TCFinalProgressValue:TCInteractiveProgressValue
//        let remainPercent = loadingCount/maxLoadCount
//        let increment = (maxProgress-progress)*remainPercent
//        var pro = progress+increment
//        pro = fmin(pro, maxProgress)
//        progress = pro
//    }
//    
//    
//}
//extension TCWebViewProgress:UIWebViewDelegate{
//}
class TCWebViewController: UIViewController,UIWebViewDelegate {
    var url : NSURL?{
        didSet{
            webView.loadRequest(NSURLRequest(URL: url!))
        }
    }
    var snapShotsArray : [UIView] = []
    var currentSnapShotView:UIView?
    var prevSnapShotView:UIView?
    lazy private  var swipingBackgoundView: UIView = {
        let object = UIView(frame: self.view.bounds)
        object.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return object
    }()
    var isSwipingBack = false
    lazy private  var webView: UIWebView = {
        let wbView = UIWebView(frame: self.view.bounds)
        wbView.delegate = self
        wbView.scalesPageToFit = true
        wbView.backgroundColor = UIColor.whiteColor()
        wbView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipePanGestureHandler)))
        return wbView
    }()
    func swipePanGestureHandler(panGesture:UIPanGestureRecognizer) {
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    let completeRPCURLPath = "/TCkwebviewprogressproxy/complete";
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL?.path == completeRPCURLPath {
            return false
        }
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.leftItemsSupplementBackButton = true
        view.addSubview(webView)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//    private var progressKey:String = "Copyright © 2016年 谈超. All rights reserved..navigationBarLay为了防止重复我多写了点"
//    var progress :Double{
//        set{
//            objc_setAssociatedObject(self, &progressKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
//        }
//        get{
//            return (objc_getAssociatedObject(self, &progressKey) as?Double) ?? 0.0
//        }
//    }

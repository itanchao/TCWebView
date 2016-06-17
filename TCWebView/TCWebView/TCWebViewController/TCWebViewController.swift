//
//  TCWebViewController.swift
//  TCWebView
//
//  Created by wzh on 16/6/15.
//  Copyright © 2016年 谈超. All rights reserved.
//

import UIKit
struct SnapShot{
    private var request : NSURLRequest?
    private var snapShotView : UIView?
    init(req:NSURLRequest?,snapView:UIView?){
        request = req
        snapShotView = snapView
    }
}
class TCWebViewController: UIViewController,UIWebViewDelegate {
    var url : NSURL?{
        didSet{
            webView.loadRequest(NSURLRequest(URL: url!))
        }
    }
    
    lazy private  var swipingBackgoundView: UIView = {
        let object = UIView(frame: self.view.bounds)
        object.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return object
    }()
    
    lazy private  var webView: UIWebView = {
        let wbView = UIWebView(frame: self.view.bounds)
        wbView.delegate = self
        wbView.scalesPageToFit = true
        wbView.backgroundColor = UIColor.whiteColor()
        wbView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipePanGestureHandler)))
        return wbView
    }()
    func swipePanGestureHandler(panGesture:UIPanGestureRecognizer) {
        let translation =  panGesture.translationInView(webView)
        let location = panGesture.locationInView(webView)
        switch panGesture.state {
        case .Began:
            if location.x <= 50 && translation.x > 0
            {
                startPopSnapshotView()
            }
            break
        case .Changed:
            popSnapShotViewWithPanGestureDistance(translation.x)
            break
        default:
            endPopSnapShotView()
            break
        }
    }
    var isSwipingBack : Bool = false
    var currentSnapShotView:UIView?
    var prevSnapShotView:UIView?
    func startPopSnapshotView()  {
        if isSwipingBack {return}
        if !webView.canGoBack { return }
        isSwipingBack = true
        currentSnapShotView = webView.snapshotViewAfterScreenUpdates(true)
        currentSnapShotView?.layer.shadowColor = UIColor.blackColor().CGColor
        currentSnapShotView?.layer.shadowOffset = CGSizeMake(3, 3)
        currentSnapShotView?.layer.shadowRadius = 5
        currentSnapShotView?.layer.shadowOpacity = 0.75
        var center = CGPointMake(GetboundsWidth()/2, GetboundsHeight()/2)
        currentSnapShotView?.center = center
        prevSnapShotView = snapShotsArray.last?.snapShotView
        center.x = -60
        prevSnapShotView?.center = center
        prevSnapShotView?.alpha = 1
        view.backgroundColor = UIColor.blackColor()
        view.addSubview(prevSnapShotView!)
        view.addSubview(swipingBackgoundView)
        view.addSubview(currentSnapShotView!)
    }
    func endPopSnapShotView() {
        if !isSwipingBack {return}
        view.userInteractionEnabled = false
        if currentSnapShotView?.center.x >= view.bounds.size.width {
            UIView.animateWithDuration(0.2, animations: {
                UIView.setAnimationCurve(.EaseInOut)
                
                self.currentSnapShotView?.center = CGPointMake(self.GetboundsWidth() * 3/2, self.GetboundsHeight()/2)
                self.prevSnapShotView?.center = CGPointMake(self.GetboundsWidth()/2, self.GetboundsHeight()/2)
                self.swipingBackgoundView.alpha = 0
                }, completion: { (_) in
                    self.prevSnapShotView?.removeFromSuperview()
                    self.swipingBackgoundView.removeFromSuperview()
                    self.currentSnapShotView?.removeFromSuperview()
                    self.webView.goBack()
                    self.snapShotsArray.removeLast()
                    self.view.userInteractionEnabled = true
                    self.isSwipingBack = false
            })
        }else{
        UIView.animateWithDuration(0.2, animations: { 
            self.currentSnapShotView?.center = CGPointMake(self.GetboundsWidth()/2, self.GetboundsHeight()/2)
            self.prevSnapShotView?.center = CGPointMake(self.GetboundsWidth()/2-60, self.GetboundsHeight())
            self.prevSnapShotView?.alpha = 1
            }, completion: { (_) in
                self.prevSnapShotView?.removeFromSuperview()
                self.swipingBackgoundView.removeFromSuperview()
                self.currentSnapShotView?.removeFromSuperview()
                self.view.userInteractionEnabled = true
                self.isSwipingBack = false
        })
        }
    }
    func popSnapShotViewWithPanGestureDistance(distance:CGFloat) {
        if !isSwipingBack {return}
        if distance <= 0 {return}
        var currentSnapshotViewCenter = CGPointMake(GetboundsWidth()/2, GetboundsHeight()/2)
        currentSnapshotViewCenter.x = currentSnapshotViewCenter.x + distance
        var prevSnapshotViewCenter = CGPointMake(GetboundsWidth()/2, GetboundsHeight()/2)
        prevSnapshotViewCenter.x = prevSnapshotViewCenter.x - (GetboundsWidth() - distance)*60/GetboundsWidth()
        
        currentSnapShotView!.center = currentSnapshotViewCenter
        prevSnapShotView!.center = prevSnapshotViewCenter
        swipingBackgoundView.alpha = (GetboundsWidth() - distance)/GetboundsWidth()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .LinkClicked:
            pushCurrentSnapShotViewWithRequest(request)
            break
        case .FormSubmitted:
            pushCurrentSnapShotViewWithRequest(request)
            break
        case .Other:
            pushCurrentSnapShotViewWithRequest(request)
            break
        default:
            break
        }
        updateNavigationItems()
        return true
    }
    func updateNavigationItems() {
        if webView.canGoBack {
            navigationController?.interactivePopGestureRecognizer?.enabled = false
        }else{
            navigationController?.interactivePopGestureRecognizer?.enabled = true
            
        }
    }
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        updateNavigationItems()
        let titleStr = webView.stringByEvaluatingJavaScriptFromString("document.title")! as NSString
        var titleS = titleStr as String
        if titleStr.length > 10{
            titleS = titleStr.substringToIndex(8).stringByAppendingString("...")
        }
        self.title = titleS
    }
    
    var snapShotsArray : [SnapShot] = []
    func pushCurrentSnapShotViewWithRequest(request:NSURLRequest) {
        let lastRequest = snapShotsArray.last?.request
        if request.URL?.absoluteString == "about:blank" {return}
        if lastRequest?.URL?.absoluteString == request.URL?.absoluteString {return}
        let shotView = self.webView.snapshotViewAfterScreenUpdates(true)
        snapShotsArray.append(SnapShot(req: request, snapView: shotView))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isSwipingBack = false
        title = ""
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.leftItemsSupplementBackButton = true
        url = NSURL(string: "https://m.baidu.com")
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        
        // Do any additional setup after loading the view.
    }
    private func GetboundsWidth() -> CGFloat {
        return self.view.bounds.size.width
    }
    private func GetboundsHeight() -> CGFloat {
        return self.view.bounds.size.height
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

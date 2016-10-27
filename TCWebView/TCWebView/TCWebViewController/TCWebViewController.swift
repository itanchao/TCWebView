//
//  TCWebViewController.swift
//  TCWebView
//
//  Created by wzh on 16/6/15.
//  Copyright © 2016年 谈超. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

struct SnapShot{
    var request : URLRequest?
    var snapShotView : UIView?
    init(req:URLRequest?,snapView:UIView?){
        request = req
        snapShotView = snapView
    }
}
class TCWebViewController: UIViewController {
    var url : URL?{
        didSet{
            webView.loadRequest(URLRequest(url: url!))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipePanGestureHandler)))
        isSwipingBack = false
        view.backgroundColor = UIColor.white
        navigationItem.leftItemsSupplementBackButton = true
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
    }
    @objc fileprivate func swipePanGestureHandler(_ panGesture:UIPanGestureRecognizer) {
        let translation =  panGesture.translation(in: webView)
        let location = panGesture.location(in: webView)
        switch panGesture.state {
        case .began:
            if location.x <= 50 && translation.x >= 0{startPopSnapshotView()}
            break
        case .changed:
            popSnapShotViewWithPanGestureDistance(translation.x)
            break
        default:
            endPopSnapShotView()
            break
        }
    }
    fileprivate var isSwipingBack : Bool = false
    fileprivate var currentSnapShotView:UIView?
    fileprivate var prevSnapShotView:UIView?
    fileprivate func startPopSnapshotView(){
        if isSwipingBack {return}
        if !webView.canGoBack { return }
        isSwipingBack = true
        currentSnapShotView = webView.snapshotView(afterScreenUpdates: true)
        currentSnapShotView?.layer.shadowColor = UIColor.black.cgColor
        currentSnapShotView?.layer.shadowOffset = CGSize(width: 3, height: 3)
        currentSnapShotView?.layer.shadowRadius = 5
        currentSnapShotView?.layer.shadowOpacity = 0.75
        var center = CGPoint(x: GetboundsWidth()/2, y: GetboundsHeight()/2)
        currentSnapShotView?.center = center
        prevSnapShotView = snapShotsArray.last?.snapShotView
        center.x = -60
        prevSnapShotView?.center = center
        prevSnapShotView?.alpha = 1
        view.backgroundColor = UIColor.black
        view.addSubview(prevSnapShotView!)
        view.addSubview(swipingBackgoundView)
        view.addSubview(currentSnapShotView!)
    }
    fileprivate func endPopSnapShotView() {
        if !isSwipingBack {return}
        view.isUserInteractionEnabled = false
        if currentSnapShotView?.center.x >= view.bounds.size.width {
            UIView.animate(withDuration: 0.2, animations: {
                UIView.setAnimationCurve(.easeInOut)
                
                self.currentSnapShotView?.center = CGPoint(x: self.GetboundsWidth() * 3/2, y: self.GetboundsHeight()/2)
                self.prevSnapShotView?.center = CGPoint(x: self.GetboundsWidth()/2, y: self.GetboundsHeight()/2)
                self.swipingBackgoundView.alpha = 0
                }, completion: { [unowned self](_) in
                    self.prevSnapShotView?.removeFromSuperview()
                    self.swipingBackgoundView.removeFromSuperview()
                    self.currentSnapShotView?.removeFromSuperview()
                    self.webView.goBack()
                    self.snapShotsArray.removeLast()
                    self.view.isUserInteractionEnabled = true
                    self.isSwipingBack = false
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.currentSnapShotView?.center = CGPoint(x: self.GetboundsWidth()/2, y: self.GetboundsHeight()/2)
                self.prevSnapShotView?.center = CGPoint(x: self.GetboundsWidth()/2-60, y: self.GetboundsHeight())
                self.prevSnapShotView?.alpha = 1
                }, completion: {[unowned self] (_) in
                    self.prevSnapShotView?.removeFromSuperview()
                    self.swipingBackgoundView.removeFromSuperview()
                    self.currentSnapShotView?.removeFromSuperview()
                    self.view.isUserInteractionEnabled = true
                    self.isSwipingBack = false
            })
        }
    }
    fileprivate func popSnapShotViewWithPanGestureDistance(_ distance:CGFloat) {
        if !isSwipingBack {return}
        if distance <= 0 {return}
        var currentSnapshotViewCenter = CGPoint(x: GetboundsWidth()/2, y: GetboundsHeight()/2)
        currentSnapshotViewCenter.x = currentSnapshotViewCenter.x + distance
        var prevSnapshotViewCenter = CGPoint(x: GetboundsWidth()/2, y: GetboundsHeight()/2)
        prevSnapshotViewCenter.x = prevSnapshotViewCenter.x - (GetboundsWidth() - distance)*60/GetboundsWidth()
        
        currentSnapShotView!.center = currentSnapshotViewCenter
        prevSnapShotView!.center = prevSnapshotViewCenter
        swipingBackgoundView.alpha = (GetboundsWidth() - distance)/GetboundsWidth()
    }
    fileprivate var snapShotsArray : [SnapShot] = []
    fileprivate func pushCurrentSnapShotViewWithRequest(_ request:URLRequest) {
        let lastRequest = snapShotsArray.last?.request
        if request.url?.absoluteString == "about:blank" {return}
        if lastRequest?.url?.absoluteString == request.url?.absoluteString {return}
        let shotView = self.webView.snapshotView(afterScreenUpdates: true)
        snapShotsArray.append(SnapShot(req: request, snapView: shotView))
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    fileprivate let webView:UIWebView = {
        let wbView = UIWebView()
        wbView.scalesPageToFit = true
        wbView.backgroundColor = UIColor.white
        return wbView
    }()
    lazy fileprivate  var swipingBackgoundView: UIView = {
        let object = UIView(frame: self.view.bounds)
        object.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return object
    }()
}
extension TCWebViewController:UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType{
        case .linkClicked:
            pushCurrentSnapShotViewWithRequest(request)
            break
        case .formSubmitted:
            pushCurrentSnapShotViewWithRequest(request)
            break
        case .other:
            pushCurrentSnapShotViewWithRequest(request)
            break
        default:
            break
        }
        updateNavigationItems()
        return true
    }
    fileprivate func updateNavigationItems() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = !webView.canGoBack
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        updateNavigationItems()
        let titleStr = webView.stringByEvaluatingJavaScript(from: "document.title")! as NSString
        var titleS = titleStr as String
        if titleStr.length > 10{
            titleS = titleStr.substring(to: 8) + "..."
        }
        self.title = titleS
    }
    fileprivate func GetboundsWidth() -> CGFloat {
        return self.view.bounds.size.width
    }
    fileprivate func GetboundsHeight() -> CGFloat {
        return self.view.bounds.size.height
    }
}

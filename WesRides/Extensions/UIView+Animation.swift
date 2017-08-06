
public enum SwapRootVCAnimationType {
    case Push
    case Pop
    case Present
    case Dismiss
}


extension UIWindow {
    public func swapRootViewControllerWithAnimation(newViewController:UIViewController, animationType:SwapRootVCAnimationType, completion: (() -> ())? = nil)
    {
        guard let currentViewController = rootViewController else {
            return
        }
        
        let width = currentViewController.view.frame.size.width;
        let height = currentViewController.view.frame.size.height;
        
        var newVCStartAnimationFrame: CGRect?
        var currentVCEndAnimationFrame:CGRect?
        
        var newVCAnimated = true
        
        switch animationType
        {
        case .Push:
            newVCStartAnimationFrame = CGRect(x: width, y: 0, width: width, height: height)
            currentVCEndAnimationFrame = CGRect(x: 0 - width/4, y: 0, width: width, height: height)
        case .Pop:
            currentVCEndAnimationFrame = CGRect(x: width, y: 0, width: width, height: height)
            newVCStartAnimationFrame = CGRect(x: 0 - width/4, y: 0, width: width, height: height)
            newVCAnimated = false
        case .Present:
            newVCStartAnimationFrame = CGRect(x: 0, y: height, width: width, height: height)
        case .Dismiss:
            currentVCEndAnimationFrame = CGRect(x: 0, y: height, width: width, height: height)
            newVCAnimated = false
        }
        
        newViewController.view.frame = newVCStartAnimationFrame ?? CGRect(x: 0, y: 0, width: width, height: height)
        
        addSubview(newViewController.view)
        
        if !newVCAnimated {
            bringSubview(toFront: currentViewController.view)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            if let currentVCEndAnimationFrame = currentVCEndAnimationFrame {
                currentViewController.view.frame = currentVCEndAnimationFrame
            }
            
            newViewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }, completion: { finish in
            self.rootViewController = newViewController
            completion?()
        })
        
        makeKeyAndVisible()
    }
}

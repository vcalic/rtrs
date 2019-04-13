//
//  Extensions.swift
//  RTRS
//
//  Created by Vlada Calic on 12/26/18.
//  Copyright © 2018 Byrccom. All rights reserved.
//

import UIKit

extension Result where Success == Data {
    func decoded<T: Decodable>(using decoder: JSONDecoder = .init()) throws -> T {
        let data = try get()
        return try decoder.decode(T.self, from: data)
    }
}

extension UIView {
    
    func embed(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            {
                let lc = view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
                lc.priority = UILayoutPriority(rawValue: 999)
                return lc
            }(),
            {
                let lc = view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
                lc.priority = UILayoutPriority(rawValue: 999)
                return lc
            }()
        ]
        constraints.forEach { $0.isActive = true }
    }
    
    func embedCentered(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func setBluredBackground() {
        backgroundColor = UIColor.clear
        alpha = 1
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        sendSubviewToBack(blurEffectView)
    }
    
    
    func applyShadow(offset: CGSize = CGSize(width: 0, height: 2)) {
        let layer = self.layer
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
    }
    
    func applyCurvedShadow() {
        let size = self.bounds.size
        let width = size.width
        let height = size.height
        let depth = CGFloat(11.0)
        let lessDepth = 0.8 * depth
        let curvyness = CGFloat(5)
        let radius = CGFloat(1)
        
        let path = UIBezierPath()
        // top left
        path.move(to: CGPoint(x: radius, y: height))
        // top right
        path.addLine(to: CGPoint(x: width - 2*radius, y: height))
        // bottom right + a little extra
        path.addLine(to: CGPoint(x: width - 2*radius, y: height + depth))
        // path to bottom left via curve
        path.addCurve(to: CGPoint(x: radius, y: height + depth),
                      controlPoint1: CGPoint(x: width - curvyness, y: height + lessDepth - curvyness),
                      controlPoint2: CGPoint(x: curvyness, y: height + lessDepth - curvyness))
        
        let layer = self.layer
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: 0, height: -3)
    }
    
    func applyHoverShadow() {
        let size = self.bounds.size
        let width = size.width
        let height = size.height
        
        let ovalRect = CGRect(x: 5, y: height + 5, width: width - 10, height: 15)
        let path = UIBezierPath(roundedRect: ovalRect, cornerRadius: 10)
        
        let layer = self.layer
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

extension UIViewController {
    
    public typealias LayoutBlock = (UIView, UIView) -> Void
    
    func embed<T>(viewController vc: T) where  T: UIViewController {
        addChild(vc)
        view.embed(view: vc.view)
        vc.didMove(toParent: self)
    }
    
    public func embed<T>(controller vc: T, into parentView: UIView?, layout: LayoutBlock = {
        v, pv in
        
        let constraints: [NSLayoutConstraint] = [
            v.topAnchor.constraint(equalTo: pv.topAnchor),
            v.leadingAnchor.constraint(equalTo: pv.leadingAnchor),
            {
                let lc = v.bottomAnchor.constraint(equalTo: pv.bottomAnchor)
                lc.priority = UILayoutPriority(rawValue: 999)
                return lc
            }(),
            {
                let lc = v.trailingAnchor.constraint(equalTo: pv.trailingAnchor)
                lc.priority = UILayoutPriority(rawValue: 999)
                return lc
            }()
        ]
        constraints.forEach { $0.isActive = true }
        })
        where T: UIViewController
    {
        let container = parentView ?? self.view!
        
        addChild(vc)
        container.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        layout(vc.view, container)
        vc.didMove(toParent: self)
        
        //    Note: after this, save the controller reference
        //    somewhere in calling scope
    }
    
    public func unembed(controller: UIViewController?) {
        guard let controller = controller else { return }
        
        controller.willMove(toParent: nil)
        if controller.isViewLoaded {
            controller.view.removeFromSuperview()
        }
        controller.removeFromParent()
        
        //    Note: don't forget to nullify your own controller instance
        //    in order to clear it out from memory
    }
}

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
    
    ///    Scroll so `rect` is just visible (nearest edges). Does nothing if rect completely visible.
    ///    If `rect` is larger than available bounds, then it scrolls so the top edge stays visible.
    open func scrollTopRectToVisible(_ rect: CGRect, animated: Bool) {
        let visibleRect = self.bounds
        let diff = rect.height - visibleRect.height
        if diff < 0 {
            scrollRectToVisible(rect, animated: true)
            return
        }
        
        let diffY = rect.minY - visibleRect.minY
        var offset = contentOffset
        offset.y += diffY
        setContentOffset(offset, animated: animated)
    }

}

extension String {
    
    var urlValue: URL? {
        if let url = URL(string: self) {
            return url
        }
        if let helper = urlEscape(),
            let url = URL(string: helper) {
            return url
        }
        return nil
    }
    
    private func urlEscape() -> String? {
        return (self as NSString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

}

extension Data {
    var stringValue: String {
        if let retval = String(data: self, encoding: .utf8) {
            return retval
        } else {
            return ""
        }
    }
    var string: String? {
        return NSString(data: self,
                        encoding: String.Encoding.utf8.rawValue) as String?
    }

}

extension Bundle {
    public static var appName: String {
        guard let str = main.object(forInfoDictionaryKey: "CFBundleName") as? String else { return "" }
        return str
    }
    
    public static var appVersion: String {
        guard let str = main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return "" }
        return str
    }
    
    public static var appBuild: String {
        guard let str = main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else { return "" }
        return str
    }
    
    public static var identifier: String {
        guard let str = main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String else { return "" }
        return str
    }
}

extension UIFont {
    public func withSize(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: self.fontName, size: fontSize)!
    }
    
    public func withSizeScaled(_ scale: CGFloat) -> UIFont {
        return UIFont(name: self.fontName, size: floor(self.pointSize * scale))!
    }
    
    public static func listAvailableFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            
            for names in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        if !Scanner(string: hexSanitized).scanHexInt32(&rgb) { return nil }
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        if length == 6 {    //RGB
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {    //    RGBa
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        /*
         The string format specifier may need an explanation.
         You can break it down into several components.
         * % defines the format specifier
         * 02 defines the length of the string
         * l casts the value to an unsigned long
         * X prints the value in hexadecimal (0–9 and A-F)
         */
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    var toHex: String? {
        return toHex()
    }
}

extension UIAlertController {
    static func present(title: String?, message: String?, tintColor: UIColor? = nil, from controller: UIViewController? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        ac.addAction(ok)
        
        if let tintColor = tintColor {
            ac.view.tintColor = tintColor
        }
        
        let c = controller ?? UIApplication.shared.keyWindow?.rootViewController
        c?.present(ac, animated: true, completion: nil)
    }
}


infix operator =~
func =~(string:String, regex:String) -> Bool {
    return string.range(of: regex, options: .regularExpression) != nil
}

extension URL {
    func appendQueryString(_ query: [String:String]) -> URL {
        var comps = URLComponents(url: self, resolvingAgainstBaseURL: false)
        var queryItems : [URLQueryItem] = []
        for (key, value)in query {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        comps?.queryItems = queryItems
        return comps!.url!
    }
    func html(withTitle title: String) -> String {
        return #"<a href="\#(absoluteString)">\#(title)</a>"#
    }

    var queryDictionary: [String: String]? {
            guard let query = self.query else { return nil}
            
            var queryStrings = [String: String]()
            for pair in query.components(separatedBy: "&") {
                
                let key = pair.components(separatedBy: "=")[0]
                
                let value = pair
                    .components(separatedBy:"=")[1]
                    .replacingOccurrences(of: "+", with: " ")
                    .removingPercentEncoding ?? ""
                
                queryStrings[key] = value
            }
            return queryStrings
        }
}

extension Dictionary {
    var jsonValue : String {
        get {
            do {
                let data = try JSONSerialization.data(withJSONObject: self as AnyObject, options: [])
                let retstring = NSString(data:data, encoding: String.Encoding.utf8.rawValue)
                if let final = retstring {
                    return final as String
                } else {
                    return "{}"
                }
            } catch {
                NSLog("Error serializing hbsjson")
                return "{}"
            }
            
        }
    }
}

extension UIButton {
    
    /*
     * Odavde...
     * http://stackoverflow.com/questions/4564621/aligning-text-and-image-on-uibutton-with-imageedgeinsets-and-titleedgeinsets?rq=1
     */
    
    func centerButtonAndImage(_ spacing:CGFloat) {
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
    }
    
}

extension Date {
    func isoString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.string(from: self)
    }
    func string(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}

extension Optional {
    func or(_ err: Error) throws -> Wrapped {
        guard let value = self else {
            throw err
        }
        return value
    }
}

infix operator ?!: NilCoalescingPrecedence
public func ?!<A>(lhs: A?, rhs: Error) throws -> A {
    guard let value = lhs else {
        throw rhs
    }
    return value
}
/*
 struct OptionalError: Error {}
    do {
        let v = try value ?! OptionalError()
        print(v)
 } catch {
    print(error)
 }
 */
 
 
public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block:() -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

/* Sundell */
extension String.StringInterpolation {
    mutating func appendInterpolation<T>(unwrapping optional: T?) {
        let string = optional.map { "\($0)" } ?? ""
        appendLiteral(string)
    }
    mutating func appendInterpolation(linkTo url: URL,
                                      _ title: String) {
        let string = url.html(withTitle: title)
        appendLiteral(string)
    }
}


/* https://dev.to/tattn/my-favorite--swift-extensions-8g7 */

protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    public static var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}


extension UITableView {
    public func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    
    public func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}
/* Example */
/*
 tableView.register(cellType: MyCell.self)
 tableView.register(cellTypes: [MyCell1.self, MyCell2.self])
 
 let cell = tableView.dequeueReusableCell(with: MyCell.self, for: indexPath)
 */



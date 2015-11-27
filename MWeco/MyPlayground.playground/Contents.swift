//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let url = NSURL(string: "www.baidu.com?code=1234124&pas=123")

let queries = url?.query?.componentsSeparatedByString("&")
var queryDic = [String: String]()
for query in queries ?? [] {
    let pair = query.componentsSeparatedByString("=") ?? []
    queryDic[pair.first ?? ""] = pair.last ?? ""
}

queryDic
"<a xxx>iPhone 6</a>".componentsSeparatedByString(">")[1].componentsSeparatedByString("<")[0]

let src = "http://ww3.sinaimg.cn/large/b285e14ajw1eychiprlgqj22bc0t51ky.jpg"


func generatePicturePath(withType type: String, andSrc src: String) -> String {
    var path = ""
    var components = NSString(string: src).pathComponents
    if components.count >= 4 {
        path = "\(components[0])//\(components[1])/\(type)/\(components[3])"
    }
    return path
}

generatePicturePath(withType: "origin", andSrc: src)
generatePicturePath(withType: "thumb", andSrc: src)
generatePicturePath(withType: "bmiddle", andSrc: src)

var button = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
button.backgroundColor = UIColor.yellowColor()
button.layer.cornerRadius = 37.5
button.clipsToBounds = true
button
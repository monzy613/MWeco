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
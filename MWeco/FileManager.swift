
//
//  FileManager.swift
//  M_fm
//
//  Created by 张逸 on 16/4/12.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import Foundation

class DBFileManager {
    static private let fileManager = NSFileManager.defaultManager()
    static private let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]

    static var musicPaths = [String]()
    static var musicFilenames: [String] {
        get {
            return DBFileManager.musicPaths.map({ (element) -> String in
                return (element as NSString).lastPathComponent
            })
        }
    }
    static var musicSHA256s: [String] {
        get {
            return DBFileManager.musicFilenames.map({ (element) -> String in
                return element.componentsSeparatedByString(".")[0]
            })
        }
    }

    class func getMP3FilePath() -> [String] {
        DBFileManager.musicPaths = [String]()
        var filenames = [String]()
        do {
            filenames = try fileManager.contentsOfDirectoryAtPath(directoryURL.path!)
        } catch {
            print("getMP3FilePath: \(error)")
        }
        for filename in filenames {
            if DBFileManager.isExtension(equalTo: "mp3", filename: filename) {
                let filePath = "\(directoryURL.path!)/\(filename)"
                DBFileManager.musicPaths.append(filePath)
            }
        }
        return DBFileManager.musicPaths
    }

    private class func isExtension(equalTo ext: String, filename: String) -> Bool {
        let fileExtName = (filename as NSString).pathExtension.lowercaseString
        return fileExtName == ext.lowercaseString
    }
}
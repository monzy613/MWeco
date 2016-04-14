//
//  DBSongList.swift
//  M_fm
//
//  Created by 张逸 on 16/4/11.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit

/*
 
 "album": "/subject/7153475/",
 "picture": "http://img3.douban.com/lpic/s7022222.jpg",
 "ssid": "cd19",
 "artist": "Herman's Hermits",
 "url": "http://mr3.douban.com/201406201304/a687b5d793bb3233e243f05a3e502b20/view/song/small/p2087018.mp3",
 "company": "Warner",
 "title": "Smile Please",
 "rating_avg": 0,
 "length": 165,
 "subtype": "",
 "public_time": "2004",
 "songlists_count": 0,
 "sid": "2087018",
 "aid": "7153475",
 "sha256": "5f6ba79e1463c1b54d0be17d090d4ee09d55121a91905ddd2217b0ba458ca7a2",
 "kbps": "64",
 "albumtitle": "The Best of",
 "like": "0"
 */

class DBSong: AnyObject {
    let album: String
    let pictureURL: String
    let ssid: String
    let artist: String
    let mp3URL: String
    let company: String
    let title: String
    let rating_abv: Int
    let length: Int
    let subtype: String
    let public_time: String
    let songlists_count: Int
    let sid: String
    let aid: String
    let sha256: String
    let kbps: String
    let albumtitle: String
    let like: Bool

    var filePath: String = ""

    init(withJSON json: JSON) {
        album = json["album"].string ?? ""
        pictureURL = json["picture"].string ?? ""
        ssid = json["ssid"].string ?? ""
        artist = json["artist"].string ?? ""
        mp3URL = json["url"].string ?? ""
        company = json["company"].string ?? ""
        title = json["title"].string ?? ""
        rating_abv = json["rating_abv"].int ?? 0
        length = json["length"].int ?? 0
        subtype = json["subtype"].string ?? ""
        public_time = json["public_time"].string ?? ""
        songlists_count = json["songlists_count"].int ?? 0
        sid = json["sid"].string ?? ""
        aid = json["aid"].string ?? ""
        sha256 = json["sha256"].string ?? ""
        kbps = json["kbps"].string ?? "0"
        albumtitle = json["albumtitle"].string ?? ""
        if let like = json["like"].string {
            if like == "0" {
                self.like = false
            } else {
                self.like = true
            }
        } else {
            self.like = false
        }
    }
}

class DBSongList: AnyObject {
    var songs = [DBSong]()
    init(withJSON json: JSON) {
        if let songs = json["song"].array {
            for song in songs {
                let dbSong = DBSong(withJSON: song)
                self.songs.append(dbSong)
            }
        }
    }
}

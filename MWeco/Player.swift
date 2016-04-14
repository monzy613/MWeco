//
//  Player.swift
//  M_fm
//
//  Created by 张逸 on 16/4/12.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import Foundation
import AVFoundation

class DBPlayer:NSObject, AVAudioPlayerDelegate {
    static var sharedPlayer: DBPlayer = DBPlayer()
    var player: AVAudioPlayer?

    private override init() {
        super.init()
    }

    func playMP3File(withFilePath filePath: String) {
        if player != nil {
            player = nil
        }
        let url = NSURL.fileURLWithPath(filePath)
        do {
            self.player = try AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("play error: \(error)")
        }
        player?.delegate = self
        player?.prepareToPlay()
        player?.play()
    }
}
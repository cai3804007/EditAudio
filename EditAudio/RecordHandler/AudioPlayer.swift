//
//  AudioPlayer.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/20.
//

import AVFoundation
class SeanAudioPlayer {
    var audioPlayer: AVAudioPlayer?
    var isPlaying: Bool { audioPlayer?.isPlaying ?? false }
    func setupPlayer(with url: URL) { //创建播放器
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
    }
    func play(currentTime: Double) { // 指定位置开始播放
        audioPlayer?.currentTime = currentTime
        audioPlayer?.play()
    }
    func pause() { // 暂停
        audioPlayer?.pause()
    }
}

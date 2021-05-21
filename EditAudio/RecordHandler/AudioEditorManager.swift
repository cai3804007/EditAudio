//
//  AudioEditorManager.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/20.
//

import Foundation
import AVFoundation
class AudioEditorManager {
    let editFileName = "editedAudio.m4a" // 编辑后的文件名
    var editFileUrl: URL? // 保存编辑后的文件URL
    let originalUrl: URL // 收录的原始文件
    var amplitudes: [Float] // 获得的波形
    
    var audioPlayer = SeanAudioPlayer()
    var fileManager = RecorderFileHandler()
    var editHandler = AudioEditorHandler()
    
    // 获得的振幅的时间间隔
    let timeInterval: Double = 0.1
    // 一秒的宽度
    let oneSecoundWidth: CGFloat = 20
    // 收录时间
    var totalTime: Double {
        Double(amplitudes.count) * timeInterval
    }
    // 收录时间的text
    var totalTimeText: String {
        let time = timeText(time: totalTime)
        return "/ " + time.minute + time.second + time.millisecond
    }
    
    var isPlaying: Bool { audioPlayer.isPlaying }
    
    init(amplitudes: [Float], originalUrl: URL) {
        self.originalUrl = originalUrl
        self.amplitudes = amplitudes
        audioPlayer.setupPlayer(with: originalUrl)
    }
    
    //在编辑栏中编辑指定的时间
    func edit(
        leftTime: Double, // 左栏的编辑时间
        rightime: Double, // 右栏的编辑时间
        completion: @escaping (Result<Range<Int>, Error>) -> Void
    ) {
        
        // 每0.1秒就会得到一个波形，所以可以把它圆起来。
        // ex) leftTime: 15.175 → 15.2
        //     rightTime: 18.20 → 18.2
        let roundedLeft = round(leftTime * 10) / 10
        let roundedRight = round(rightime * 10) / 10
        
        //时间范围(左)
        // ex) 0到152 / 10
        let leftTimeRange = CMTimeRangeFromTimeToTime(
            CMTime(value: Int64(0*10), timescale: 10),
            CMTime(value: Int64(roundedLeft*10), timescale: 10)
        )
        //时间范围(右)
        // ex) 182 / 10开始收录时间
        let rightTimeRange = CMTimeRangeFromTimeToTime(
            CMTime(value: Int64(roundedRight*10), timescale: 10),
            CMTime(value: Int64(totalTime*10), timescale: 10)
        )
        
        //准备 导出的文件
        fileManager.removeFile(fileName: editFileName)
        let exportFileUrl = fileManager.fileUrl(fileName: editFileName)!
        
        // 编辑指定的时间范围
        editHandler.edit(
            originUrl: originalUrl, exportFileUrl: exportFileUrl,
            timeRanges: [leftTimeRange, rightTimeRange]
        ) { result in
            switch result {
            case let .success(url):
                self.editFileUrl = url
                // 将编辑后的文件重新设定为播放器
                self.audioPlayer.setupPlayer(with: url)
                // 编辑范围
                let removeRange = Int(roundedLeft * 10)..<Int(roundedRight * 10)
                // 去除编辑范围，在UI中也反映去除的编辑范围
                self.amplitudes.removeSubrange(removeRange)
                completion(.success(removeRange))
            case let .failure(error):
                completion(.failure(error))
            }
        }
        
    }
    
    func play(currentTime: Double) {
        audioPlayer.play(currentTime: currentTime)
    }
    
    func pause() {
        audioPlayer.pause()
    }
    
    // 计程表上的时间
    func meterTime(index: Int) -> String {
        let time = Float(index * 5)
        let minute = Int(time / 60)
        let second = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minute, second)
    }
    
    // 现在时间
    func timeText(time: Double) -> (minute: String, second: String, millisecond: String) {
        let minute = Int(time / 60)
        let second = Int(time.truncatingRemainder(dividingBy: 60))
        let millisecond = Int((time - Double(minute * 60) - Double(second)) * 100.0)
        return (
            minute: String(format: "%02d:", minute),
            second: String(format: "%02d.", second),
            millisecond: String(format: "%02d", millisecond)
        )
    }
}




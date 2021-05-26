//
//  AudioEditorHandler.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/20.
//
import AVFoundation
class AudioEditorHandler {
    // 编辑从原始中指定的时间，并返回编辑后的URL
    func edit(
        originUrl: URL, // 收录的文件
        exportFileUrl: URL, // 编辑后导出的文件
        timeRanges: [CMTimeRange], // 删除部分以外的时间范围
        fileType: AVFileType = .m4a, //文件类型
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        
        // 取得收录文件的Track
        let originAsset = AVURLAsset(url: originUrl)
        let originTrack = originAsset.tracks(withMediaType: .audio).first!
        
        // 准备好新的Track
        let composition = AVMutableComposition()
        let editTrack = composition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: kCMPersistentTrackID_Invalid
        )!
        
        // 从收录的轨道中删除部分以外追加到新轨道
        var nextStartTime: CMTime = kCMTimeZero
        timeRanges.forEach { timeRange in
            try! editTrack.insertTimeRange(
                timeRange, of: originTrack, at: nextStartTime
            )
            nextStartTime = CMTimeAdd(nextStartTime, timeRange.duration)
        }
        
        // 准备exportSession，导出编辑后的文件
        let exportSession = AVAssetExportSession(
            asset: composition,
            presetName: AVAssetExportPresetAppleM4A
        )!
        exportSession.outputURL = exportFileUrl
        exportSession.outputFileType = fileType
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(.success(exportFileUrl))
            default:
                completion(.failure(exportSession.error!))
            }
        }
    }
    
    
    // 编辑从原始中指定的时间，并返回编辑后的URL
    func editSaveCenter(
        originUrl: URL, // 收录的文件
        exportFileUrl: URL, // 编辑后导出的文件
        timeRanges: [CMTime], // 删除部分以外的时间范围
        fileType: AVFileType = .m4a, //文件类型
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        
        let originAsset = AVURLAsset(url: originUrl)
        let exportSession = AVAssetExportSession(
            asset: originAsset,
            presetName: AVAssetExportPresetAppleM4A
        )!
        exportSession.outputURL = exportFileUrl
        exportSession.outputFileType = fileType
        exportSession.timeRange = CMTimeRange(start: timeRanges.first ?? kCMTimeZero, end: timeRanges.last ?? kCMTimeZero)

        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(.success(exportFileUrl))
            default:
                completion(.failure(exportSession.error!))
            }
        }
        
        
        
        
        // 取得收录文件的Track
//        let originAsset = AVURLAsset(url: originUrl)
//        let originTrack = originAsset.tracks(withMediaType: .audio).first!
        
        // 准备好新的Track
//        let composition = AVMutableComposition()
//        let editTrack = composition.addMutableTrack(
//            withMediaType: .audio,
//            preferredTrackID: kCMPersistentTrackID_Invalid
//        )!
        
        // 从收录的轨道中删除部分以外追加到新轨道
//        var nextStartTime: CMTime = kCMTimeZero
//        timeRanges.forEach { timeRange in
//            try! editTrack.insertTimeRange(
//                timeRange, of: originTrack, at: nextStartTime
//            )
//            nextStartTime = CMTimeAdd(nextStartTime, timeRange.duration)
//        }
        
        // 准备exportSession，导出编辑后的文件
     
        
      
    }
    
    
    
    
    
}


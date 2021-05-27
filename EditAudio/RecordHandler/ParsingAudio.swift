//
//  ParsingAudio.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/27.
//

import UIKit
import AVFoundation
class ParsingAudio: NSObject {
 
//    func getRecorderData(from url: URL?) -> Data? {
//
//        var data = Data() //用于保存音频数据
//        var asset: AVAsset? = nil
//        if let url = url {
//            asset = AVAsset(url: url)
//        } //获取文件
//
//        var error: Error?
//        var reader: AVAssetReader? = nil
//        do {
//            if let asset = asset {
//                reader = try AVAssetReader(asset: asset)
//            }
//        } catch {
//
//            print("\(error.localizedDescription ?? "")")
//        } //创建读取
//
//        let track = asset?.tracks(withMediaType: .audio).first //从媒体中得到声音轨道
//        //读取配置
//        let dic = [
//            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),
//            AVLinearPCMIsBigEndianKey: NSNumber(value: false),
//            AVLinearPCMIsFloatKey: NSNumber(value: false),
//            AVLinearPCMBitDepthKey: NSNumber(value: 16)
//        ]
//        //读取输出，在相应的轨道和输出对应格式的数据
//        var output: AVAssetReaderTrackOutput? = nil
//        if let track = track {
//            output = AVAssetReaderTrackOutput(track: track, outputSettings: dic)
//        }
//        //赋给读取并开启读取
//        if let output = output {
//            reader?.add(output)
//        }
//        reader?.startReading()
//
//        //读取是一个持续的过程，每次只读取后面对应的大小的数据。当读取的状态发生改变时，其status属性会发生对应的改变，我们可以凭此判断是否完成文件读取
//        while reader?.status == .reading {
//
//            let sampleBuffer = output?.copyNextSampleBuffer() //读取到数据
//              if let sampleBuffer = sampleBuffer {
//
//                  let blockBUfferRef = CMSampleBufferGetDataBuffer(sampleBuffer) //取出数据
//                  var length: size_t? = nil
//                  if let blockBUfferRef = blockBUfferRef {
//                      length = CMBlockBufferGetDataLength(blockBUfferRef)
//                  } //返回一个大小，size_t针对不同的品台有不同的实现，扩展性更好
//                let sampleBytes = [SInt16 *//;(repeating: , length)
//                  if let blockBUfferRef = blockBUfferRef {
//                      CMBlockBufferCopyDataBytes(blockBUfferRef, atOffset: 0, dataLength: length ?? 0, destination: &sampleBytes)
//                  } //将数据放入数组
//                  data.append(&sampleBytes, length: length ?? 0) //将数据附加到data中
//                  CMSampleBufferInvalidate(sampleBuffer) //销毁
//                   //释放
//              }
//          }
//        if reader?.status == .completed {
//
//              //        self.audioData = data;
//          } else {
//
//              print("获取音频数据失败")
//              return nil
//          }
//
//          //开始绘制波形图，重写了draw方法
//          return data
//
//    
    
}

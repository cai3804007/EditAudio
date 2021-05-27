//
//  ParsingAudioHander.m
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/27.
//

#import "ParsingAudioHander.h"
#import <AVFoundation/AVFoundation.h>

@interface ParsingAudioHander()

@property (nonatomic,copy) NSURL *url;
@property (nonatomic,strong) NSMutableData *audioData;
@property (nonatomic,assign) CMTime assetTime;
@end



@implementation ParsingAudioHander
- (NSArray *)getRecorderDataFromURL:(NSURL *)url {
    self.url = url;
    NSMutableData *data = [[NSMutableData alloc]init];     //用于保存音频数据
    AVAsset *asset = [AVAsset assetWithURL:url];           //获取文件
  
    NSError *error;
    AVAssetReader *reader = [[AVAssetReader alloc]initWithAsset:asset error:&error]; //创建读取
    if (!reader) {
        
        NSLog(@"%@",[error localizedDescription]);
    }
    
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];//从媒体中得到声音轨道
    //读取配置
    NSDictionary *dic   = @{AVFormatIDKey            :@(kAudioFormatLinearPCM),
                            AVLinearPCMIsBigEndianKey:@NO,
                            AVLinearPCMIsFloatKey    :@NO,
                            AVLinearPCMBitDepthKey   :@(16)
                            };
    //读取输出，在相应的轨道和输出对应格式的数据
    AVAssetReaderTrackOutput *output = [[AVAssetReaderTrackOutput alloc]initWithTrack:track outputSettings:dic];
    //赋给读取并开启读取
    [reader addOutput:output];
    [reader startReading];
    
    //读取是一个持续的过程，每次只读取后面对应的大小的数据。当读取的状态发生改变时，其status属性会发生对应的改变，我们可以凭此判断是否完成文件读取
    while (reader.status == AVAssetReaderStatusReading) {
        
        CMSampleBufferRef  sampleBuffer = [output copyNextSampleBuffer]; //读取到数据
        
//        recorder?.averagePower(forChannel: 0) ?? 0
        
        if (sampleBuffer) {
            
            CMBlockBufferRef blockBUfferRef = CMSampleBufferGetDataBuffer(sampleBuffer);//取出数据
            size_t length = CMBlockBufferGetDataLength(blockBUfferRef);   //返回一个大小，size_t针对不同的品台有不同的实现，扩展性更好
            SInt16 sampleBytes[length];
            CMBlockBufferCopyDataBytes(blockBUfferRef, 0, length, sampleBytes); //将数据放入数组
            [data appendBytes:sampleBytes length:length];                 //将数据附加到data中
            CMSampleBufferInvalidate(sampleBuffer);  //销毁
            CFRelease(sampleBuffer);                 //释放
        }
    }
    
  
    
    if (reader.status == AVAssetReaderStatusCompleted) {
        
        self.audioData = data;
        self.assetTime = asset.duration;
        float duroin = CMTimeGetSeconds(self.assetTime);
        CGFloat width = duroin * 20;
        return [self cutAudioData:CGSizeMake(width, 1)];
    }else{
        
        NSLog(@"获取音频数据失败");
        return nil;
    }
    
}


//缩减音频 (size为将要绘制波纹的view的尺寸，不需要请忽略)
- (NSArray *)cutAudioData:(CGSize)size {
    NSMutableArray *filteredSamplesMA = [[NSMutableArray alloc]init];
//    NSData *data = [self getRecorderDataFromURL:self.url];
    NSData *data = self.audioData;
    NSUInteger sampleCount = data.length / sizeof(SInt16);//计算所有数据个数
    //需要的个数
    int count = CMTimeGetSeconds(self.assetTime) * 10;
    
    NSUInteger binSize = sampleCount / count; //将数据分割为一个个小包
    
    SInt16 *bytes = (SInt16 *)self.audioData.bytes; //总的数据个数
    SInt16 maxSample = 0; //sint16两个字节的空间
    //以binSize为一个样本。每个样本中取一个最大数。也就是在固定范围取一个最大的数据保存，达到缩减目的
    for (NSUInteger i= 0; i < sampleCount; i += binSize) {
        //在sampleCount（所有数据）个数据中抽样，抽样方法为在binSize个数据为一个样本，在样本中选取一个数据
        SInt16 sampleBin[binSize];
        for (NSUInteger j = 0; j < binSize; j++) {//先将每次抽样样本的binSize个数据遍历出来
            
            sampleBin[j] = CFSwapInt16LittleToHost(bytes[i + j]);
            
        }
        //选取样本数据中最大的一个数据
        SInt16 value = [self maxValueInArray:sampleBin ofSize:binSize];
        //保存数据
        [filteredSamplesMA addObject:@(value)];
        //将所有数据中的最大数据保存，作为一个参考。可以根据情况对所有数据进行“缩放”
        if (value > maxSample) {
            maxSample = value;
        }
    }
    //计算比例因子
    CGFloat scaleFactor = (size.height * 0.5)/maxSample;
    //对所有数据进行“缩放”
    for (NSUInteger i = 0; i < filteredSamplesMA.count; i++) {
        
        filteredSamplesMA[i] = @([filteredSamplesMA[i] integerValue] * scaleFactor);
    }
    
    return filteredSamplesMA;
}

//比较大小的方法，返回最大值
- (SInt16)maxValueInArray:(SInt16[])values ofSize:(NSUInteger)size {
    SInt16 maxvalue = 0;
    for (int i = 0; i < size; i++) {
        
        if (abs(values[i] > maxvalue)) {
            
            maxvalue = abs(values[i]);
        }
    }
    return maxvalue;
}
@end

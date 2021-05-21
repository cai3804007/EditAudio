//
//  EditRecorderViewController.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/20.
//

import UIKit

class EditRecorderViewController: UIViewController {
    
    @IBOutlet weak var minuteTimeLabel: UILabel!
    @IBOutlet weak var secondTimeLabel: UILabel!
    @IBOutlet weak var millisecondTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    
    
    
    // 音频编辑经理
    let editorManager: AudioEditorManager
    // 振幅
    var amplitudes: [Float] { editorManager.amplitudes }
    // 时间间隔的宽度(0.1秒的宽度)
    let meterWidth: CGFloat = 2
    // 一秒的宽度
    let oneSecoundWidth: CGFloat = 20
    // 5秒
    let fiveSecond = 5

    //波形显示的内容的高度
    var collectionViewHeight: CGFloat { 150.0 }
    // 头刀的宽度(屏幕宽度的一半)
    var spaceWidth: CGFloat {
        UIScreen.main.bounds.width / 2
    }
    // 显示所收录的波形的总宽度
    var waveContentViewWidth: CGFloat {
        CGFloat(amplitudes.count) * meterWidth
    }
    // 滚动的整体width
    var contentViewWidth: CGFloat {
        waveContentViewWidth + spaceWidth * 2
    }
    // 収録時間
    var totalTime: Double {
        editorManager.totalTime
    }
    // 左边编辑栏的时间
    var leftEditBarTime: Double {
        let leftTime = (leftEditBarLeading.constant - spaceWidth) / oneSecoundWidth
        return max(0, min(Double(leftTime), totalTime))
    }
    // 右边的编辑栏的时间
    var rightEditBarTime: Double {
        let rightTime = (contentViewWidth - rightEditBarTrailing.constant - spaceWidth - meterWidth) / oneSecoundWidth
        return max(0, min(Double(rightTime), totalTime))
    }
    
    //播放的计时器
    var playerTimer: Timer?
   
    
    enum CollectionType: Int, CaseIterable {
        case decibel
        case time
    }
    var collectionTypes: [CollectionType] = CollectionType.allCases
    
    @IBOutlet weak var waveCollectionView: UICollectionView!{
        didSet {
            waveCollectionView.tag = CollectionType.decibel.rawValue
            waveCollectionView.dataSource = self
            waveCollectionView.delegate = self
            waveCollectionView.showsHorizontalScrollIndicator = false
            
            waveCollectionView.registerForNib(WaveWithMeterCollectionViewCell.self)
        }
    }
    
    @IBOutlet weak var timeCollectionView: UICollectionView!{
        didSet {
            timeCollectionView.tag = CollectionType.time.rawValue
            timeCollectionView.dataSource = self
            timeCollectionView.delegate = self
            timeCollectionView.showsHorizontalScrollIndicator = false
            timeCollectionView.isScrollEnabled = false
            waveCollectionView.registerForNib(TimeCollectionViewCell.self)

        }
    }
    
    @IBOutlet weak var leftEditBarLeading: NSLayoutConstraint!{
        didSet {
            leftEditBarLeading.constant = spaceWidth
        }
    }
    
    @IBOutlet weak var rightEditBarTrailing: NSLayoutConstraint!{
        didSet {
            rightEditBarTrailing.constant = spaceWidth - meterWidth
        }
    }
    
    @IBOutlet weak var editEreaScrollView: UIScrollView!{
        didSet {
            editEreaScrollView.delegate = self
            editEreaScrollView.showsHorizontalScrollIndicator = false
        }
    }
    
    
    @IBOutlet weak var editBarScrollView: UIScrollView! {
        didSet {
            editBarScrollView.delegate = self
            editBarScrollView.showsHorizontalScrollIndicator = false
        }
    }
    
    
    init(amplitudes: [Float], originalUrl: URL) {
        self.editorManager = AudioEditorManager(
            amplitudes: amplitudes,
            originalUrl: originalUrl
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func setupCurrentTime() {
        //当前滚动位置/ 20px(1秒宽度)
        let currentTime = editBarScrollView.contentOffset.x / oneSecoundWidth
        // 控制当前时间不超过收录时间
        let time = max(0, min(Double(currentTime), totalTime))
        let timeText = editorManager.timeText(time: time)
        minuteTimeLabel.text = timeText.minute
        secondTimeLabel.text = timeText.second
        millisecondTimeLabel.text = timeText.millisecond
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func decibelHeight(index: Int) -> CGFloat {
        let height = CGFloat(amplitudes[index]) * collectionViewHeight
        return height < collectionViewHeight ? height : collectionViewHeight
    }
}




extension EditRecorderViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionTypes[collectionView.tag] {
        case .decibel: return amplitudes.count
            // 收录时间:11秒/ 5秒+ 1 = 3
            //显示时间:0:00,00:05,00:10
        case .time: return Int(totalTime / 5.0) + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionTypes[collectionView.tag] {
        case .decibel:
            let cell = collectionView.dequeueReusableCell(with: WaveWithMeterCollectionViewCell.self, for: indexPath)
            cell.draw(
                height: decibelHeight(index: indexPath.row),
                index: indexPath.row
            )
            return cell
        case .time:
            let cell = collectionView.dequeueReusableCell(with: TimeCollectionViewCell.self, for: indexPath)
            cell.draw(time: editorManager.meterTime(index: indexPath.row))
            return cell
        }
    }
}

extension EditRecorderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionTypes[collectionView.tag] {
        case .decibel:
            return CGSize(width: meterWidth, height: collectionViewHeight)
        case .time:
            // 0.1秒是2px, 5秒是100px
            return CGSize(width: 20 * 5, height: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }
    
    // 水平方向上小区间的余量
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    // 垂直方向间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    // 头部
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: spaceWidth, height: collectionViewHeight)
    }

    // 尾部
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: spaceWidth, height: collectionViewHeight)
    }
}
extension EditRecorderViewController: UIScrollViewDelegate {
    //编辑栏ScrollView的滚动事件
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //编辑栏的滚动距离
        let contentOffset = scrollView.contentOffset
        //连接到每个ScrollView
        waveCollectionView.setContentOffset(contentOffset, animated: false)
        timeCollectionView.setContentOffset(contentOffset, animated: false)
        editEreaScrollView.setContentOffset(contentOffset, animated: false)
        //根据滚动量更新当前时刻
        setupCurrentTime()
    }
}

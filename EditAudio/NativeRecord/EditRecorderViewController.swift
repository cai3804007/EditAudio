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
    
    @IBOutlet weak var startLabel: UILabel!
    
    @IBOutlet weak var endLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    
    var leftinit :CGFloat = 0.0
    var rightinit :CGFloat = 0.0
     
    
    @IBOutlet weak var redLeftConst: NSLayoutConstraint!{
        didSet {
            redLeftConst.constant = spaceWidth - meterWidth/2.0
        }
    }
    
    @IBOutlet weak var redRightConst: NSLayoutConstraint!  {
        didSet {
            redRightConst.constant = spaceWidth - meterWidth/2.0
        }
    }
    
    @IBOutlet weak var redLeftView: UIView!
    @IBOutlet weak var redRightView: UIView!
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var colorRight: NSLayoutConstraint!
    @IBOutlet weak var colorLeft: NSLayoutConstraint!
    
    @IBOutlet weak var editScrollviewRight: NSLayoutConstraint!{
        didSet {
            editScrollviewRight.constant = spaceWidth
        }
    }
    @IBOutlet weak var editScrollviewLeft: NSLayoutConstraint!
    {
        didSet {
            editScrollviewLeft.constant = spaceWidth - meterWidth/2.0
        }
    }
    
    @IBOutlet weak var editScrollView: UIScrollView!{
        didSet {
            editScrollView.delegate = self
        }
    }
    
    @IBOutlet weak var rolingScrollview: UIScrollView!{
        didSet {
            rolingScrollview.delegate = self
        }
    }
    
    @IBOutlet weak var rolingWidth: NSLayoutConstraint!{
        didSet {
            rolingWidth.constant = self.meterWidth * CGFloat(self.amplitudes.count) + UIScreen.main.bounds.width
        }
    }
    
    @IBOutlet weak var scrollviewWidth: NSLayoutConstraint!{
        didSet {
            scrollviewWidth.constant = self.meterWidth * CGFloat(self.amplitudes.count) + meterWidth
        }
    }
    // ??????????????????
   public  var editorManager: AudioEditorManager!
    // ??????
    var amplitudes: [Float] { editorManager.amplitudes }
    // ?????????????????????(0.1????????????)
    let meterWidth: CGFloat = 2
    // ???????????????
    let oneSecoundWidth: CGFloat = 20
    // 5???
    let fiveSecond = 5

    //??????????????????????????????
    var collectionViewHeight: CGFloat { 150.0 }
    // ???????????????(?????????????????????)
    var spaceWidth: CGFloat {
        UIScreen.main.bounds.width / 2
    }
    // ????????????????????????????????????
    var waveContentViewWidth: CGFloat {
        CGFloat(amplitudes.count) * meterWidth
    }
    // ???????????????width
    var contentViewWidth: CGFloat {
        waveContentViewWidth + spaceWidth * 2
    }
    // ????????????
    var totalTime: Double {
        editorManager.totalTime
    }

    //????????????
    var startTime:CGFloat = 0.0
    //????????????
    var endTime:CGFloat = 0.0
    
    
    //??????????????????
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
            timeCollectionView.registerForNib(TimeCollectionViewCell.self)

        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.redLeftView.addTapGesturesTarget(self, selector: #selector(viewtap))
        self.redLeftView.addPanGesturesTarget(self, selector: #selector(viewpan(pan:)))
        self.redRightView.addPanGesturesTarget(self, selector:#selector(viewpan(pan:)))
        leftinit = spaceWidth - meterWidth/2.0
        rightinit = spaceWidth - meterWidth/2.0
        // Do any additional setup after loading the view.
    }
    
    
    func resetAllViews() {
        editScrollviewRight.constant = spaceWidth
        editScrollviewLeft.constant = spaceWidth - meterWidth/2.0
        scrollviewWidth.constant = self.meterWidth * CGFloat(self.amplitudes.count) + meterWidth
        redLeftConst.constant = spaceWidth - meterWidth/2.0
        redRightConst.constant = spaceWidth - meterWidth/2.0
        rolingWidth.constant = self.meterWidth * CGFloat(self.amplitudes.count) + UIScreen.main.bounds.width
        scrollviewWidth.constant = self.meterWidth * CGFloat(self.amplitudes.count) + meterWidth
        rolingScrollview.setContentOffset(.zero, animated: false)
    }
    
    
    
    
    @objc func viewtap(){
        
        print("tap ====")
    }
    
    @objc func viewpan(pan : UIPanGestureRecognizer)  {
        let view = pan.view
        
        
        let translation = pan.translation(in:view)
        print("translation ==== " + NSStringFromCGPoint(translation))
        //????????????????????????????????????(????????????????????????scrollView,locationPoint.x????????????????????????width)
//        let locationPoint = pan.location(in: view)
        let isleft = view?.tag == 555
        
        guard let margin = view?.tag == 555 ? redLeftConst : redRightConst else {
            return
        }
        let yidong = abs(translation.x)
        pan.setTranslation(.zero, in: pan.view)
        
        
        var result : CGFloat = margin.constant
        var fuzhi = false
        
        if translation.x < 0 {//?????????
            if isleft {//???????????????
                 result = margin.constant - yidong
                if result >=  (spaceWidth  - meterWidth/2.0){//????????????????????????????????????
                    fuzhi = true
//                    margin.constant = result
                }
            }else{
                 result = margin.constant + yidong
                if result >=  spaceWidth - meterWidth/2.0{
                    fuzhi = true
//                    margin.constant = result
                }
            }
            
            //?????????
            print("?????????")
        } else if translation.x > 0 {//?????????
            if isleft {//???????????????
                 result = margin.constant + yidong
                if result >=  (spaceWidth  - meterWidth/2.0){
                    fuzhi = true
//                    margin.constant = result
                }
            }else{
                 result = margin.constant - yidong
                if result >=  spaceWidth - meterWidth/2.0{
                    fuzhi = true
//                    margin.constant = result
                }
            }
            print("?????????")
        }
        
        if fuzhi {
            if isleft {
                if result + redLeftView.frame.width > redRightView.frame.minX {
                    return
                }
            }else{
                if (rolingWidth.constant - result - redRightView.frame.width) <= redLeftView.frame.maxX {
                    return
                }
            }
            margin.constant = result
        }
        
        
        
        var leftTime = (redLeftConst.constant - leftinit)/oneSecoundWidth
        leftTime = CGFloat(max(0, min(Double(leftTime), totalTime)))
        startTime = leftTime
        let leftText = editorManager.timeText(time: Double(leftTime))
        self.startLabel.text = leftText.minute  +  leftText.second + leftText.millisecond
        
                         //???????????????
        let ringhtTime = CGFloat(totalTime) - (redRightConst.constant - rightinit)/oneSecoundWidth
        let rightText = editorManager.timeText(time: Double(ringhtTime))
        endTime = ringhtTime
        self.endLabel.text = rightText.minute +  rightText.second + rightText.millisecond
    }
    
    
    func setupCurrentTime() {
        //??????????????????/ 20px(1?????????)
        let currentTime = editScrollView.contentOffset.x / oneSecoundWidth
        // ???????????????????????????????????????
        let time = max(0, min(Double(currentTime), totalTime))
        let timeText = editorManager.timeText(time: time)
        minuteTimeLabel.text = timeText.minute
        secondTimeLabel.text = timeText.second
        millisecondTimeLabel.text = timeText.millisecond
    }
    
    @IBAction func playButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            let scrollX = redLeftConst.constant - leftinit
            rolingScrollview.setContentOffset(CGPoint(x: scrollX, y: 0), animated: false)
        }

        let isPlaying = editorManager.isPlaying
        // ??????????????????/ 20px(1?????????)
        let currentTime = rolingScrollview.contentOffset.x / oneSecoundWidth
        let time = max(0, min(Double(currentTime), totalTime))
        // ???AVAudioPlayer??????????????????????????????
        isPlaying
            ? editorManager.pause()
            : editorManager.play(currentTime: time)
        // ???????????????
        setupTimer(isPlaying: editorManager.isPlaying)
        
    }
    
    @IBAction func exportAudio(_ sender: UIButton) {
        let editString = SeanFileManager.editAudioName()
        guard let exportURL = SeanFileManager.fileUrl(fileName: editString, .editAudio)?.path
        else { return }
        
        editorManager.editSaveCenter(leftTime:Double(self.startTime) , rightime: Double(self.endTime),exporURL: exportURL) { (result) in
            switch result {
            case let .success(removeRange):
                 print("????????????")
                print(removeRange)
                DispatchQueue.main.async {
//                    self.waveCollectionView.performBatchUpdates({
//
//                    })
                    self.waveCollectionView.reloadData()
                    self.resetAllViews()
                    sender.isEnabled = false
                }
            case let .failure(error):
                print(error)
                print("????????????")
            }
        }
    }
    
    
    
    
    private func setupTimer(isPlaying: Bool) {
        if !isPlaying {
            playerTimer?.invalidate()
            playerTimer = nil
        } else {
            playerTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//                guard self.editorManager.isPlaying else {
//                    timer.invalidate()
//                    self.playButton.isSelected = false
//                    return
//                }
                // ???0.1???????????????????????????????????????
                var movePoint = self.rolingScrollview.contentOffset
                movePoint.x += 2
                let scrollX = (self.redRightView.frame.maxX - self.rightinit) - self.meterWidth
                if movePoint.x >= scrollX{
                    self.rolingScrollview.setContentOffset(CGPoint(x: scrollX, y: 0), animated: false)
                    self.editorManager.pause()
                    self.playButton.isSelected = false
                    timer.invalidate()
                }else{
                    self.rolingScrollview.setContentOffset(movePoint, animated: false)
                }
            }
        }
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
            // ????????????:11???/ 5???+ 1 = 3
            //????????????:0:00,00:05,00:10
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
            // 0.1??????2px, 5??????100px
            return CGSize(width: 20 * 5, height: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }
    
    // ?????????????????????????????????
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    // ??????????????????
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    // ??????
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: spaceWidth, height: collectionViewHeight)
    }

    // ??????
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: spaceWidth, height: collectionViewHeight)
    }
}
extension EditRecorderViewController: UIScrollViewDelegate {
    //?????????ScrollView???????????????
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //????????????????????????
        let contentOffset = scrollView.contentOffset
        //???????????????ScrollView
        waveCollectionView.setContentOffset(contentOffset, animated: false)
        timeCollectionView.setContentOffset(contentOffset, animated: false)
        editScrollView.setContentOffset(contentOffset, animated: false)
        //?????????????????????????????????
        setupCurrentTime()
    }
}

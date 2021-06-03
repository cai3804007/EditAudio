// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKitUI/

import AudioKit
import Accelerate
import AVFoundation
import UIKit

class  NodeOutputView :UIView{
    private var nodeTap: RawDataTap!
    private var metalFragment: FragmentBuilder!

    public init(_ node: Node, color: UIColor = .gray, bufferSize: Int = 1024) {

        metalFragment = FragmentBuilder(foregroundColor: color.cgColor, isCentered: true, isFilled: false)
        nodeTap = RawDataTap(node, bufferSize: UInt32(bufferSize))
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(plot)
    }
    
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    var plot: FloatPlot {
        nodeTap.start()

        return FloatPlot(frame: CGRect(x: 0, y: 0, width: 1024, height: 1024), fragment: metalFragment.stringValue) {
            return self.nodeTap.data
        }
    }
    
//    public func makeUIView(context: Context) -> FloatPlot { return plot }

    
}

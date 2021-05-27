import Foundation
import AVFoundation
import UIKit
import CoreGraphics

/// Renders a UIImage of the waveform data calculated by the analyzer.
public class WaveformImageDrawer {
    public init() {}

    // swiftlint:disable function_parameter_count
    /// Renders a UIImage of the waveform data calculated by the analyzer.
    public func waveformImage(fromAudioAt audioAssetURL: URL,
                              with configuration: WaveformConfiguration,
                              qos: DispatchQoS.QoSClass = .userInitiated,
                              completionHandler: @escaping (_ waveformImage: UIImage?) -> ()) {
        let scaledSize = CGSize(width: configuration.size.width * configuration.scale,
                                height: configuration.size.height * configuration.scale)
        let scaledConfiguration = WaveformConfiguration(size: scaledSize,
                                                        backgroundColor: configuration.backgroundColor,
                                                        style: configuration.style,
                                                        position: configuration.position,
                                                        scale: configuration.scale,
                                                        paddingFactor: configuration.paddingFactor)
        guard let waveformAnalyzer = WaveformAnalyzer(audioAssetURL: audioAssetURL) else {
            completionHandler(nil)
            return
        }
        render(from: waveformAnalyzer, with: scaledConfiguration, qos: qos, completionHandler: completionHandler)
    }

    /// Renders a UIImage of the waveform data calculated by the analyzer.
    public func waveformImage(fromAudioAt audioAssetURL: URL,
                              size: CGSize,
                              backgroundColor: UIColor = UIColor.clear,
                              style: WaveformStyle = .gradient([UIColor.black, UIColor.darkGray]),
                              position: WaveformPosition = .middle,
                              scale: CGFloat = UIScreen.main.scale,
                              paddingFactor: CGFloat? = nil,
                              qos: DispatchQoS.QoSClass = .userInitiated,
                              shouldAntialias: Bool = false,
                              completionHandler: @escaping (_ waveformImage: UIImage?) -> ()) {
        let configuration = WaveformConfiguration(size: size, backgroundColor: backgroundColor,
                                                  style: style, position: position, scale: scale,
                                                  paddingFactor: paddingFactor, shouldAntialias: shouldAntialias)
        waveformImage(fromAudioAt: audioAssetURL, with: configuration, completionHandler: completionHandler)
    }

    // swiftlint:enable function_parameter_count
}

// MARK: Image generation

private extension WaveformImageDrawer {
    func render(from waveformAnalyzer: WaveformAnalyzer,
                with configuration: WaveformConfiguration,
                qos: DispatchQoS.QoSClass,
                completionHandler: @escaping (_ waveformImage: UIImage?) -> ()) {
        let sampleCount = Int(configuration.size.width * configuration.scale)
        waveformAnalyzer.samples(count: sampleCount, qos: qos) { samples in
            guard let samples = samples else {
                completionHandler(nil)
                return
            }
            completionHandler(self.graphImage(from: samples, with: configuration))
        }
    }

    private func graphImage(from samples: [Float], with configuration: WaveformConfiguration) -> UIImage? {
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = configuration.scale
            let renderer = UIGraphicsImageRenderer(size: configuration.size, format: format)

            return renderer.image { renderContext in
                draw(on: renderContext.cgContext, from: samples, with: configuration)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(configuration.size, false, configuration.scale)

            let context = UIGraphicsGetCurrentContext()!

            draw(on: context, from: samples, with: configuration)

            let graphImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return graphImage
        }
    }

    private func draw(on context: CGContext, from samples: [Float], with configuration: WaveformConfiguration) {
        context.setAllowsAntialiasing(configuration.shouldAntialias)
        context.setShouldAntialias(configuration.shouldAntialias)

        drawBackground(on: context, with: configuration)
        drawGraph(from: samples, on: context, with: configuration)
    }

    private func drawBackground(on context: CGContext, with configuration: WaveformConfiguration) {
        context.setFillColor(configuration.backgroundColor.cgColor)
        context.fill(CGRect(origin: CGPoint.zero, size: configuration.size))
    }

    private func drawGraph(from samples: [Float],
                           on context: CGContext,
                           with configuration: WaveformConfiguration) {
        let graphRect = CGRect(origin: CGPoint.zero, size: configuration.size)
        let positionAdjustedGraphCenter = CGFloat(configuration.position.value()) * graphRect.size.height
        let verticalPaddingDivisor = configuration.paddingFactor ?? CGFloat(configuration.position.value() == 0.5 ? 2.5 : 1.5)
        let drawMappingFactor = graphRect.size.height / verticalPaddingDivisor
        let minimumGraphAmplitude: CGFloat = 1 // we want to see at least a 1pt line for silence

        let path = CGMutablePath()
        var maxAmplitude: CGFloat = 0.0 // we know 1 is our max in normalized data, but we keep it 'generic'

        var drawEveryNSamples: Int = 0
        if case let .striped(config) = configuration.style {
            let nStripes = configuration.size.width / (config.width + (config.spacing))
            drawEveryNSamples = Int(CGFloat(samples.count) / nStripes)
        }

        for (x, sample) in samples.enumerated() {
            let xPos = CGFloat(x) / configuration.scale
            let invertedDbSample = 1 - CGFloat(sample) // sample is in dB, linearly normalized to [0, 1] (1 -> -50 dB)
            let drawingAmplitude = max(minimumGraphAmplitude, invertedDbSample * drawMappingFactor)
            let drawingAmplitudeUp = positionAdjustedGraphCenter - drawingAmplitude
            let drawingAmplitudeDown = positionAdjustedGraphCenter + drawingAmplitude
            maxAmplitude = max(drawingAmplitude, maxAmplitude)

            if case .striped = configuration.style, (Int(x) % drawEveryNSamples != 0) {
                continue
            }

            path.move(to: CGPoint(x: xPos, y: drawingAmplitudeUp))
            path.addLine(to: CGPoint(x: xPos, y: drawingAmplitudeDown))
        }

        context.addPath(path)
        context.setAlpha(1.0)
        context.setShouldAntialias(configuration.shouldAntialias)

        if case let .striped(config) = configuration.style {
            context.setLineWidth(config.width)
        } else {
            context.setLineWidth(1.0 / configuration.scale)
        }

        switch configuration.style {
        case let .filled(color):
            context.setStrokeColor(color.cgColor)
            context.strokePath()
        case let .striped(config):
            context.setStrokeColor(config.color.cgColor)
            context.strokePath()
        case let .gradient(colors):
            context.replacePathWithStrokedPath()
            context.clip()
            let colors = NSArray(array: colors.map(\.cgColor)) as CFArray
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
            context.drawLinearGradient(gradient,
                                       start: CGPoint(x: 0, y: positionAdjustedGraphCenter - maxAmplitude),
                                       end: CGPoint(x: 0, y: positionAdjustedGraphCenter + maxAmplitude),
                                       options: .drawsAfterEndLocation)
        }
    }
}

import Cocoa
import Vision

public func getTestReceiptImageName(_ number: Int) -> String {
    String.init(format: "%d-receipt", number)
}

//https://www.swiftbysundell.com/tips/making-uiimage-macos-compatible/
public extension NSImage {
    var cgImage: CGImage? {
        var proposedRect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &proposedRect,
                       context: nil,
                       hints: nil)
    }
}

//https://www.udemy.com/course/machine-learning-with-core-ml-2-and-swift
public func visualization(
    _ image: NSImage,
    observations: [VNDetectedObjectObservation],
    boundingBoxColor: NSColor
) -> NSImage {
    var transform = CGAffineTransform.identity
    transform = transform.scaledBy(x: image.size.width, y: image.size.height)

    image.lockFocus()
    let context = NSGraphicsContext.current?.cgContext
    context?.saveGState()

    context?.setLineWidth(2)
    context?.setLineJoin(CGLineJoin.round)
    context?.setStrokeColor(.black)
    context?.setFillColor(boundingBoxColor.cgColor)

    observations.forEach { observation in
        let bounds = observation.boundingBox.applying(transform)
        context?.addRect(bounds)
    }

    context?.drawPath(using: CGPathDrawingMode.fillStroke)
    context?.restoreGState()
    image.unlockFocus()
    return image
}

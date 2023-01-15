//Step 1. Load a receipt image from Resource folder
import Vision
import Cocoa

let image = NSImage(imageLiteralResourceName: getTestReceiptImageName(1))

let recognizeTextRequest = VNRecognizeTextRequest  { (request, error) in
    guard let observations = request.results as? [VNRecognizedTextObservation] else {
        print("Error: \(error! as NSError)")
        return
    }
    for currentObservation in observations {
        let topCandidate = currentObservation.topCandidates(1)
        if let recognizedText = topCandidate.first {
            //OCR Results
            print(recognizedText.string)
        }
    }
    let fillColor: NSColor = NSColor.green.withAlphaComponent(0.3)
    let result = visualization(image, observations: observations, boundingBoxColor: fillColor)
}
recognizeTextRequest.recognitionLevel = .accurate

func request(_ image: NSImage) {
    guard let cgImage = image.cgImage else {
        return
    }
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    DispatchQueue.global(qos: .userInitiated).async {
        do {
            try handler.perform([recognizeTextRequest])
        }
        catch let error as NSError {
            print("Failed: \(error)")
        }
    }
}
request(image)

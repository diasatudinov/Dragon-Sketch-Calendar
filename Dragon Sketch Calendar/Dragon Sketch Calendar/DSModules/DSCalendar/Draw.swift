//
//  Draw.swift
//  Dragon Sketch Calendar
//
//

import SwiftUI

struct Draw: Codable, Identifiable, Hashable {
    let id: UUID
    var imageData: Data?
    var date: Date
    var emotion: Emotion
    var element: Elements
    
    init(id: UUID = UUID(), imageData: Data? = nil, date: Date, emotion: Emotion, element: Elements) {
        self.id = id
        self.imageData = imageData
        self.date = date
        self.emotion = emotion
        self.element = element
    }
}

extension Draw {
    var uiImage: UIImage? {
        guard let imageData else { return nil }
        return UIImage(data: imageData)
    }
    
    var image: Image? {
        guard let uiImage else { return nil }
        return Image(uiImage: uiImage)
    }
    
    mutating func setImage(_ uiImage: UIImage) {
        self.imageData = uiImage.pngData()
    }
}

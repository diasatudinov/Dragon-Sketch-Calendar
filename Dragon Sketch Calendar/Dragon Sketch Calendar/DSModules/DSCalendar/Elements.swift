//
//  Elements.swift
//  Dragon Sketch Calendar
//
//

import SwiftUI

enum Elements: String, Codable, CaseIterable, Hashable {
    case water, wood, fire, metal, earth
    
    var text: String {
        switch self {
        case .water:
            "Water"
        case .wood:
            "Wood"
        case .fire:
            "Fire"
        case .metal:
            "Metal"
        case .earth:
            "Earth"
        }
    }
    
    var icon: String {
        switch self {
        case .water:
            "element1IconDS"
        case .wood:
            "element2IconDS"
        case .fire:
            "element3IconDS"
        case .metal:
            "element4IconDS"
        case .earth:
            "element5IconDS"
        }
    }
    
    var color: Color {
        switch self {
        case .water:
                .appBlue
        case .wood:
                .appGreen
        case .fire:
                .textYellow
        case .metal:
                .appGray
        case .earth:
                .appBrown
        }
    }
    
    var guidance: String {
        switch self {
        case .water:
            "Let your peace ripple outward-gentle, steady, endless."
        case .wood:
            "Let your joy branch out-share leaves, offer shade, bloom boldly."
        case .fire:
            "This is your kindling. Light it boldly-before it fades."
        case .metal:
            "Cut away distractions. Keep only what serves your purpose."
        case .earth:
            "Rest like a mountain-immovable, patient, deeply rooted."
        }
    }
}

enum Emotion: String, Codable, CaseIterable, Hashable {
    case one, two, three, four, five, six, seven, eight
    
    var emoji: String {
        switch self {
        case .one:
            "😌"
        case .two:
            "😊"
        case .three:
            "😐"
        case .four:
            "😠 "
        case .five:
            "😢"
        case .six:
            "😨"
        case .seven:
            "😴"
        case .eight:
            "🤩"
        }
    }
}

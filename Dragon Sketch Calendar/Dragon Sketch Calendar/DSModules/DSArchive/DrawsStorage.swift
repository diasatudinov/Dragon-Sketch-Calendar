//
//  DrawsStorage.swift
//  Dragon Sketch Calendar
//
//  Created by Dias Atudinov on 16.04.2026.
//


import Foundation

final class DrawsStorage {
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private var fileURL: URL {
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent("draws.json")
    }
    
    init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func load() -> [Draw] {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return try decoder.decode([Draw].self, from: data)
        } catch {
            print("Failed to load draws:", error)
            return []
        }
    }
    
    func save(_ draws: [Draw]) {
        do {
            let data = try encoder.encode(draws)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save draws:", error)
        }
    }
    
    func add(_ draw: Draw) {
        var draws = load()
        
        if let index = draws.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: draw.date) }) {
            draws[index] = draw
        } else {
            draws.append(draw)
        }
        
        save(draws.sorted { $0.date < $1.date })
    }
    
    func delete(_ draw: Draw) {
        var draws = load()
        draws.removeAll { $0.id == draw.id }
        save(draws)
    }
    
    func delete(on date: Date) {
        var draws = load()
        draws.removeAll { Calendar.current.isDate($0.date, inSameDayAs: date) }
        save(draws)
    }
    
    func replaceAll(with draws: [Draw]) {
        save(draws.sorted { $0.date < $1.date })
    }
}
//
//  Album.swift
//  CollectionViewVideo
//
//  Created by Julia Maria Santos on 25/09/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import Foundation

class Album: Codable {
    var nameAlbum: String
    var nameImageAlbum: String
    var nameArtist: String
    var albumYear: String
    static var allAlbums: [Album] = {
        var albums: [Album] = []
        guard let path = Bundle.main.path(forResource: "Albums", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return albums
        }
        do {
            let albums = try JSONDecoder().decode([Album].self, from: data)
            return albums
        } catch {
            print(error)
        }
        return albums
    }()
    
    init(nameAlbum: String, nameImageAlbum: String, nameArtist: String, albumYear: String) {
        self.nameAlbum = nameAlbum
        self.nameImageAlbum = nameImageAlbum
        self.nameArtist = nameArtist
        self.albumYear = albumYear
    }
}

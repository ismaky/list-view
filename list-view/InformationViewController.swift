//
//  InformationViewController.swift
//  list-view
//
//  Created by Ismael on 16/03/23.
//

import UIKit

class InformationViewController: UIViewController {
    
    var album: Album!
    
    lazy var labelNameAlbum: UILabel = {
        let lnal = UILabel()
        lnal.font = UIFont(name: "GillSans-Bold", size: 20)
        //ver quantas linhas são necessarias
        lnal.numberOfLines = 0
        //alinhando o texto no meio
        lnal.textAlignment = .center
        lnal.text = album.nameAlbum
        lnal.textColor = .white
        lnal.translatesAutoresizingMaskIntoConstraints = false
        return lnal
    }()
    
    lazy var labelNameArtist: UILabel = {
        let lnar = UILabel()
        lnar.font = UIFont(name: "GillSans", size: 18)
        lnar.text = album.nameArtist
        lnar.textColor = .white
        lnar.translatesAutoresizingMaskIntoConstraints = false
        return lnar
    }()
    
    lazy var labelAlbumYear: UILabel = {
        let lay = UILabel()
        lay.font = UIFont(name: "GillSans", size: 18)
        lay.text = album.albumYear
        lay.textColor = .white
        lay.translatesAutoresizingMaskIntoConstraints = false
        return lay
    }()
    
    lazy var imageAlbum: UIImageView = {
        let image = UIImage(named: album.nameImageAlbum)
        let img = UIImageView(image: image)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(labelNameAlbum)
        view.addSubview(labelNameArtist)
        view.addSubview(labelAlbumYear)
        view.addSubview(imageAlbum)
        
        setUpSecondPageConstraints()
        
        view.backgroundColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func setUpSecondPageConstraints(){
        // Constranints Image Album
        NSLayoutConstraint.activate([
            imageAlbum.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageAlbum.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageAlbum.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            imageAlbum.heightAnchor.constraint(equalTo: imageAlbum.widthAnchor)
        ])
        
        //constraints Label Name Album
        NSLayoutConstraint.activate([
            labelNameAlbum.topAnchor.constraint(equalTo: self.imageAlbum.bottomAnchor, constant: 50),
            labelNameAlbum.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            labelNameAlbum.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        //Constraints Label Name Artist
        
        NSLayoutConstraint.activate([
            labelNameArtist.topAnchor.constraint(equalTo: self.labelNameAlbum.bottomAnchor, constant: 16),
            labelNameArtist.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelAlbumYear.topAnchor.constraint(equalTo: self.labelNameArtist.bottomAnchor, constant: 16),
            labelAlbumYear.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}

//
//  CollectionViewController.swift
//  list-view
//
//  Created by Michelle on 01/03/23.
//

import UIKit

class CollectionViewController: UIViewController {
    
}
//
//    var albums: [Album] = []
//
//    var labelAlbums: UILabel! = {
//        let label = UILabel()
//        label.font = UIFont(name: "GillSans", size: 36)
//        label.text = "ALBUMS"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var myCollectionView: UICollectionView! = {
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 110, left: 18, bottom: 10, right: 18)
//        layout.itemSize = CGSize(width: 100, height: 100)
//
//        let cv: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        cv.dataSource = self
//        cv.delegate = self
//        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
//        cv.backgroundColor = UIColor.white
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        return cv
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //Get all album from jason
//        albums = Album.allAlbums
//
//        view.addSubview(myCollectionView)
//        myCollectionView.addSubview(labelAlbums)
//
//        setUpHomeConstraints()
//
//        view.backgroundColor = UIColor.black
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return albums.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
//
//        let image  = UIImage(named: albums[indexPath.item].nameImageAlbum)
//        let imageView = UIImageView(image: image)
//        imageView.frame.size = cell.contentView.bounds.size
//
//        cell.contentView.addSubview(imageView)
//
//        return cell
//    }
//
//    func setUpHomeConstraints() {
//
//        //constraits label album
//        NSLayoutConstraint.activate([
//            labelAlbums.topAnchor.constraint(equalTo: myCollectionView.topAnchor,constant: 30), labelAlbums.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)])
//
//        // constraits collectionvew
//        NSLayoutConstraint.activate([
//            myCollectionView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
//            myCollectionView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor),
//            myCollectionView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
//            myCollectionView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)])
//    }
//}

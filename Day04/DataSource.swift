//
//  DataSource.swift
//  Day04
//
//  Created by Duy Anh on 1/6/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//
import UIKit
import Foundation

class DataSource: NSObject, UICollectionViewDataSource {
    weak var collectionView: UICollectionView!
    lazy var indexes: [Int] = {
        var array = [Int]()
        for i in 0 ... 19 { array.append(i) }
        return array
    }()
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as? UILabel)?.text = indexes[indexPath.row].description
        
        cell.contentView.cornerRadius = cell.bounds.width / 57 * 10
        cell.cornerRadius = cell.contentView.cornerRadius
        
        cell.contentView.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        cell.contentView.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = indexes[sourceIndexPath.row]
        indexes[sourceIndexPath.row] = indexes[destinationIndexPath.row]
        indexes[destinationIndexPath.row] = temp
    }
}

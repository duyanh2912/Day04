//
//  ViewController.swift
//  Day04
//
//  Created by Duy Anh on 1/5/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//
import Utils
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDataSource?
    
    var editingMode = false
    var selectedCell: UICollectionViewCell?
    
    override func viewDidLoad() {
        collectionView.delegate = self
        
        dataSource = DataSource(collectionView: collectionView)
        collectionView.dataSource = dataSource
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView))
        
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = indexPath else { return }
            
            editingMode = true
            selectedCell = collectionView.cellForItem(at: selectedIndexPath)
            let layer = selectedCell?.layer
            layer?.masksToBounds = false
            layer?.shadowRadius = 1
            layer?.shadowOpacity = 0.3
            layer?.shadowOffset = CGSize(width: -4.0, height: -4)
            
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
            
        case .ended:
            collectionView.endInteractiveMovement()
            editingMode = false
            let layer = selectedCell?.layer
            UIView.animate(withDuration: 3, animations: {layer?.shadowOpacity = 0}) { [unowned self] _ in
            self.selectedCell = nil
            }
        
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 57, height: 57)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.cornerRadius = cell.bounds.width / 57 * 10
        cell.cornerRadius = cell.contentView.cornerRadius
        
        cell.contentView.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        cell.contentView.borderWidth = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 70, left: 20, bottom: 50, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}


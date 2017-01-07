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
    
    var selectedCell: UICollectionViewCell?
    var cellSnapshot: UIView?
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        collectionView.delegate = self
        
        dataSource = DataSource(collectionView: collectionView)
        collectionView.dataSource = dataSource
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView))
        
        switch(gesture.state) {
            
        case .began:
            self.selectedIndexPath = indexPath
            guard selectedIndexPath != nil  else { return }
            
            selectedCell = collectionView.cellForItem(at: selectedIndexPath!)
            
            cellSnapshot = selectedCell?.snapshotView(afterScreenUpdates: true)
            cellSnapshot?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            cellSnapshot?.alpha = 0.95
            cellSnapshot?.center = selectedCell!.center
            
            let layer = cellSnapshot?.layer
            layer?.masksToBounds = false
            layer?.shadowRadius = 1
            layer?.shadowOpacity = 0.3
            layer?.shadowOffset = CGSize(width: -4.0, height: -4)
        
            collectionView.addSubview(cellSnapshot!)
            UIView.animate(withDuration: 0.25) { [unowned self] in self.cellSnapshot?.center = location }
            
            selectedCell?.contentView.alpha = 0
            
        case .changed:
            cellSnapshot?.center = gesture.location(in: collectionView)
            
            if indexPath != nil, selectedIndexPath != nil, selectedIndexPath != indexPath {
                collectionView.moveItem(at: selectedIndexPath!, to: indexPath!)
                self.selectedIndexPath = indexPath
            }
            
        case .ended:
            UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                self.cellSnapshot?.center = (self.selectedCell?.center)!
                self.cellSnapshot?.alpha = 1
                self.cellSnapshot?.transform = CGAffineTransform.identity
            }) { [unowned self] _ in
                self.cellSnapshot?.removeFromSuperview()
                self.cellSnapshot = nil
                
                self.selectedCell?.contentView.alpha = 1
                self.selectedCell = nil
                
                self.selectedIndexPath = nil
            }
            
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 57, height: 57)
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


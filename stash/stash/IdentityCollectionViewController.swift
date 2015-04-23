//
//  IdentityCollectionViewController.swift
//  stash
//
//  Created by James Stidard on 23/04/2015.
//  Copyright (c) 2015 James Stidard. All rights reserved.
//

import UIKit
import CoreData

// MARK: - Delegate Protocol
protocol IdentityCollecionViewControllerDelegate: class
{
    func identitySelectorViewController(
        identitySelectorViewController: IdentityCollectionViewController,
        didSelectIdentity identity: Identity,
        withDecryptedMasterKey masterKey: NSData)
}

// MARK: -
class IdentityCollectionViewController: UICollectionViewController,
    UICollectionViewDelegateFlowLayout,
    NSFetchedResultsControllerDelegate,
    ContextDriven
{
    // MARK: Public Properties
    static let SegueID = "IdentityCollectionViewController"
    
    weak var delegate: IdentityCollectionViewController?
    weak var dataSource: SqrlLinkDataSource?
    
    var context :NSManagedObjectContext? {
        didSet {
            self.createIdentitiesFetchedResultsController()
            self.identitiesFRC?.performFetch(nil)
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: Private Properties
    private var identitiesFRC:    NSFetchedResultsController?
    private let DefaultCellInset: CGFloat = 20.0
    private lazy var cellInset:   CGFloat = self.DefaultCellInset
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func invalidate()
    {
        // TODO:
        self.collectionView?.reloadData()
    }
    
    
    // MARK: - Fetched Results Controller
    private func createIdentitiesFetchedResultsController() {
        if let context = self.context {
            self.identitiesFRC = Identity.fetchedResultsController(context, delegate: self)
        }
    }
    

    // MARK: - CollectionView Layout
    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(cellInset, cellInset, cellInset, cellInset)
    }
    
    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return cellInset * 2
    }
    
    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return cellInset * 2
    }
    
    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let size            = collectionView.bounds.size
        let (width, height) = (size.width - (cellInset * 2), size.height - (cellInset * 2))
        
        return CGSize(width: width, height: height)
    }
    
    
    // MARK: CollectionView DataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }

    override func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        return self.identitiesFRC?.fetchedObjects?.count ?? 0
    }

    override func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(IdentityCell.ReuseID, forIndexPath: indexPath) as! IdentityCell
        let identity = self.identitiesFRC?.objectAtIndexPath(indexPath) as? Identity
        
        cell.nameLabel.text = identity?.name
        
        return cell
    }

    // MARK: CollectionView Delegate
    override func collectionView(
        collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! IdentityCell
        cell.requestPassword(true, animated: true)
        cell.passwordField.becomeFirstResponder()
        
        self.cellInset = 0 // Cell should take up entire collection view for password
        collectionView.performBatchUpdates({
            collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! IdentityCell
//        cell.requestPassword(false, animated: true)
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
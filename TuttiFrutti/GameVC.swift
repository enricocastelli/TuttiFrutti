//
//  GameVC.swift
//  TuttiFrutti
//
//  Created by Enrico Castelli on 12/10/2019.
//  Copyright © 2019 EC. All rights reserved.
//

import UIKit

fileprivate let cellID = String(describing: CardCell.self)

class GameVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var deckCollectionView: UICollectionView!

    var items: [Card] =  Card.getRandomDeck()
    var addedItems : [Card] = [Card(name: "", power: 0),
                               Card(name: "", power: 0),
                               Card(name: "", power: 0),
                               Card(name: "", power: 0),
                               Card(name: "", power: 0),
                               Card(name: "", power: 0),
                               Card(name: "", power: 0),
                               Card(name: "", power: 0),
                               Card(name: "", power: 0)
                               ]
    var dragItem: Card?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView(collectionView)
        setupCollectionView(deckCollectionView)
    }

    func setupCollectionView(_ cv: UICollectionView) {
        cv.dragInteractionEnabled = true
        cv.register(UINib(nibName: String(describing: CardCell.self), bundle: nil), forCellWithReuseIdentifier: cellID)
        cv.reorderingCadence = .immediate
        cv.delegate = self
        cv.dataSource = self
        cv.dragDelegate = cv == self.collectionView ? nil : self
        cv.dropDelegate = cv == self.collectionView ? self : nil
    }
    
    func didPlaceItem(_ placedIndex: Int, isUser: Bool) {
        for itemIndex in 0...addedItems.count - 1 {
            for adiacentIndex in 0...addedItems.count - 1 {
                var currentItem = addedItems[itemIndex]
                var adiacentItem = addedItems[adiacentIndex]
                if let directions = isItemClose(itemIndex, adiacentIndex), !currentItem.isEmpty() && !adiacentItem.isEmpty() {
                    if currentItem.angles.contains(directions.0) &&
                        adiacentItem.angles.contains(directions.1) {

                    } else if currentItem.angles.contains(directions.0) {
                        adiacentItem.isUser = currentItem.isUser
                        addedItems.update(adiacentItem, index: adiacentIndex)
                    } else if adiacentItem.angles.contains(directions.1) {
                        currentItem.isUser = adiacentItem.isUser
                        addedItems.update(currentItem, index: itemIndex)
                    } else {
                        
                    }
                }
            }
        }
        if isUser {
            opponent()
        } else {
            collectionView.reloadData()
        }
    }
    
    func opponent() {
        let randomEmpty = getRandomEmpty()
        var card = Card.getRandom()
        card.isUser = false
        addedItems.update(card, index: randomEmpty)
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.didPlaceItem(randomEmpty, isUser: false)
            if self.addedItems.filter({ ($0.isEmpty())}).count == 1 {
                self.over()
            }
        }
    }
    
    func getRandomEmpty() -> Int {
        var random = getRandom()
        while addedItems[random].name != "" {
            random += getRandom()
            if random >= addedItems.count {
                random = getRandom()
            }
        }
        return random
    }
    
    func getRandom()-> Int {
        return Int(arc4random_uniform(UInt32(addedItems.count)))
    }
    
    func isItemClose(_ itemIndex: Int,_ index: Int) -> (Direction, Direction)? {
        guard itemIndex != index && itemIndex - index > 0 else { return nil }
        switch (itemIndex, index) {
        case (0,1),(1,2),(3,4),(4,5),(6,7),(7,8):
            return (.E, .W)
        case (0,2),(2,0),(2,3),(3,2),(3,5),(5,3),(6,5),(6,8),(8,6):
            return nil
        case (0,3),(1,4),(2,5),(3,6),(4,7),(5,8):
            return (.S, .N)
        case (0,4),(1,5),(3,7),(4,8):
            return (.SE, .NW)
        case (1,0),(2,1),(4,3),(5,4),(7,6),(8,7): return (.W, .E)
        case (1,3),(2,4),(4,6),(5,7): return (.SW, .NE)
        case (3,0),(4,1),(5,2),(6,3),(7,4),(8,5): return (.N, .S)
        case (3,1),(4,2),(6,4),(7,5): return (.NE, .SW)
        case (4,0),(5,1),(7,3),(8,4): return (.NW, .SE)
        default:
            return nil
        }
    }
    
    func over() {
        let userCards = addedItems.filter({ ($0.isUser)})
        let tot = (addedItems.count - 1)/2
        if userCards.count > tot {
            if userCards.count == addedItems.count {
                print("perfect")
            } else {
                print("win")
            }
        } else if userCards.count == tot {
            print("tie")
        } else if userCards.count < tot {
            print("lost")
        }
    }
}


extension GameVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.collectionView ? addedItems.count :  items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CardCell
        if collectionView == self.collectionView {
            let element = addedItems[indexPath.row]
            if element.name != "" {
                cell.item = element
            }
        } else {
            cell.item = items[indexPath.row]
        }
        return cell
    }
}

extension GameVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = 100
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

extension GameVC: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.items[indexPath.row]
        let itemProvider = NSItemProvider(object: item.name as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        self.dragItem = item
        return [dragItem]
    }
}

extension GameVC: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        switch coordinator.proposal.operation
        {
        case .move:
            let location = coordinator.session.location(in: self.view)
            if collectionView.frame.contains(location) {
                guard var dragItem = dragItem, let destination = coordinator.destinationIndexPath?[1] else { return }
                dragItem.isUser = true
                addedItems.update(dragItem, index: destination)
                items.remove(at: items.firstIndex(where: {$0.name == dragItem.name })!)
                self.collectionView.reloadData()
                self.deckCollectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    self.didPlaceItem(destination, isUser: true)
                }
            }
            break
        case .copy:
            break
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        if session.localDragSession != nil
        {
            guard collectionView == self.collectionView else {
                return UICollectionViewDropProposal(operation: .move, intent: .unspecified)
            }
            if collectionView.hasActiveDrag
            {
                return UICollectionViewDropProposal(operation: .move, intent: .unspecified)
            }
            else
            {
                return UICollectionViewDropProposal(operation: .move, intent: .unspecified)
            }
        }
        else
        {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
}

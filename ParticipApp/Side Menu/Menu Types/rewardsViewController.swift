//
//  rewardsViewController.swift
//  ParticipApp
//
//  Created by Gerardo Silva Razo on 11/23/19.
//  Copyright © 2019 Gerardo Silva Razo. All rights reserved.
//

import UIKit

// Reward struct
struct Reward {
    var title: String
    var description: String
    var image: UIImage
}

class rewardsViewController: UIViewController {
    
    // Recent rewards Data
    let data = [
        Reward(title: "Reward1", description: "asdf", image: #imageLiteral(resourceName: "Recurso1")),
        Reward(title: "Reward1", description: "asdf", image: #imageLiteral(resourceName: "Recurso1")),
        Reward(title: "Reward1", description: "asdf", image: #imageLiteral(resourceName: "Recurso1")),
        Reward(title: "Reward1", description: "asdf", image: #imageLiteral(resourceName: "Recurso1")),
        Reward(title: "Reward1", description: "asdf", image: #imageLiteral(resourceName: "Recurso1")),
    ]
    
    // Collection View for latestRewards
    fileprivate let latestRewardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.isScrollEnabled = true
        cv.isUserInteractionEnabled = true
        return cv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // LatestRewards collection is created and added to the view
        view.addSubview(latestRewardsCollectionView)
        latestRewardsCollectionView.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0.8196078431, blue: 0.2666666667, alpha: 1)
        latestRewardsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        latestRewardsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        latestRewardsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        latestRewardsCollectionView.heightAnchor.constraint(equalTo: latestRewardsCollectionView.widthAnchor, multiplier: 0.5).isActive = true
        latestRewardsCollectionView.delegate = self
        latestRewardsCollectionView.dataSource = self
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        // Notifies the homeViewController to close menu definitely
        NotificationCenter.default.post(name: .didCloseDefinitely, object: nil)
        // Pops last profileViewController
        navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// Collection view extension
extension rewardsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.data = self.data[indexPath.row]
        return cell
    }
    
    
}

// Cell for collection view class
class CustomCell: UICollectionViewCell {
    
    var data: Reward? {
        didSet {
            guard let data = data else { return }
            bg.image = data.image
        }
    }
    
    fileprivate let bg: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Recurso1")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

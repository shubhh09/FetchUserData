//
//  HomeCell.swift
//  ShubhamLodhi_MT
//
//  Created by SHUBHAM on 21/11/24.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    //MARK: - outlet(s)
    //MARK:-
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var imgAvtar: UIImageView!
    @IBOutlet var btnLike_Dislike: UIButton!
    @IBOutlet var viewLine:UIView!
    
    //MARK: - local(s)
    //MARK:-
    var ontapLike_dislike:()->() = {}
    
    //MARK: - action(s)
    //MARK:-
    @IBAction func ontapLike_DislikeBtn(_ sender: UIButton){
        self.ontapLike_dislike()
    }
}

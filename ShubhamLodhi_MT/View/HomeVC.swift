//
//  HomeVC.swift
//  ShubhamLodhi_MT
//
//  Created by SHUBHAM on 21/11/24.
//

import UIKit
import Alamofire
import ObjectMapper
import Kingfisher
import CoreData

class HomeVC: UIViewController {
    
    //MARK: - outlet(s)
    //MARK:-
    @IBOutlet var lblAllMember: UILabel!
    @IBOutlet var lblSavedMember: UILabel!
    
    @IBOutlet var viewAllMember: UIView!
    @IBOutlet var viewSavedMember: UIView!
    
    @IBOutlet var btnAllMember: UIButton!
    @IBOutlet var btnSavedMember: UIButton!
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet var list: UICollectionView!
    
    //MARK: - local Var(s)
    //MARK:-
    private var viewModel = HomeViewModel()
    private var isFavorite: Bool = false
    
    //MARK: - view didload method(s)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.onntap_tabBar(btnAllMember)
        self.initialSetup()
    }
    
    //MARK: - method action(s)
    //MARK:-
    @IBAction func onntap_tabBar(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 1:
            self.isFavorite = false
            self.viewModel.dataArr = self.viewModel.fetchUsersFromCoreData(isFavorite: false)

            lblAllMember.textColor = UIColor(named: "customBrown")
            viewAllMember.backgroundColor = UIColor(named: "customBrown")
            lblSavedMember.textColor = .systemGray
            viewSavedMember.backgroundColor = .clear
        case 2:
            self.isFavorite = true
            self.viewModel.dataArr = self.viewModel.fetchUsersFromCoreData(isFavorite: true)
            lblAllMember.textColor = .systemGray
            viewAllMember.backgroundColor = .clear
            
            lblSavedMember.textColor = UIColor(named: "customBrown")
            viewSavedMember.backgroundColor = UIColor(named: "customBrown")
            
        default:
            print("no case match")
        }
        if viewModel.dataArr.count == 0{
            self.lblNoDataFound.isHidden = false
        }else{
            self.lblNoDataFound.isHidden = true
        }
        self.list.reloadData()
    }
    
    //MARK: - initial setup(s)
    //MARK:-
    private func initialSetup(){
        self.btnAllMember.isEnabled = false
        self.btnSavedMember.isEnabled =  false
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.list.reloadData()
            }
        }
        
        viewModel.showAlert = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(message)
            }
        }
        
        viewModel.fetchData()
        self.btnAllMember.isEnabled = true
        self.btnSavedMember.isEnabled =  true
    }
}

//MARK: - List(s)
//MARK:-
extension HomeVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.dataArr.count !=  0  {
            self.lblNoDataFound.isHidden = true 
        }
        return viewModel.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let data = viewModel.dataArr[indexPath.row]
        cell.lblName.text = "\(data.first_name ?? "") \(data.last_name ?? "")"
        cell.lblEmail.text = data.email ?? ""
        
        cell.imgAvtar.kf.indicatorType = .activity
        
        cell.imgAvtar.kf.setImage(with: URL(string: data.avatar ?? ""))
        
        if !data.isFavorite {
            let image = UIImage(systemName: "heart")
            cell.btnLike_Dislike.setImage(image, for: .normal)
        }else{
            let image = UIImage(systemName: "heart.fill")
            cell.btnLike_Dislike.setImage(image, for: .normal)
        }
        
        cell.ontapLike_dislike  =  {
            self.viewModel.updateUserInCoreData(userId: Int64(data.id), isFavorite: !data.isFavorite) { isFavorite in
                if !data.isFavorite {
                    let image = UIImage(systemName: "heart")
                    cell.btnLike_Dislike.setImage(image, for: .normal)
                }else{
                    let image = UIImage(systemName: "heart.fill")
                    cell.btnLike_Dislike.setImage(image, for: .normal)
                }
            }
        }
        
        if (viewModel.dataArr.last?.id == data.id) {
            cell.viewLine.isHidden = true
        }else{
            cell.viewLine.isHidden = false
        }
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: 150)
    }
}

//MARK: - showAlert(s)
//MARK:-
extension HomeVC {
    private func showAlert(_ title: String){
        let alertController = UIAlertController(title: "warning!", message: title, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok", style: .default) { _ in
            self.dismiss(animated: true)
        }
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

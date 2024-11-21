//
//  HomeVM.swift
//  ShubhamLodhi_MT
//
//  Created by SHUBHAM on 21/11/24.
//

import Foundation
import Alamofire
import ObjectMapper
import CoreData

final class HomeViewModel {
    //MARK: - local(s)
    //MARK:-
    var dataArr: [User_] = []
    
    var reloadData: (() -> Void)?
    var showAlert: ((String) -> Void)?
    
    //MARK: - fetch data from api(s)
    //MARK:-
    func fetchData() {
        AF.request("https://reqres.in/api/users?page=2", method: .get).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let value = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                    
                    guard let jsonData = value["data"] as? [[String: Any]] else {
                        self.showAlert?("Failed to parse JSON")
                        return
                    }
                    
                    let users = Mapper<UserData>().mapArray(JSONArray: jsonData)
                    users.forEach { user in
                        self.saveUserToCoreData(user: user)
                    }
                    
                    self.dataArr = self.fetchUsersFromCoreData(isFavorite: false)
                    self.reloadData?()
                } catch {
                    self.showAlert?("Error in json serialization: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                self.showAlert?("Request failed: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - save core data(s)
    //MARK:-
    private func saveUserToCoreData(user: UserData) {
        let context = PersistantStorage.shared.context
        
        if isUserIDExist(userId: Int64(user.id ?? 0)) {
            print("User with ID \(user.id ?? 0) already exists. Skipping save.")
            return
        }
        
        let userEntity = User_(context: context)
        userEntity.id = Int32(Int64(user.id ?? 0))
        userEntity.first_name = user.first_name
        userEntity.last_name = user.last_name
        userEntity.email = user.email
        userEntity.avatar = user.avatar
        
        do {
            try context.save()
            print("User \(user.first_name ?? "") saved to Core Data")
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }
    
    //MARK: - get saved core data(s)
    //MARK:-
     func fetchUsersFromCoreData(isFavorite: Bool) -> [User_] {
        let context = PersistantStorage.shared.context
        let fetchRequest: NSFetchRequest<User_> = User_.fetchRequest()
        
        if isFavorite {
            fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
        }
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch users: \(error.localizedDescription)")
            return []
        }
    }
    
    //MARK: - check if user id exist(s)
    //MARK:-
    private func isUserIDExist(userId: Int64) -> Bool {
        let context = PersistantStorage.shared.context
        let fetchRequest: NSFetchRequest<User_> = User_.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", userId)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking for ID: \(error.localizedDescription)")
            return false
        }
    }
    
    //MARK: - update user(s)
    //MARK:-
    func updateUserInCoreData(userId: Int64, isFavorite: Bool,completion: @escaping (Bool)->()) {
        let context = PersistantStorage.shared.context
        
        if let userEntity = fetchUserByID(userId: userId) {
            userEntity.isFavorite
            = isFavorite
            
            do {
                try context.save()
                completion(true)
                print("User with ID \(userId) updated successfully.")
            } catch {
                completion(false)
                print("Failed to update user: \(error.localizedDescription)")
            }
        } else {
            completion(false)
            print("User with ID \(userId) not found.")
        }
    }
    
    //MARK: - fetch user  with id(s)
    //MARK:-
    private func fetchUserByID(userId: Int64) -> User_? {
        let context = PersistantStorage.shared.context
        
        let fetchRequest: NSFetchRequest<User_> = User_.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", userId)
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            print("Error fetching user by ID: \(error.localizedDescription)")
            return nil
        }
    }
}

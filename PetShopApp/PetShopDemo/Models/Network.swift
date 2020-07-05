//
//  Network.swift
//  PetShopDemo
//
//  Created by Ryuuzaki on 2020/07/06.
//

import Foundation


// MARK: - Settings
struct Settings: Codable {
   var settings: SettingsClass
}

// MARK: - SettingsClass
struct SettingsClass: Codable {
   let isChatEnabled, isCallEnabled: Bool
   let workHours: String
   var startTime: String?
   var endTime: String?
}








// MARK: - URL Result Errors
enum NetworkError: Error {
   case error
   case httpError
   case noData
   case stringError
   case jsonError
}





// MARK: - Settings
struct Pets: Codable {
   let pets: [Pet]?
}

// MARK: - Pet
struct Pet: Codable, Identifiable, Hashable {
   let id = UUID()
   let imageURL: String?
   let title: String?
   let contentURL: String?
   let dateAdded: String?

   enum CodingKeys: String, CodingKey {
      case imageURL = "image_url"
      case title
      case contentURL = "content_url"
      case dateAdded = "date_added"
   }
}




struct Network {

   func getSettings(completion: @escaping (Result<Settings, NetworkError>) -> Void) {
      let url = URL(string: "https://ryuuzaki.jp/demo/petshop/config.json")!
      let task = URLSession.shared.dataTask(with: url) { data, response, error in

         if error != nil {
            DispatchQueue.main.async {
               completion(.failure(.error))
            }
         return
         }


         if let data = data {
            if var settingsString = String(data: data, encoding: .utf8) {
               // Need brackets to be a valid JSON.
               settingsString = "{\n" + settingsString + "\n}"

               if let settingsData = settingsString.data(using: .utf8) {
                  let decoder = JSONDecoder()
                  do {
                     var settingsDecoded = try decoder.decode(Settings.self, from: settingsData)

                     let hoursComponents = settingsDecoded.settings.workHours.split(separator: " ")
                     settingsDecoded.settings.startTime = hoursComponents[1].description
                     settingsDecoded.settings.endTime = hoursComponents[3].description

                     DispatchQueue.main.async {
                        completion(.success(settingsDecoded))
                        print(settingsDecoded)
                     }
                  } catch {
                     print("Failed to decode JSON")
                  }
               } else {
                  DispatchQueue.main.async {
                     completion(.failure(.stringError))
                  }
               }
            } else {
               DispatchQueue.main.async {
                  completion(.failure(.stringError))
               }
            }
         } else {
            DispatchQueue.main.async {
               completion(.failure(.noData))
            }
         }
      }
      task.resume()
   }



   func getPets(completion: @escaping (Result<[Pet], NetworkError>) -> Void) {
      let url = URL(string: "https://ryuuzaki.jp/demo/petshop/pets.json")!
      let task = URLSession.shared.dataTask(with: url) { data, response, error in

         if error != nil {
            DispatchQueue.main.async {
               completion(.failure(.error))
            }
            return
         }

         if let data = data {
            if var petsString = String(data: data, encoding: .utf8) {
               // Need brackets to be a valid JSON.
               petsString = "{\n" + petsString + "\n}"

               if let petsData = petsString.data(using: .utf8) {
                  let decoder = JSONDecoder()
                  do {
                     let petsDecoded = try decoder.decode(Pets.self, from: petsData).pets


                     DispatchQueue.main.async {
                        completion(.success(petsDecoded!))
//                        print(petsDecoded!)
                     }
                  } catch {
                     print("Failed to decode JSON")
                  }
               } else {
                  DispatchQueue.main.async {
                     completion(.failure(.stringError))
                  }
               }
            } else {
               DispatchQueue.main.async {
                  completion(.failure(.stringError))
               }
            }
         } else {
            DispatchQueue.main.async {
               completion(.failure(.noData))
            }
         }
      }
      task.resume()
   }









}

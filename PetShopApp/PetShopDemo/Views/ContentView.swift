//
//  ContentView.swift
//  PetShopDemo
//
//  Created by Ryuuzaki on 2020/07/06.
//

import SwiftUI





struct ContentView: View {

   @State var settings = SettingsClass(isChatEnabled: true, isCallEnabled: true, workHours: "M-F 9:00 - 18:00", startTime: "9:00", endTime: "18:00")
   @State var showingAlert = false
   @State var withinHours = false
   @State var pets: [Pet]? = nil

   let alertMessages = ["Thank you for getting in touch with us. We’ll get back to you as soon as possible",
                        "Work hours has ended. Please contact us again on the next work day"]


    var body: some View {
      ZStack {
         NavigationView {
            VStack {
               EmptyView()

               // MARK: - Cotnact Buttons
               HStack {
                  if settings.isChatEnabled {
                     Button(action: {

                        checkTime()

                     }, label: {
                        HStack {
                           Spacer()
                           Text("Chat")
                              .foregroundColor(.white)
                              .font(.largeTitle)
                           Spacer()
                        }
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                     })
                     .alert(isPresented: $showingAlert) {
                        Alert(title: Text(withinHours ? alertMessages[0] : alertMessages[1]

                        ))
                     }
                  }
                  if settings.isCallEnabled {
                     Button(action: {
                        checkTime()
                     }, label: {
                        HStack {
                           Spacer()
                           Text("Call")
                              .foregroundColor(.white)
                              .font(.largeTitle)
                           Spacer()
                        }
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)

                     })
                  }
               }

               // MARK: - Working Hours
               HStack {
                  Spacer()
                  Text("Office Hours: " + settings.workHours)
                     .font(.title3)
                  Spacer()
               }
               .padding(.vertical, 10)
               .border(Color(UIColor.gray), width: 1)
               .padding(.all, 10)





               // MARK: - PETS LIST
               if pets != nil {
                  List(pets!) { (pet) in

                     NavigationLink(destination:
                                       WebView(request: URLRequest(url: URL(string: pet.contentURL ?? "https://google.com")!))
                                       .navigationBarTitle(pet.title ?? "")
                                       .navigationBarHidden(false)
                     ) {
                        HStack {
                           URLImageView(url: pet.imageURL ?? "") { (Image) in
                              Image.renderingMode(.original)
                                 .resizable()
                                 .scaledToFit()
                                 .frame(width: 100.0, height: 100.0)
                           }
                           Text(pet.title ?? "No title")
                              .font(.title)
                        }
                     }


                  }
               }


            }
            .navigationBarTitle("")
            .navigationBarHidden(true)

         }
         .onAppear {

            Network().getSettings { (result) in
               switch result {
                  case .success(let gotSettings):
                     settings = gotSettings.settings
                  case .failure(_):
                     print("Error getting settings")
               }
            }

            Network().getPets { (result) in
               switch result {
                  case .success(let gotPets):
                     pets = gotPets
                     print(pets ?? "No pets")
                  case .failure(_):
                     print("Error getting pets")
               }
            }

         }
      }
    }


   func checkTime() {
      let hour = Calendar.current.component(.hour, from: Date())
      let minute = Calendar.current.component(.minute, from: Date())
      let currentTime = String(format: "%02d", hour) + ":" + String(format: "%02d", minute)

      if isWithinhours(current: currentTime, start: settings.startTime, end: settings.endTime) {
         withinHours = true
      } else {
         withinHours = false
      }
      showingAlert = true
   }


   func isWithinhours(current: String, start: String?, end: String?) -> Bool {

      let inFormatter = DateFormatter()
      inFormatter.locale = Locale(identifier: "POSIX")
      inFormatter.dateFormat = "HH:mm"

      let currentDate = inFormatter.date(from: current)!
      print(currentDate.debugDescription)

      let startDate = inFormatter.date(from: start!)!
      print(startDate.debugDescription)

      let endDate = inFormatter.date(from: end!)!
      print(endDate.debugDescription)


      if startDate <= currentDate && currentDate <= endDate {
         return true
      } else {
         return false
      }

   }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
         ContentView()
         ContentView()
            .preferredColorScheme(.dark)

      }
    }
}

//
// Created by Richard Martin on 29/03/2023.
//

import SwiftUI

struct CreateFestivalView: View {

    @Binding var token: String

    struct FestivalPayload {
        var name: String
        var year: Int
        var active: Bool
        var duration: Int
        var zones: [Zone]
        var days: Set<DateComponents>
    }

    @State var festival: FestivalPayload = FestivalPayload(name: "", year: Calendar.current.component(.year, from: Date()), active: true, duration: 0, zones: [], days: [])

    @State var errorSign: Bool = false
    @State var isSignedIn: Bool = false
    var result : String = ""

    var body: some View {
        ScrollView {
            Toggle("Active", isOn: $festival.active)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10.0)
                    .padding(.bottom, 20)
                    .padding(.horizontal,20)
            VStack(alignment : .leading){
                Text("Name")
                        .font(.caption)
                TextField("", text: $festival.name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10.0)
            }
                    .padding(.bottom, 20)
                    .padding(.horizontal,20)
            VStack(alignment: .leading) {
                Text("Duration")
                        .font(.caption)
                TextField("", value: $festival.duration, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10.0)

            }
                    .padding(.bottom, 20)
                    .padding(.horizontal,20)
            MultiDatePicker("Date", selection: $festival.days, in: Date()...)
                    .background(Color(.systemGray6))
                    .cornerRadius(10.0)
                    .padding(.bottom,20)
                    .padding(.horizontal,20)
            Button("Create Festival",action: {
//                FestivalService().createFestival(festival: festival, token: token) { result in
//                    switch result {
//                    case .success(let festival):
//                        print(festival)
//                    case .failure(let error):
//                        print(error)
            })
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10.0)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

        }
                .gesture(
                        TapGesture()
                                .onEnded { _ in
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                )
    }
}

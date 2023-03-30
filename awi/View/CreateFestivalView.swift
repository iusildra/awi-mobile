//
// Created by Richard Martin on 29/03/2023.
//

import SwiftUI

struct CreateFestivalView: View {

    @Binding var token: String

    @State var festival: CreateFestivalPayload
    @State private var dates = Set<DateComponents>()
    @State var times: [Date: (opening: Date, closing: Date)] = [:]
    private var datesArray: [Date] {dates.compactMap { Calendar.current.date(from: $0) }}

    @State var errorSign: Bool = false
    @State var isSignedIn: Bool = false
    var result : String = ""
    
    init(token: Binding<String>) {
        self.festival = CreateFestivalPayload(name: "", year: Calendar.current.component(.year, from: Date()), active: true, duration: 0, festival_days: [])
        self._token = token
    }
    
    init(token: Binding<String>, festival: FestivalDTO) {
        let days = festival.festival_days.map{CreateFestivalDayPayload(date: $0.date, open_at: $0.open_at, close_at: $0.close_at)}
        self.festival = CreateFestivalPayload(name: festival.name, year: festival.year, active: festival.active, duration: festival.duration, festival_days: days)
        self._token = token
    }

    var body: some View {
        Form {
            ScrollView {
                activeToggleSection
                nameSection
                durationSection
                dateSection
                DisclosureGroup("Dates") {
                    timesSection
                }
                DisclosureGroup("Zones") {
                    
                }
                createFestivalButton
            }
        }
    }
        
    private var activeToggleSection: some View {
        Toggle("Active", isOn: $festival.active)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10.0)
            .padding(.bottom, 20)
            .padding(.horizontal,20)
    }
    
    private var nameSection: some View {
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
    }
    
    private var durationSection: some View {
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
    }
    
    private var dateSection: some View {
        MultiDatePicker("Date", selection: self.$dates, in: Date()...)
            .background(Color(.systemGray6))
            .cornerRadius(10.0)
            .padding(.bottom,20)
            .padding(.horizontal,20)
    }
    
    private var timesSection: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(datesArray, id: \.self) { date in
                    VStack {
                        Text(date, style: .date)
                            .font(.headline)
                        Divider()
                        openingTimeTextField(for: date)
                        closingTimeTextField(for: date)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    private func dateBinding(_ date: Date, opening: Bool) -> Binding<Date> {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let now = Date()
        let defaultTime = formatter.string(from: now)
        let defaultDate = formatter.date(from: defaultTime)!
        
        if opening {
            return Binding<Date>(
                get: { times[date]?.opening ?? defaultDate},
                set: { times[date] = (opening: $0, closing: times[date]?.closing ?? defaultDate) }
            )
        } else {
            return Binding<Date>(
                get: { times[date]?.closing ?? defaultDate},
                set: { times[date] = (opening: times[date]?.opening ?? defaultDate, closing: $0) }
            )
        }
    }
    
    private func openingTimeTextField(for date: Date) -> some View {
        HStack {
            Text("Opening:")
            DatePicker("", selection: dateBinding(date, opening: true), displayedComponents: [.hourAndMinute])
                .labelsHidden()
                .datePickerStyle(.automatic)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .fixedSize()
        }
    }
    
    private func closingTimeTextField(for date: Date) -> some View {
        HStack {
            Text("Closing:")
            DatePicker("", selection: dateBinding(date, opening: false), displayedComponents: [.hourAndMinute])
                .labelsHidden()
                .datePickerStyle(.automatic)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .fixedSize()
        }
    }
    
    private var createFestivalButton: some View {
        Button("Create Festival", action: {
            FestivalDAO.createFestival(
                CreateFestivalPayload(
                name: self.festival.name,
                year: self.festival.year,
                active: self.festival.active,
                duration: self.festival.duration,
                festival_days: self.times.map { (day, openingClosing) -> CreateFestivalDayPayload in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH:mm:ss"
                    let (opening, closing) = openingClosing
                    return CreateFestivalDayPayload(date: dateFormatter.string(from: day), open_at: timeFormatter.string(from: opening), close_at: timeFormatter.string(from: closing))
                }), token: self.token)
        })
   }
}

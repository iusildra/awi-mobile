import SwiftUI

struct FestivalView: View {
    var intent: FestivalIntent
    @ObservedObject var viewModel: FestivalViewModel
    @ObservedObject var listViewModel: FestivalListViewModel
    @State var errorMessage: String = ""
    @State var showErrorMessage: Bool = false
    @State private var showingAlert = false
    @State private var showingIncorrect = false
    @State private var modify = false
    @Binding private var token: String
    
    init(vm: FestivalViewModel, listVM: FestivalListViewModel, token: Binding<String>) {
        self.viewModel = vm
        self.intent = FestivalIntent(vm: vm)
        self.intent.addObserver(vm: vm)
        self.listViewModel = listVM
        self._token = token
    }
    
    private var festivalsName: [String] {
        return listViewModel.data.map{$0.name}
    }
    
    private var valueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    private var timeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }


    var body: some View {
        ScrollView {
            VStack {
                switch self.viewModel.deletionState {
                case .READY:
                    VStack {
                        Text("ID: \(self.viewModel.festival.id)")
                        Divider()
                        HStack {
                            Text("Year: \(self.viewModel.year)")
                            Divider()
                            Text("Active: \(self.viewModel.active ? "true" : "false")")
                            Divider()
                            Text("Duration: \(self.viewModel.duration)")
                        }
                    }
                    Divider()
                    if !modify {
                        Button(action: {
                            modify = true
                        }){
                            HStack {
                                Text("Modifier")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                Button(action: {
                                    FestivalDAO.deleteFestival(vm: self.viewModel, token: self.token)
                                }){
                                    Text("Supprimer")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.red)
                                            .cornerRadius(8)
                                }
                            }
                        }
                    }
                    if modify {
                            VStack {
                                HStack {
                                    Text("Name : ").fontWeight(.bold).padding()
                                    TextField("", text: $viewModel.name).padding().onSubmit {
                                        intent.intentToChange(name: self.viewModel.name)
                                    }
                                }
                                HStack {
                                    Text("Year: ").fontWeight(.bold).padding()
                                    TextField("", value: $viewModel.year, formatter: valueFormatter).onSubmit {
                                        intent.intentToChange(year: self.viewModel.year)
                                    }
                                }
                                HStack {
                                    Text("Active: ").fontWeight(.bold).padding()
                                    Toggle("Active", isOn: $viewModel.active).onSubmit {
                                        intent.intentToChange(active: self.viewModel.active)
                                    }
                                }
                                HStack {
                                    Text("Duration: ").fontWeight(.bold).padding()
                                    TextField("", value: $viewModel.duration, formatter: valueFormatter).onSubmit {
                                        intent.intentToChange(duration: self.viewModel.duration)
                                    }
                                }
                                Button(action: {
                                    self.modify = false
                                    FestivalDAO.updateFestival(festivalId: self.viewModel.festival.id, name: self.viewModel.name, year: self.viewModel.year, active: self.viewModel.active, duration: self.viewModel.duration, vm: self.viewModel, token: self.token)
                                }, label: { Text("Save") })
                        }
                    }
                    Divider()
                    ScrollView {
                        ForEach(self.viewModel.days, id: \.self, content: { day in
                            let dateString = dateFormatter.string(from: (try? Date(day.date, strategy: .iso8601)) ?? Date())
                            let openString = (try? Date(day.openAt, strategy: .iso8601)) == nil ? "N/A" : dateFormatter.string(from: try! Date(day.openAt, strategy: .iso8601))
                            let closeString = (try? Date(day.closeAt, strategy: .iso8601)) == nil ? "N/A" : dateFormatter.string(from: try! Date(day.closeAt, strategy: .iso8601))
                            VStack {
                                Text("Day: \(day.date)")
//                                Text("Date: \(dateString)")
//                                Text("Open: \(openString)")
                                Text("Open at : \(day.openAt)")
                                Text("Close: \(day.closeAt)")
//                                Text("Close: \(closeString)")
                            }.padding(8)
                        })
                    }
                    Divider()
                    ZoneListView(viewModel: ZoneListViewModel(data: self.viewModel.festival.zones), token: self.$token)
                case .DELETING:
                    Text("Festival deletion...")
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(2)
                        .scaleEffect(2)
                case .DELETED:
                    Divider()
                    Text("Festival deleted")
                    Divider()
                    Text("You can return to the main festival list and refresh")
                case .ERROR:
                    Text("Error when deleting, please try again later")
                    Divider()
                    Button(action: {
                        self.intent.deleted()
                    }) {
                        Text("Ok")
                    }
                }
            }
        }.navigationTitle("\(viewModel.name)").onChange(of: viewModel.error){ error in
            switch error {
            case .NONE:
                return
            case .NAME(let name):
                self.errorMessage = name
                self.showErrorMessage = true
            case .YEAR(let nb):
                self.errorMessage = "\(nb)"
                self.showErrorMessage = true
            case .DURATION(let nb):
                self.errorMessage = "\(nb)"
                self.showErrorMessage = true
            case .DAYS(let days):
                self.errorMessage = "\(days)"
                self.showErrorMessage = true
            case .ZONES(let zones):
                self.errorMessage = "\(zones)"
                self.showErrorMessage = true
            }
        }.alert("\(errorMessage)", isPresented: $showErrorMessage){
            Button("Ok", role: .cancel) { self.showErrorMessage = false}
        }
    }
}

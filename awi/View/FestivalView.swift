import SwiftUI

struct FestivalView: View {
    var intent: FestivalIntent
    @ObservedObject var viewModel: FestivalViewModel
    @State var errorMessage: String = ""
    @State var showErrorMessage: Bool = false
    @State private var showingAlert = false
    @State private var showingIncorrect = false
    @State private var modify = false
    
    init(vm: FestivalViewModel) {
        self.viewModel = vm
        self.intent = FestivalIntent(vm: vm)
        self.intent.addObserver(vm: vm)
    }
    
    private var valueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    var body: some View {
        ScrollView {
            VStack {
                switch self.viewModel.deletionState {
                case .READY:
                    Divider()
                    HStack {
                        Text("Year: \(self.viewModel.year)")
                        Divider()
                        Text("Active: \(self.viewModel.active ? "true" : "false")")
                        Divider()
                        Text("Duration: \(self.viewModel.duration)")
                    }
                    Divider()
                    ZoneListView(viewModel: ZoneListViewModel(data: self.viewModel.zones), editable: false)
                    if modify {
                        Section {
                            VStack {
                                HStack {
                                    Text("Name : ").fontWeight(.bold).padding()
                                    TextField("", text: $viewModel.name).padding().onSubmit {}
                                    Button("Modifier") {
                                        //TODO: if festivallist contains -> cannot change
                                        intent.intentToChange(name: self.viewModel.name)
                                    }.padding()
                                }
                                HStack {
                                    Text("Year: ").fontWeight(.bold).padding()
                                    TextField("", value: $viewModel.year, formatter: valueFormatter)
                                    Button("Modifier") {
                                        intent.intentToChange(year: self.viewModel.year)
                                    }
                                }
                                HStack {
                                    Text("Active: ").fontWeight(.bold).padding()
                                    Toggle("Active", isOn: $viewModel.active)
                                    Button("Modifier") {
                                        intent.intentToChange(active: self.viewModel.active)
                                    }
                                }
                                HStack {
                                    Text("Duration: ").fontWeight(.bold).padding()
                                    TextField("", value: $viewModel.duration, formatter: valueFormatter)
                                    Button("Modifier") {
                                        intent.intentToChange(duration: self.viewModel.duration)
                                    }
                                }
                            }
                        }
                    }
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

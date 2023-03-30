import SwiftUI

struct ZoneView: View {
    var intent: ZoneIntent
    @ObservedObject var viewModel: ZoneViewModel
    @State var errorMessage: String = ""
    @State var showErrorMessage: Bool = false
    @State private var showingAlert = false
    @State private var showingIncorrect = false
    @State private var modify = false
    @Binding var token: String
    // Different lists...
    
    init(vm: ZoneViewModel, token: Binding<String>) {
        self.viewModel = vm
        self.intent = ZoneIntent(vm: vm)
        self.intent.addObserver(vm: vm)
        self._token = token
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
                    if !modify {
                        HStack {
                            Button(action: {
                                modify = true
                            }){
                                Text("Modifier")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                ZoneDAO.deleteZone(vm: self.viewModel, token: self.token)
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
                    VStack {
                        Text("Festival ID : \(self.viewModel.festivalId)")
                        Divider()
                        Text("Required volunteers : \(self.viewModel.nbRequiredVolunteers)")
                    }
                    if modify {
                        VStack {
                            VStack(alignment: .leading) {
                                Text("Name : ").font(.caption)
                                TextField("", text: $viewModel.name).padding().onSubmit {
                                    intent.intentToChange(name: self.viewModel.name)
                                }
                                        .fontWeight(.bold)
                                        .padding(10)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                            }
                                    .padding()
                            VStack(alignment : .leading) {
                                Text("Required volunteers : ").font(.caption)
                                TextField("", value: $viewModel.nbRequiredVolunteers, formatter: valueFormatter).onSubmit {
                                            intent.intentToChange(name: self.viewModel.name)
                                        }
                                        .fontWeight(.bold)
                                        .padding(10)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                            }
                                    .padding()
                            Button(action: {
                                self.modify = false
                                ZoneDAO.updateZone(zoneId: self.viewModel.zone.id, name: self.viewModel.name, nbRequiredVolunteers: self.viewModel.nbRequiredVolunteers, vm: self.viewModel, token: self.token)
                            }, label: { Text("Save") })
                        }
                    }
                case .DELETING:
                    Text("Zone deletion...")
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(2)
                        .scaleEffect(2)
                case .DELETED:
                    Divider()
                    Text("Zone deleted")
                    Divider()
                    Text("You can return to the main zone list and refresh")
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
            case .NB_VOLUNTEERS(let nb):
                self.errorMessage = "\(nb)"
                self.showErrorMessage = true
            }
        }.alert("\(errorMessage)", isPresented: $showErrorMessage){
            Button("Ok", role: .cancel) { self.showErrorMessage = false}
        }
    }
}

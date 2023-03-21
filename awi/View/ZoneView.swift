import SwiftUI

struct ZoneView: View {
    var intent: ZoneIntent
    @ObservedObject var viewModel: ZoneViewModel
    @State var errorMessage: String = ""
    @State var showErrorMessage: Bool = false
    @State private var showingAlert = false
    @State private var showingIncorrect = false
    @State private var modify = false
    // Different lists...
    
    init(vm: ZoneViewModel) {
        self.viewModel = vm
        self.intent = ZoneIntent(vm: vm)
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
                        Spacer()
                        HStack {
                            Text("\(viewModel.name)").fontWeight(.bold).font(.system(size: 22))
                        }
                        Spacer()
                    }.frame(alignment: .center)
                    Divider()
                    HStack {
                        Text("Festival ID : \(self.viewModel.festivalId)")
                        Divider()
                        Text("Required volunteers : \(self.viewModel.nbRequiredVolunteers)")
                    }
                    if modify {
                        Section {
                            VStack {
                                HStack {
                                    Text("Name : ").fontWeight(.bold).padding()
                                    TextField("", text: $viewModel.name).padding().onSubmit {}
                                    Button("Modifier") {
                                        //TODO: if zonelist contains -> cannot change
                                        intent.intentToChange(name: self.viewModel.name)
                                    }.padding()
                                }
                                Text("Festival ID : \(self.viewModel.festivalId)").padding()
                                HStack {
                                    Text("Required volunteers : ").fontWeight(.bold).padding()
                                    TextField("", value: $viewModel.nbRequiredVolunteers, formatter: valueFormatter)
                                }
                            }
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

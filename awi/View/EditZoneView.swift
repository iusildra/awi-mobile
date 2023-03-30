import SwiftUI

struct EditZoneView: View {
    @State var name: String = ""
    @State var festivalName: String = ""
    @State var festivalId: String = ""
    @State var volunteerRequired: Int = -1
    @State var zoneName: String = ""
    @State var zone: Zone?
    @ObservedObject var viewModelCreation: ZoneViewModel = ZoneViewModel(zone: Zone(id: -1, name: "", festivalId: "", nbVolunteers: -1))
    @ObservedObject var zoneListVM: ZoneListViewModel
    @Binding private var token: String
    
    private var creationState : CreateZoneIntentState {
        return viewModelCreation.creationState
    }
    
    var zoneNameList: [String] {
        return zoneListVM.datavm.map{$0.name}
    }
    
    init(zoneListVM: ZoneListViewModel, token: Binding<String>) {
        self.zoneListVM = zoneListVM
        self._token = token
    }
    
    var body: some View {
        NavigationView{
            VStack{
                switch creationState {
                case .READY:
                    Text("Create or edit a zone. You can edit it later")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                    Divider()
                    HStack {
                        Picker("Zone", selection: $zoneName) {
                            ForEach(self.zoneListVM.data.map{$0.name}, id: \.self) {
                                text in Text(text)
                            }
                        }
                    }
                    Form{
                        Section(header: Text("Zone edition")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)){
                            HStack{
                                Text("Name: ")
                                    .fontWeight(.bold)
                                TextField("name", text: $name)
                            }
                            if zoneNameList.contains(where: { $0.lowercased() == name.lowercased()}) {
                                Text("Name already in use")
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            }
                            HStack{
                                Text("Required volunteers :")
                                    .fontWeight(.bold)
                                TextField("count", value: $volunteerRequired, formatter: NumberFormatter())
                            }
                            
                            if (name != "") && volunteerRequired > 0 && festivalName.count > 0 {
                                Section {
                                    Divider()
                                    Button(action: {ZoneDAO.createZone(name: name, festivalId: festivalId, nbRequiredVolunteers: volunteerRequired, vm: viewModelCreation, token: self.token)}){
                                        Text("Validate")
                                            .fontWeight(.bold)
                                            .frame(alignment: .center)
                                    }
                                }
                            }
                        }
                    }
                case .CREATING:
                    Text("Editing...")
                        .foregroundColor(.black)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(2)
                case .CREATED:
                    Text("Zone \(name) successfully edited" )
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding()
                    Divider()
                    Button(action: {
                        name = ""
                        festivalId = ""
                        volunteerRequired = 1
                        ZoneIntent(vm: viewModelCreation).created()
                    }){
                        Text("Roger roger")
                            .fontWeight(.bold)
                            .frame(alignment: .center)
                        Text("You will be redirected to the edit page")
                            .italic()
                    }
                case .ERROR:
                    Text("Error when editing, please try again later")
                        .fontWeight(.bold)
                        .italic()
                    Divider()
                    Button(action: {
                        name = ""
                        festivalId = ""
                        volunteerRequired = 1
                        ZoneIntent(vm: viewModelCreation).created()
                    }){
                        Text("Ok")
                            .fontWeight(.bold)
                            .frame(alignment: .center)
                    }
                }
            }
        }
        .navigationTitle("Create a zone")
        .foregroundColor(.blue)
    }
}

/*struct EditZoneView_Previews: PreviewProvider {
    static var previews: some View {
        EditZoneView(zoneListVM: ZoneListViewModel())
    }
}*/

import Foundation

struct CreateZonePayload: Codable {
    let name: String
    let festival_id: String
    let nb_volunteers: Int
}

struct UpdateZonePayload: Codable {
    let name: String
    let nb_volunteers: Int
}

class ZoneDAO {
    static func fetchZone(list : ZoneListViewModel){
        list.datavm = []
        list.data = []
        list.fetching = true
        
        let surl = API_ZONE
        guard let url = URL(string: surl) else { print(CREATE_URL_ERROR); return }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data,response,error in
            guard let data = data else{return}
            do{
                let dataDTO : [ZoneDTO] = try JSONDecoder().decode([ZoneDTO].self, from: data)
                
                for zone in dataDTO{
                    let zone = Zone(id: zone.id, name: zone.name, festivalId: zone.festival_id, nbVolunteers: zone.nb_volunteers)
                    list.data.append(zone)
                    let vm = ZoneViewModel(zone: zone)
                    vm.delegate = list
                    list.datavm.append(vm)
                }
                DispatchQueue.main.async {
                    ZoneListViewIntent(list : list ).zonesLoaded()
                    list.fetching = false
                }
                
            }catch{
                DispatchQueue.main.async {
                    list.fetching = false
                    list.zoneListState = .loadingError("\(error)")
                    print("error")
                }
                print("Error: \(error)")
            }

        }.resume()
    }
    static func deleteZone(vm: ZoneViewModel, token: String) {
        ZoneIntent(vm: vm).deleting(id: vm.zone.id)
        guard let url = URL(string: API_ZONE_UNIQUE(id: vm.zone.id)) else {
            print(CREATE_URL_ERROR)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.DELETE.value
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(httpError(httpMethod: HttpMethod.DELETE))
                ZoneIntent(vm: vm).deletingError(error: error!)
                print(error!)
                return
            }
            guard let _ = data else {
                print(RECEIVE_DATA_ERROR)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print(HTTP_REQUEST_FAILED)
                return
            }
            if response.statusCode == 200 {
                ZoneIntent(vm: vm).zoneDeleted(id: vm.zone.id)
            }
        }.resume()
    }
    
    static func createZone(name: String, festivalId: String, nbRequiredVolunteers: Int, vm: ZoneViewModel, token: String) {
        ZoneIntent(vm: vm).creating()
        guard let url = URL(string: API_ZONE) else {
            print(CREATE_URL_ERROR)
            return
        }
        
        var request = URLRequest(url: url)
        let body = try! JSONEncoder().encode(CreateZonePayload(name: name, festival_id: festivalId, nb_volunteers: nbRequiredVolunteers))
        request.httpMethod = HttpMethod.POST.value
        request.httpBody = body
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(httpError(httpMethod: HttpMethod.POST))
                ZoneIntent(vm: vm).creatingError(error: error!)
                print(error!)
                return
            }
            guard let _ = data else {
                print(RECEIVE_DATA_ERROR)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print(HTTP_REQUEST_FAILED)
                return
            }
            if (response.statusCode == 200) {
                ZoneIntent(vm: vm).zoneCreated()
            }
        }.resume()
    }
    
    static func updateZone(zoneId: Int, name: String, nbRequiredVolunteers: Int, vm: ZoneViewModel, token: String) {
        ZoneIntent(vm: vm).creating()
        guard let url = URL(string: API_ZONE_UNIQUE(id: zoneId)) else {
            print(CREATE_URL_ERROR)
            return
        }
        
        let encoder = JSONEncoder()
        //encoder.outputFormatting = .prettyPrinted
        var request = URLRequest(url: url)
        let body = try! encoder.encode(UpdateZonePayload(name: name, nb_volunteers: nbRequiredVolunteers))
        request.httpMethod = HttpMethod.PATCH.value
        request.httpBody = body
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(httpError(httpMethod: HttpMethod.PATCH))
                ZoneIntent(vm: vm).creatingError(error: error!)
                print(error!)
                return
            }
            guard let _ = data else {
                print(RECEIVE_DATA_ERROR)
                return
            }

            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print(HTTP_REQUEST_FAILED)
                return
            }
            if (response.statusCode == 200) {
                ZoneIntent(vm: vm).zoneCreated()
            }
        }.resume()
    }
}

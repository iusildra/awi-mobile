import Foundation

struct CreateFestivalPayload: Codable {
    let name: String
    let year: Int
    let active: Bool
    let duration: Int
    /*let zones: [Festival]
    let days: [FestivalDay]*/
}

struct UpdateFestivalPayload: Codable {
    let name: String
    let year: Int
    let active: Bool
    let duration: Int
}

class FestivalDAO {
    static func fetchFestival(list : FestivalListViewModel){
        list.datavm = []
        list.data = []
        list.fetching = true
        
        let surl = API_FESTIVAL
            guard let url = URL(string: surl) else { print(CREATE_URL_ERROR); return }

            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data,response,error in
                guard let data = data else{return}
                do{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let customDateDecodingStrategy = JSONDecoder.DateDecodingStrategy.custom { decoder in
                        let container = try decoder.singleValueContainer()
                        let dateString = try container.decode(String.self)
                        guard let date = dateFormatter.date(from: dateString) else {
                            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
                        }
                        return date
                    }
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = customDateDecodingStrategy
                    let dataDTO : [FestivalDTO] = try decoder.decode([FestivalDTO].self, from: data)
                    
                    for festival in dataDTO{
                        let zones = festival.zones.map{Zone(id: $0.id, name: $0.name, festivalId: $0.festival_id, nbVolunteers: $0.nb_volunteers)}
                        let days = festival.festival_days.map{FestivalDay(id: $0.id, date: $0.date, openAt: $0.open_at, closedAt: $0.close_at)}
                        let festival = Festival(id: festival.id, name: festival.name, year: festival.year, active: festival.active, duration: festival.duration, zones: zones, days: days)
                        list.data.append(festival)
                        let vm = FestivalViewModel(festival: festival)
                        vm.delegate = list
                        list.datavm.append(vm)
                    }
                    DispatchQueue.main.async {
                        FestivalListViewIntent(list : list ).festivalsLoaded()
                        list.fetching = false
                    }
                    
                }catch{
                    DispatchQueue.main.async {
                        list.fetching = false
                        list.festivalListState = .loadingError("\(error)")
                    }
                }

            }.resume()
    }
    
    static func deleteFestival(vm: FestivalViewModel, token: String) {
        let festivalId = vm.festival.id
        FestivalIntent(vm: vm).deleting(id: festivalId)
        guard let url = URL(string: API_FESTIVAL_UNIQUE(id: festivalId)) else {
            print(CREATE_URL_ERROR)
            return
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.DELETE.value
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(httpError(httpMethod: HttpMethod.DELETE))
                FestivalIntent(vm: vm).deletingError(error: error!)
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
                FestivalIntent(vm: vm).zoneDeleted(id: festivalId)
            }
        }.resume()
    }
    
    static func updateFestival(festivalId: String, name: String, year: Int, active: Bool, duration: Int, vm: FestivalViewModel, token: String) {
        FestivalIntent(vm: vm).creating()
        guard let url = URL(string: API_FESTIVAL_UNIQUE(id: festivalId)) else {
            print(CREATE_URL_ERROR)
            return
        }
        
        var request = URLRequest(url: url)
        let body = try! JSONEncoder().encode(UpdateFestivalPayload(name: name, year: year, active: active, duration: duration))
        request.httpMethod = HttpMethod.PATCH.value
        request.httpBody = body
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(httpError(httpMethod: HttpMethod.PATCH))
                FestivalIntent(vm: vm).creatingError(error: error!)
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
                FestivalIntent(vm: vm).zoneCreated()
            }
        }.resume()
    }
}

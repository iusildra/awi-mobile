import Foundation

class ZoneDAO {
    static func deleteZone(zoneId: Int, vm: ZoneViewModel) {
        ZoneIntent(vm: vm).deleting(id: zoneId)
        guard let url = URL(string: API_ZONE_UNIQUE(id: zoneId)) else {
            print(CREATE_URL_ERROR)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.DELETE.value
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
                ZoneIntent(vm: vm).zoneDeleted(id: zoneId)
            }
        }.resume()
    }
    
    static func createZone(name: String, festivalId: String, nbRequiredVolunteers: Int, vm: ZoneViewModel) {
        ZoneIntent(vm: vm).creating()
        guard let url = URL(string: API_ZONE) else {
            print(CREATE_URL_ERROR)
            return
        }
        
        var request = URLRequest(url: url)
        let body: [String: Encodable] = [
            "name": name,
            "festival_id": festivalId,
            "nb_volunteers": nbRequiredVolunteers
        ]
        request.httpMethod = HttpMethod.POST.value
        //TODO: add body with this request.httpBody = ???
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
    
    static func updateZone(zoneId: Int, name: String?, nbRequiredVolunteers: Int?, vm: ZoneViewModel) {
        ZoneIntent(vm: vm).creating()
        guard let url = URL(string: API_ZONE_UNIQUE(id: zoneId)) else {
            print(CREATE_URL_ERROR)
            return
        }
        
        var request = URLRequest(url: url)
        let body: [String: Encodable] = [
            "name": name,
            "nb_volunteers": nbRequiredVolunteers
        ]
        request.httpMethod = HttpMethod.PATCH.value
        //TODO: add body with this request.httpBody = ???
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

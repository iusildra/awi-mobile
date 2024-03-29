let API_ROOT = "https://awi-mano-api.cluster-ig4.igpolytech.fr"

let API_ZONE = "\(API_ROOT)/zone"
func API_ZONE_UNIQUE(id: Int) -> String { "\(API_ZONE)/\(id)" }

let API_FESTIVAL = "\(API_ROOT)/festival"
func API_FESTIVAL_UNIQUE (id: String) -> String { "\(API_FESTIVAL)/\(id)" }

let API_VOLUNTEER = "https://awi-mano-api.cluster-ig4.igpolytech.fr/volunteer"

let API_SIGNIN = "\(API_ROOT)/auth/signin"
let API_SIGNUP = "\(API_ROOT)/auth/signup"

let CREATE_URL_ERROR = "Error: Cannot create URL"
let RECEIVE_DATA_ERROR = "Error: Did not receive data"
let HTTP_REQUEST_FAILED = "Error: HTTP request failed"

enum HttpMethod {
    case POST
    case GET
    case PATCH
    case DELETE
    
    var value: String {
        switch self {
        case .POST: return "POST"
        case .GET: return "GET"
        case .PATCH: return "PATCH"
        case .DELETE: return "DELETE"
        }
    }
}

func httpError(httpMethod: HttpMethod) -> String {
    return "Error: error calling \(httpMethod.value)"
}

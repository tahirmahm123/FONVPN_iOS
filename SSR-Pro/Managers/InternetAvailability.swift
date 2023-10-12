
import Foundation
import Foundation
import Connectivity
public class InternetAvailability {
    public static var shared: InternetAvailability = InternetAvailability()
    let connectivity = Connectivity(shouldUseHTTPS: false)
    func connectivityStatus (completion: @escaping (Bool)-> ()){
        connectivity.framework = .network
        connectivity.checkConnectivity { connectivity in
            switch connectivity.status {
            case .connected: completion(true)
            case .connectedViaWiFi: completion(true)
            case .connectedViaWiFiWithoutInternet: completion(false)
            case .connectedViaCellular: completion(true)
            case .connectedViaCellularWithoutInternet: completion(false)
            case .notConnected: completion(false)
            case .determining: completion(false)
            case .connectedViaEthernet: completion(true);
            case .connectedViaEthernetWithoutInternet: completion(false);
            }
        }
    }
    func connectivityStatus() async -> Bool {
        return await withCheckedContinuation { continuation in
            connectivity.framework = .network
            connectivity.checkConnectivity { connectivity in
                switch connectivity.status {
                    case .connected: continuation.resume(returning: true)
                    case .connectedViaWiFi: continuation.resume(returning: true)
                    case .connectedViaWiFiWithoutInternet: continuation.resume(returning: false)
                    case .connectedViaCellular: continuation.resume(returning: true)
                    case .connectedViaCellularWithoutInternet: continuation.resume(returning: false)
                    case .notConnected: continuation.resume(returning: false)
                    case .determining: continuation.resume(returning: false)
                    case .connectedViaEthernet: continuation.resume(returning: true)
                    case .connectedViaEthernetWithoutInternet: continuation.resume(returning: false)
                }
            }
        }
    }

}




struct SecureDNS: Codable {
    
    var address: String? {
        didSet {
            if let address = address {
                serverURL = DNSProtocolType.getServerURL(address: address)
                serverName = DNSProtocolType.getServerName(address: address)
                if #available(iOS 14.0, *) {
                    DNSManager.saveResolvedDNS(server: DNSProtocolType.getServerToResolve(address: address), key: userDefaults.string(forKey: ResolvedDNSOutsideVPN) ?? "")
                }
            } else {
                serverURL = nil
                serverName = nil
            }
            save()
        }
    }
    
    var serverURL: String? {
        didSet {
            save()
        }
    }
    
    var serverName: String? {
        didSet {
            save()
        }
    }
    
    var type: String {
        didSet {
            save()
        }
    }
    
    var mobileNetwork: Bool {
        didSet {
            save()
        }
    }
    
    var wifiNetwork: Bool {
        didSet {
            save()
        }
    }
    
    // MARK: - Initialize -
    
    init() {
        let model = SecureDNS.load()
        address = model?.address
        serverURL = model?.serverURL
        serverName = model?.serverName
        type = model?.type ?? "doh"
        mobileNetwork = model?.mobileNetwork ?? true
        wifiNetwork = model?.wifiNetwork ?? true
    }
    
    // MARK: - Methods -
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: SecureDNSKey)
        }
    }
    
    static func load() -> SecureDNS? {
        if let savedObj = UserDefaults.standard.object(forKey: SecureDNSKey) as? Data {
            if let loadedObj = try? JSONDecoder().decode(SecureDNS.self, from: savedObj) {
                return loadedObj
            }
        }
        
        return nil
    }
    
    func validation() -> (Bool, String?) {
        guard let address = address, !address.isEmpty else {
            return (false, "Please enter DNS server info")
        }
        
        return (true, nil)
    }
    
}

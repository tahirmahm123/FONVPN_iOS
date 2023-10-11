

import Foundation
import Reachability

public class InternetManager {
    
    public static var shared: InternetManager = InternetManager()
    var reachability: Reachability?
    public static let InternetDidConnectNotification = "InternetConnected"
    public static let InternetDidDisconnectNotification = "InternetDisconnected"
    
    private init(){
        self.reachability = try? Reachability()
        ((try? self.reachability?.startNotifier()) as ()??)

        self.reachability?.whenReachable = { reach in
            NotificationCenter.default.post(name: Notification.Name.init(InternetManager.InternetDidConnectNotification) , object: nil, userInfo: nil)
        }

        self.reachability?.whenUnreachable = { reach in
            NotificationCenter.default.post(name: Notification.Name.init(InternetManager.InternetDidDisconnectNotification) , object: nil, userInfo: nil)
        }
    }
    
    public func configue(){
        //this is the method to set configuration on InternetManager
    }

    public func isInternetConnected() -> Bool{

        if let localReachability = self.reachability{
            return self.isConnectionAvailable(reachability: localReachability)
        }else{
            self.reachability = try? Reachability()
            if let localReachability = self.reachability{
                return self.isConnectionAvailable(reachability: localReachability)
            }
        }
        return false
    }
    

    func isConnectionAvailable(reachability: Reachability) -> Bool{
        
       
        if reachability.connection == .unavailable{
            return false
        }
        return true
    }
}

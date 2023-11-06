//
//  Reachability.swift
//  Nexus-Store
//
//  Created by Khater on 05/11/2023.
//

import Foundation
import SystemConfiguration

import Network
import UIKit


final class InternetMointor {
    static let shared = InternetMointor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
//    public private(set) var isConnected = false
    
    private init () {}
    
    func start(isConnected: @escaping (Bool) -> Void) {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
//            self.isConnected = (path.status == .satisfied)
            let message = (path.status == .satisfied) ? "Connected" : "Disconnected"
            print("Internet is \(message)")
            isConnected(path.status == .satisfied)
        }
    }
}


public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}

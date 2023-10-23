
import Foundation
public class SimplePingClient: NSObject {
    public typealias PingResultCompletion = (Result<Double, Error>) -> Void

    static let singletonPC = SimplePingClient()

    private var completion: PingResultCompletion?
    private var pingClient: SimplePing?
    private var dateReference: Date?

    public static func ping(hostname: String, completion: PingResultCompletion?) {
        singletonPC.ping(hostname: hostname, completion: completion)
    }

    public func ping(hostname: String, completion: PingResultCompletion?) {
        self.completion = completion
        pingClient = SimplePing(hostName: hostname)
        pingClient?.delegate = self
        pingClient?.start()
    }
}

extension SimplePingClient: SimplePingDelegate {
    public func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        pinger.send(with: nil)
    }

    public func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        completion?(.failure(error))
    }

    public func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        dateReference = Date()
    }

    public func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        pinger.stop()
        completion?(.failure(error))
    }

    public func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        pinger.stop()
        completion?(.failure(PingError.receivedUnexpectedPacket))
    }

    public func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        pinger.stop()
        guard let dateReference = dateReference else { return }

        //timeIntervalSinceDate returns seconds, so we convert to milis
        let latency = Date().timeIntervalSince(dateReference) * 1000
        completion?(.success(latency))
    }

    enum PingError: Error {
        case receivedUnexpectedPacket
    }
}

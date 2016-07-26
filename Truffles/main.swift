//
//  main.swift
//  Truffles
//
//  Created by Matthew Wo on 7/26/16.
//  Copyright © 2016 rrdev. All rights reserved.
//

import Foundation


class ProxyServer: SXRuntimeDataDelegate {
    func didReceiveError(object object: SXRuntimeObject, err: ErrorProtocol) {
        print("Proxy Server Error: \(err)")
    }

    func didReceiveData(object object: SXRuntimeObject, data: Data) -> Bool {
        let queue = object as! SXStreamQueue
        print("Received data: \(String(data: data, encoding: .ascii))");

        queue.socket.send(data: "Your burger is ready.".data(using: .ascii)!, flags: 0)

        return true
    }
}


struct ProgramOptions {
    let lport: UInt16?
    let shouldServer: Bool
    let rport: UInt16?
    let rhost: String?
}

func parseCLI() -> ProgramOptions {
    var args = Process.arguments
    let argFlags = ["p", "r", "h"]
    let flags = ["s", "c"]

    var parsed = Dictionary<String, AnyObject>()

    for flag in argFlags {
        if let index = args.indexOf("-\(flag)") {
            parsed[flag] = args[index + 1] ?? ""
        }
    }

    for flag in flags {
        if args.indexOf("-\(flag)") != nil {
            parsed[flag] = true
        }
    }

    let lport = UInt16(parsed["p"] as! String)!
    let shouldServer = parsed["s"] != nil
    let rport =  UInt16(parsed["r"] as! String)!
    let rhost =  parsed["h"] as! String

    return ProgramOptions(lport: lport, shouldServer: shouldServer, rport: rport, rhost: rhost)
}

struct App {

    let options = parseCLI()

    func startServer() {
        let proxyServer = ProxyServer()
        let server = try! SXStreamServer(port: options.lport!, domain: .INET, maxGuest: 50, backlog: 50, dataDelegate: proxyServer)
        server.start()
        while (true) {
            // wait...
        }
    }

    func startClient() {
        
    }

    func main() {
        if options.shouldServer {
            // Start as server
            startServer()
        } else {
            // Start as client
            startClient()
        }
    }
}
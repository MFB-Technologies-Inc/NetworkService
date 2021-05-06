//
//  NetworkService+URLSessionDelegate.swift
//  NetworkService
//
//  Created by Andrew Roan on 4/20/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//

import Foundation

extension NetworkService: URLSessionDelegate {
    func getSession() -> URLSession {
        let conn: URLSession = {
            let config = URLSessionConfiguration.ephemeral
            config.timeoutIntervalForRequest = 30.0
            let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            return session
        }()
        return conn
    }

    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        #if DEBUG
        print("got challenge")
        #endif
        guard challenge.previousFailureCount == 0 else {
            #if DEBUG
            print("too many failures")
            #endif
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNegotiate else {
            #if DEBUG
            print("unknown authentication method \(challenge.protectionSpace.authenticationMethod)")
            #endif
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        var username = "", password = ""
        if let dict = Bundle.main.infoDictionary {
            username = dict["simulator_username"] as? String ?? ""
            password = dict["simulator_password"] as? String ?? ""
        }
        let credentials = URLCredential(user: username, password: password, persistence: .forSession)
        challenge.sender?.use(credentials, for: challenge)
        completionHandler(.useCredential, credentials)
    }
}

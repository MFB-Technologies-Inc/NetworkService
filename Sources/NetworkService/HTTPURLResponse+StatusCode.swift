//
//  HTTPURLResponse+NetworkService.swift
//  NetworkService
//
//  Created by Andrew Roan on 4/20/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//
//  This source code is licensed under the MIT license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation

extension HTTPURLResponse {
    public typealias StatusCode = Int

    /// Naive check if the status code is within the informational range
    public var isInformational: Bool { StatusCode.informational.contains(self.statusCode) }

    /// Naive check if the status code is within the success range
    public var isSuccessful: Bool { StatusCode.successful.contains(self.statusCode) }

    /// Naive check if the status code is within the redirect range
    public var isRedirect: Bool { StatusCode.redirect.contains(self.statusCode) }

    /// Naive check if the status code is within the client error range
    public var isClientError: Bool { StatusCode.clientError.contains(self.statusCode) }

    /// Naive check if the status code is within the server error range
    public var isServerError: Bool { StatusCode.clientError.contains(self.statusCode) }
}

extension HTTPURLResponse.StatusCode {
    // MARK: Informational
    /// Range of status codes for informational response - RFC 2616, RFC 7231
    public static let informational = 100...199
    // MARK: Unused Informational
     static let `continue` = 100
     static let switchingProtocol = 101
     static let processing = 102
     static let earlyHints = 103

    // MARK: Successful
    /// Range of status codes for successful response - RFC 2616, RFC 7231
    public static let successful = 200...299
    // swiftlint:disable:next identifier_name
    public static let ok = 200
    public static let created = 201
    // MARK: Unused Successful
    static let accepted = 202
    static let nonAutoritativeInformation = 203
    static let noContent = 204
    static let resetContent = 205
    static let partialContent = 206
    static let multiStatus = 207
    static let alreadyReported = 208
    static let imUsed = 226

    // MARK: Redirect
    /// Range of status codes for redirect response - RFC 2616, RFC 7231
    public static let redirect = 300...399
    // MARK: Unused Redirect
    static let multipleChoice = 300
    static let movedPermanently = 301
    static let found = 302
    static let seeOther = 303
    static let notModified = 304
    static let useProxy = 305
    static let unused = 306
    static let temporaryRedirect = 307
    static let permanentRedirect = 308

    // MARK: Client Error
    /// Range of status codes for client error response - RFC 2616, RFC 7231
    public static let clientError = 400...499
    public static let badRequest = 400
    public static let forbidden = 403
    // MARK: Unused Client Error
     static let unauthorized = 401
     static let paymentRequired = 402
     static let notFound = 404
     static let methodNotAllowed = 405
     static let notAcceptable = 406
     static let proxyAuthenticationRequired = 407
     static let requestTimeout = 408
     static let conflict = 409
     static let gone = 410
     static let lengthRequired = 411
     static let preconditionFailed = 412
     static let payloadTooLarge = 413
     static let uriTooLong = 414
     static let unsupportedMediaType = 415
     static let rangeNotSatisfiable = 416
     static let expectationFailed = 417
     static let imATeapot = 418
     static let misdirectedRequest = 421
     static let unprocessableEntity = 422
     static let locked = 423
     static let failedDependency = 424
     static let tooEarly = 425
     static let upgradeRequired = 426
     static let preconditionRequired = 428
     static let tooManyRequests = 429
     static let requestHeaderFieldsTooLarge = 431
     static let unavailableForLegalReasons = 451

    // MARK: Server Error
    /// Range of status codes for server error response - RFC 2616, RFC 7231
    public static let serverError = 500...599
    // MARK: Unused Server Error
     static let internalServerError = 500
     static let notImplemented = 501
     static let badGateway = 502
     static let serviceUnavailable = 503
     static let gatewayTimeout = 504
     static let httpVersionNotSupported = 505
     static let variantAlsoNegotiates = 506
     static let insufficientStorage = 507
     static let loopDetected = 508
     static let notExtended = 510
     static let networkAuthenticationRequired = 511
}

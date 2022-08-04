//
//  SaplingCiphertext.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import TezosCore

// MARK: RPCSaplingCiphertext

public struct RPCSaplingCiphertext: Hashable, Codable {
    public let cv: HexString
    public let epk: HexString
    public let payloadEnc: HexString
    public let nonceEnc: HexString
    public let payloadOut: HexString
    public let nonceOut: HexString
    
    public init(
        cv: HexString,
        epk: HexString,
        payloadEnc: HexString,
        nonceEnc: HexString,
        payloadOut: HexString,
        nonceOut: HexString
    ) {
        self.cv = cv
        self.epk = epk
        self.payloadEnc = payloadEnc
        self.nonceEnc = nonceEnc
        self.payloadOut = payloadOut
        self.nonceOut = nonceOut
    }
    
    enum CodingKeys: String, CodingKey {
        case cv
        case epk
        case payloadEnc = "payload_enc"
        case nonceEnc = "nonce_enc"
        case payloadOut = "payload_out"
        case nonceOut = "nonce_out"
    }
}

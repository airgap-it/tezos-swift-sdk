//
//  MichelineCodableTests.swift
//  
//
//  Created by Julia Samol on 13.06.22.
//

import XCTest
import TezosTestUtils

@testable import TezosCore
@testable import TezosMichelson

class MichelineCodableTests: XCTestCase {
    private var jsonEncoder: JSONEncoder!
    private var jsonDecoder: JSONDecoder!
    
    override func setUpWithError() throws {
        jsonEncoder = JSONEncoder()
        jsonDecoder = JSONDecoder()
    }

    override func tearDownWithError() throws {
        jsonEncoder = nil
        jsonDecoder = nil
    }
    
    func testEncodeMichelineToJSON() throws {
        let michelineWithJSON: [TestCase<Micheline>] = [
            try literalIntegerWithJSON().wrapped(),
            try literalStringWithJSON().wrapped(),
            try literalBytesWithJSON().wrapped(),
            try literalBytesWithJSON(bytes: "0x00").wrapped(),
            try primitiveApplicationWithJSON().wrapped(),
            try primitiveApplicationWithJSON(args: [.literal(.integer(.init(0)))]).wrapped(),
            try primitiveApplicationWithJSON(annots: ["%annot"]).wrapped(),
            try primitiveApplicationWithJSON(args: [.literal(.integer(.init(0)))], annots: ["%annot"]).wrapped(),
            try sequenceWithJSON().wrapped(),
            try sequenceWithJSON(expressions: [.literal(.integer(.init(0)))]).wrapped(),
            try sequenceWithJSON(expressions: [
                .prim(.init(
                    prim: "prim",
                    args: [.literal(.integer(.init(0)))],
                    annots: ["%annot"]
                ))
            ]).wrapped(),
            try sequenceWithJSON(expressions: [
                .literal(.integer(.init(0))),
                .prim(.init(
                    prim: "prim",
                    args: [.literal(.integer(.init(0)))],
                    annots: ["%annot"]
                ))
            ]).wrapped(),
        ]
        
        try michelineWithJSON.forEach {
            let micheline = try jsonDecoder.decode(Micheline.self, from: Data($0.json.utf8))
            
            XCTAssertEqual($0.value, micheline)
        }
    }
    
    func testEncodeMichelineLiteralToJSON() throws {
        let michelineLiteralsWithJSON: [TestCase<Micheline.Literal>] = [
            try literalIntegerWithJSON(),
            try literalStringWithJSON(),
            try literalBytesWithJSON(),
            try literalBytesWithJSON(bytes: "0x00"),
        ]
        
        try michelineLiteralsWithJSON.forEach {
            let literal = try jsonDecoder.decode(Micheline.Literal.self, from: Data($0.json.utf8))
            
            XCTAssertEqual($0.value, literal)
        }
    }
    
    func testEncodeMichelinePrimitiveApplicationToJSON() throws {
        let michelineWithJSON: [TestCase<Micheline.PrimitiveApplication>] = [
            try primitiveApplicationWithJSON(),
            try primitiveApplicationWithJSON(args: [.literal(.integer(.init(0)))]),
            try primitiveApplicationWithJSON(annots: ["%annot"]),
            try primitiveApplicationWithJSON(args: [.literal(.integer(.init(0)))], annots: ["%annot"]),
        ]
        
        try michelineWithJSON.forEach {
            let primitiveApplication = try jsonDecoder.decode(Micheline.PrimitiveApplication.self, from: Data($0.json.utf8))
            
            XCTAssertEqual($0.value, primitiveApplication)
        }
    }
    
    func testEncodeMichelineSequenceToJSON() throws {
        let michelineWithJSON: [TestCase<Micheline.Sequence>] = [
            try sequenceWithJSON(),
            try sequenceWithJSON(expressions: [.literal(.integer(.init(0)))]),
            try sequenceWithJSON(expressions: [
                .prim(.init(
                    prim: "prim",
                    args: [.literal(.integer(.init(0)))],
                    annots: ["%annot"]
                ))
            ]),
            try sequenceWithJSON(expressions: [
                .literal(.integer(.init(0))),
                .prim(.init(
                    prim: "prim",
                    args: [.literal(.integer(.init(0)))],
                    annots: ["%annot"]
                ))
            ]),
        ]
        
        try michelineWithJSON.forEach {
            let sequence = try jsonDecoder.decode(Micheline.Sequence.self, from: Data($0.json.utf8))
            
            XCTAssertEqual($0.value, sequence)
        }
    }
    
    func testDecodeMichelineFromJSON() throws {
        let michelineWithJSON: [TestCase<Micheline>] = [
            try literalIntegerWithJSON().wrapped(),
            try literalStringWithJSON().wrapped(),
            try literalBytesWithJSON().wrapped(),
            try literalBytesWithJSON(bytes: "0x00").wrapped(),
            try primitiveApplicationWithJSON().wrapped(),
            try primitiveApplicationWithJSON(args: [.literal(.integer(.init(0)))]).wrapped(),
            try primitiveApplicationWithJSON(annots: ["%annot"]).wrapped(),
            try primitiveApplicationWithJSON(args: [.literal(.integer(.init(0)))], annots: ["%annot"]).wrapped(),
            try sequenceWithJSON().wrapped(),
            try sequenceWithJSON(expressions: [.literal(.integer(.init(0)))]).wrapped(),
            try sequenceWithJSON(expressions: [
                .prim(.init(
                    prim: "prim",
                    args: [.literal(.integer(.init(0)))],
                    annots: ["%annot"]
                ))
            ]).wrapped(),
            try sequenceWithJSON(expressions: [
                .literal(.integer(.init(0))),
                .prim(.init(
                    prim: "prim",
                    args: [.literal(.integer(.init(0)))],
                    annots: ["%annot"]
                ))
            ]).wrapped(),
        ]
        
        try michelineWithJSON.forEach {
            let json = try jsonEncoder.encode($0.value)
            
            XCTAssertEqual(normalizeJSON($0.json), normalizeJSON(json))
        }
    }
    
    func testDecodeMichelineLiteralFromJSON() throws {
        let michelineWithJSON: [TestCase<Micheline.Literal>] = [
            try literalIntegerWithJSON(),
            try literalStringWithJSON(),
            try literalBytesWithJSON(),
            try literalBytesWithJSON(bytes: "0x00"),
        ]
        
        try michelineWithJSON.forEach {
            let json = try jsonEncoder.encode($0.value)
            
            XCTAssertEqual(normalizeJSON($0.json), normalizeJSON(json))
        }
    }
    
    func testDecodeMichelinePrimitiveApplicationFromJSON() throws {
        let michelineWithJSON: [TestCase<Micheline.PrimitiveApplication>] = [
            try primitiveApplicationWithJSON(),
            try primitiveApplicationWithJSON(args: [.literal(.integer(.init(0)))]),
            try primitiveApplicationWithJSON(annots: ["%annot"]),
            try primitiveApplicationWithJSON(args: [.literal(.integer(.init(0)))], annots: ["%annot"]),
        ]
        
        try michelineWithJSON.forEach {
            let json = try jsonEncoder.encode($0.value)
            
            XCTAssertEqual(normalizeJSON($0.json), normalizeJSON(json))
        }
    }
    
    func testDecodeMichelineSequenceFromJSON() throws {
        let michelineWithJSON: [TestCase<Micheline.Sequence>] = [
            try sequenceWithJSON(),
            try sequenceWithJSON(expressions: [.literal(.integer(.init(0)))]),
            try sequenceWithJSON(expressions: [
                .prim(.init(
                    prim: "prim",
                    args: [.literal(.integer(.init(0)))],
                    annots: ["%annot"]
                ))
            ]),
            try sequenceWithJSON(expressions: [
                .literal(.integer(.init(0))),
                .prim(.init(
                    prim: "prim",
                    args: [.literal(.integer(.init(0)))],
                    annots: ["%annot"]
                ))
            ]),
        ]
        
        try michelineWithJSON.forEach {
            let json = try jsonEncoder.encode($0.value)
            
            XCTAssertEqual(normalizeJSON($0.json), normalizeJSON(json))
        }
    }
    
    private func literalIntegerWithJSON(int: Int = 0) throws -> TestCase<Micheline.Literal> {
        let literal = try Micheline.Literal.Integer(String(int))
        let json = """
            {
                "int": "\(int)"
            }
        """
        
        return TestCase(value: .integer(literal), json: json)
    }
    
    private func literalStringWithJSON(string: String = "string") throws -> TestCase<Micheline.Literal> {
        let literal = try Micheline.Literal.String(string)
        let json = """
            {
                "string": "\(string)"
            }
        """
        
        return TestCase(value: .string(literal), json: json)
    }

    private func literalBytesWithJSON(bytes: String = "0x") throws -> TestCase<Micheline.Literal> {
        let literal = try Micheline.Literal.Bytes(bytes)
        let json = """
            {
                "bytes": "\(bytes.removingPrefix("0x"))"
            }
        """
        
        return TestCase(value: .bytes(literal), json: json)
    }
    
    private func primitiveApplicationWithJSON(prim: String = "prim", args: [Micheline] = [], annots: [String] = []) throws -> TestCase<Micheline.PrimitiveApplication> {
        let primitiveApplication = try Micheline.PrimitiveApplication(prim: prim, args: args, annots: annots)
        let jsonDict = [
            "prim": prim,
            "args": args.isEmpty ? nil : args.toJSONObject(),
            "annots": annots.isEmpty ? nil : annots.toJSONObject(),
        ].compactMapValues { (value: Any?) in value }
        let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
        let json = String(data: jsonData, encoding: .utf8)!
        
        return TestCase(value: primitiveApplication, json: json)
    }
    
    private func sequenceWithJSON(expressions: [Micheline] = []) throws -> TestCase<Micheline.Sequence> {
        let jsonData = try jsonEncoder.encode(expressions)
        let json = String(data: jsonData, encoding: .utf8)!
        
        return TestCase(value: expressions, json: json)
    }
}

private struct TestCase<Value> {
    let value: Value
    let json: String
}

private extension TestCase where Value == Micheline.Literal {
    func wrapped() -> TestCase<Micheline> {
        TestCase<Micheline>(value: .literal(value), json: json)
    }
}

private extension TestCase where Value == Micheline.PrimitiveApplication {
    func wrapped() -> TestCase<Micheline> {
        TestCase<Micheline>(value: .prim(value), json: json)
    }
}

private extension TestCase where Value == Micheline.Sequence {
    func wrapped() -> TestCase<Micheline> {
        TestCase<Micheline>(value: .sequence(value), json: json)
    }
}

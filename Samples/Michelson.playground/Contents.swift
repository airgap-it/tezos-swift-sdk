import TezosMichelson

// MARK: Convert to Micheline

let intConstant: Michelson = .data(.int(.init(10)))
let intLiteral: Micheline = try .init(from: intConstant)

/**
 * intLiteral = { "int": "10" }
 */
print("intLiteral = \(try intLiteral.toJSON())")

let stringConstant: Michelson = .data(.string(try .init("string")))
let stringLiteral: Micheline = try .init(from: stringConstant)

/**
 * stringLiteral = { "string": "string" }
 */
print("stringLiteral = \(try stringLiteral.toJSON())")

let bytesSequenceConstant: Michelson = .data(.bytes(try .init("0a")))
let bytesLiteral: Micheline = try .init(from: bytesSequenceConstant)

/**
 * bytesLiteral = { "bytes": "0a" }
 */
print("bytesLiteral = \(try bytesLiteral.toJSON())")

let pair: Michelson = .type(
    .pair(try .init(
        .comparable(
            .option(.init(
                type: .nat(.init(metadata: .init(typeName: try .init(value: "%nat"))))
            ))
        ),
        .or(.init(
            lhs: .comparable(.unit(.init())),
            rhs: .map(.init(
                keyType: .string(.init()),
                valueType: .comparable(
                    .pair(try .init(
                        .bytes(.init(metadata: .init(typeName: try .init(value: "%bytes")))),
                        .address(.init(metadata: .init(typeName: try .init(value: "%address"))))
                    ))
                )
            ))
        ))
    ))
)
let prim: Micheline = try .init(from: pair)

/**
 * prim = {
 *    "prim": "pair",
 *    "args": [
 *      {
 *          "prim": "option",
 *          "args": [
 *              {
 *                  "prim": "nat",
 *                  "annots": [
 *                      "%nat"
 *                  ]
 *              }
 *          ]
 *        },
 *        {
 *          "prim": "or",
 *          "args": [
 *              {
 *                  "prim": "unit"
 *              },
 *              {
 *                  "prim": "map",
 *                  "args": [
 *                      {
 *                          "prim": "string"
 *                      },
 *                      {
 *                          "prim": "pair",
 *                          "args": [
 *                              {
 *                                  "prim": "bytes",
 *                                  "annots": [
 *                                      "%bytes"
 *                                  ]
 *                              },
 *                              {
 *                                  "prim": "address",
 *                                  "annots": [
 *                                      "%address"
 *                                  ]
 *                              }
 *                          ]
 *                      }
 *                  ]
 *              }
 *          ]
 *      }
 *    ]
 * }
 */
print("prim = \(try prim.toJSON())")

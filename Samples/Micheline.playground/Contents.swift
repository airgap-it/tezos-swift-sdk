import TezosMichelson

// MARK: Create

let intLiteral: Micheline = .int(10)

/**
 * intLiteral = { "int": "10" }
 */
print("intLiteral = \(try intLiteral.toJSON())")

let stringLiteral: Micheline = try .string("string")

/**
 * stringLiteral = { "string": "string" }
 */
print("stringLiteral = \(try stringLiteral.toJSON())")

let bytesLiteral: Micheline = try .bytes("0a")

/**
 * bytesLiteral = { "bytes": "0a" }
 */
print("bytesLiteral = \(try bytesLiteral.toJSON())")

let prim: Micheline = try .type(
    prim: .pair,
    args: [
        .comparableType(
            prim: .option,
            args: [
                .comparableType(prim: .nat, annots: ["%nat"])
            ]
        ),
        .type(
            prim: .or,
            args: [
                .comparableType(prim: .unit),
                .type(
                    prim: .map,
                    args: [
                        .comparableType(prim: .string),
                        .comparableType(
                            prim: .pair,
                            args: [
                                .comparableType(prim: .bytes, annots: ["%bytes"]),
                                .comparableType(prim: .address, annots: ["%address"])
                            ]
                        )
                    ]
                )
            ]
        )
    ]
)

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

let sequence: Micheline = .sequence([
    .int(1),
    .int(2),
    .int(3)
])

/**
 * sequence = [
 *    {
 *      "int": "1"
 *    },
 *    {
 *      "int": "2"
 *    },
 *    {
 *      "int": "3"
 *    }
 * ]
 */
print("sequence = \(try sequence.toJSON())")

// MARK: Convert to `Michelson`

let micheline: Micheline = try .type(
    prim: .pair,
    args: [
        .comparableType(
            prim: .option,
            args: [
                .comparableType(prim: .nat, annots: ["%nat"])
            ]
        ),
        .type(
            prim: .or,
            args: [
                .comparableType(prim: .unit),
                .type(
                    prim: .map,
                    args: [
                        .comparableType(prim: .string),
                        .comparableType(
                            prim: .pair,
                            args: [
                                .comparableType(prim: .bytes, annots: ["%bytes"]),
                                .comparableType(prim: .address, annots: ["%address"])
                            ]
                        )
                    ]
                )
            ]
        )
    ]
)

let michelson: Michelson = .type(
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

let fromMicheline = try Michelson(from: micheline)
assert(fromMicheline == michelson)

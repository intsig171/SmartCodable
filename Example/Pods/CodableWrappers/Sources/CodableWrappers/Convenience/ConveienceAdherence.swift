//
//  ConveienceAdherence.swift
//  
//
//  Created by PJ Fechner on 7/7/20.
//

import Foundation

//MARK: ExpressibleByNilLiteral Extensions

// This make propertyWrappers adhere to OptionalCodingWrapper when wrapped value is Optional

extension TransientEncoding: OptionalEncodingWrapper where T: ExpressibleByNilLiteral { }
extension TransientDecoding: OptionalDecodingWrapper where T: ExpressibleByNilLiteral { }
extension TransientCoding: OptionalCodingWrapper where T: ExpressibleByNilLiteral { }

extension DecodingUses: OptionalDecodingWrapper where CustomDecoder.DecodedType: ExpressibleByNilLiteral { }
extension EncodingUses: OptionalEncodingWrapper where CustomEncoder.OriginalType: ExpressibleByNilLiteral { }
extension CodingUses: OptionalCodingWrapper where CustomEncoder.OriginalType: ExpressibleByNilLiteral { }

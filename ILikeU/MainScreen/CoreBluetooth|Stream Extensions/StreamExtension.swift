////
////  StreamExtension.swift
////  ILikeU
////
////  Created by George Gostev on 15/04/2020.
////  Copyright © 2020 George Gostev. All rights reserved.
////
//
//import Foundation
//import UIKit
//import CoreBluetooth
//import L2Cap
//
//extension MapViewController{
//
//    func processReceived(data: Data) -> UIImage?{
//        var image: UIImage?
//        print("processReceived with size = \(data.count)")
//        if let string = String.init(data: data, encoding: .utf8) {
//            self.imageParts.append(string)
//            print(string)
//            if imageParts.contains("FUNCINGEND") {
//                print("END")
//                let withoutFuncking = imageParts.replacingOccurrences(of: "FUNCINGEND", with: "")
//                let withOpenBracket = "[" + withoutFuncking
//                let withCommas = withOpenBracket.replacingOccurrences(of: "}{", with: "},{")
//                let closeBracket = withCommas + "]"
//                print(closeBracket)
//                if let items = try? JSONSerialization.jsonObject(with: closeBracket.data(using: .utf8)!, options: .allowFragments) as? [[String: Any]] {
//                    let sorted = items.sorted { ($0["packetNumber"] as! Int) < ($1["packetNumber"] as! Int) }
//                    let reduced = sorted.map { $0["data"] as! String }.reduce("") { $0 + $1 }
//                    let data =  Data(base64Encoded: items.first!["data"] as! String, options: .ignoreUnknownCharacters)!
//                    image = UIImage(data: data)
//                    }
//                }
//
//        }
//        return image
//    }
//
//    func startSending(image: UIImage) {
//        guard let base64ImageString = convertImageToBase64(image) else { return }
//
//        for packet in createPackets(of: base64ImageString) {
//            peripheralConnection?.send(data: packet)
//        }
//    }
//
//    func createChunk(with utf8: String.UTF8View, uuid: String, isLastPart: Bool, packetNumber: Int) -> Data? {
//
//        let json = ["id": uuid, "isLastPart": isLastPart, "packetNumber": packetNumber, "data": String(utf8) ] as [String : Any]
//        guard var data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else { return nil }
//
//        if isLastPart {
//            let fuck = "FUNCINGEND".data(using: .utf8)
//            data.append(fuck!)
//        }
//
//        return data
//    }
//
//    func createPackets(of string: String) -> [Data] {
//
//        var offset = 0
//        let stringLenght = string.utf8.count
//        let imageChunkSize = 875
//        let id = UUID().uuidString
//
//        var currentChunkNumber = 0
//
//        var chunks: [Data] = []
//
//        let utf8String = string.utf8
//        offset += utf8String.count
//        let isLastPart = true
//
//        guard let chunk = createChunk(with: utf8String, uuid: id, isLastPart: isLastPart, packetNumber: currentChunkNumber) else {
//            return []
//            print("cant create chunk")
//        }
//        currentChunkNumber += 1
//        chunks.append(chunk)
//
//        return chunks
//    }
//
//    func convertImageToBase64(_ image: UIImage) -> String? {
//           let imageData = image.jpegData(compressionQuality: 0.4)!
//           let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
//           return strBase64
//    }
//
//    func convertBase64ToImage(_ str: String) -> UIImage? {
//        guard let dataDecoded : Data = Data(base64Encoded: str, options: .ignoreUnknownCharacters) else {return nil}
//            let decodedimage = UIImage(data: dataDecoded)
//            return decodedimage
//    }
//
//}

//
//  BLOBBlockStart.swift
//  nRFMeshProvision
//
//  Created by Mostafa Berg on 08/10/2018.
//

import Foundation

public struct BLOBBlockStart {
    var opcode  : Data
    var payload : Data

    public init(withBlockNumber aBlockNumber: Data, andChunkSize aChunkSize: Data) {
        opcode = Data([0x83, 0x04])
        payload = aBlockNumber
        payload.append(aChunkSize)
    }

    public func assemblePayload(withMeshState aState: MeshState, toAddress aDestinationAddress: Data) -> [Data]? {
        if let appKey = aState.appKeys.first?.key {
            let accessMessage = AccessMessagePDU(withPayload: payload, opcode: opcode, appKey: appKey, netKey: aState.netKeys[0].key, seq: SequenceNumber(), ivIndex: aState.netKeys[0].phase, source: aState.unicastAddress, andDst: aDestinationAddress)
            let networkPDU = accessMessage.assembleNetworkPDU()
            return networkPDU
        } else {
            print("Error: AppKey Not present, returning nil")
            return nil
        }
    }
}

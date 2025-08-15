// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {MessagingFee} from
    "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol";

/**
 * @notice Message struct to send to the destination chain.
 * @param to The address of the destination chain.
 * @param amount The amount of tokens to send.
 */
struct Message {
    bytes32 to;
    uint64 amount;
}

/**
 * @notice LzMessageMetadata to provide metadata for the lz message.
 * @param dstEid The destination chain eid.
 * @param options The options for the lz message.
 * @param refundTo The address to refund the message to.
 * @param fee The MessagingFee struct from the LayerZero protocol.
 */
struct LzMessageMetadata {
    uint32 dstEid;
    bytes options;
    address refundTo;
    MessagingFee fee;
}

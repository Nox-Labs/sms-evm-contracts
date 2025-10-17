// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {SMS} from "../../src/SMS.sol";
import {MMS} from "../../src/MMS.sol";
import {SMSDataHubMainChain, SMSDataHub} from "../../src/SMSDataHub.sol";
import {SMSOmnichainAdapter} from "../../src/SMSOmnichainAdapter.sol";

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {Create3Deployer} from "./Create3Deployer.sol";

library SMSDeployer {
    using Create3Deployer for address;

    function deploy_SMSDataHub(address factory, address defaultAdmin, address minter)
        internal
        returns (address smsDataHub)
    {
        address implementation = address(new SMSDataHub());

        smsDataHub = factory.create3Deploy(
            type(ERC1967Proxy).creationCode,
            abi.encode(
                implementation, abi.encodeCall(SMSDataHub.initialize, (defaultAdmin, minter))
            ),
            "SMSDataHub"
        );
    }

    function deploy_SMSDataHubMainChain(address factory, address defaultAdmin, address minter)
        internal
        returns (address smsDataHub)
    {
        address implementation = address(new SMSDataHubMainChain());

        smsDataHub = factory.create3Deploy(
            type(ERC1967Proxy).creationCode,
            abi.encode(
                implementation, abi.encodeCall(SMSDataHub.initialize, (defaultAdmin, minter))
            ),
            "SMSDataHubMainChain"
        );
    }

    function deploy_SMS(address factory, address smsDataHub) internal returns (address sms) {
        address implementation = address(new SMS());

        sms = factory.create3Deploy(
            type(ERC1967Proxy).creationCode,
            abi.encode(implementation, abi.encodeCall(SMS.initialize, (smsDataHub))),
            "SMS"
        );
    }

    function deploy_MMS(
        address factory,
        address smsDataHub,
        uint32 periodLength,
        uint32 firstRoundStartTimestamp,
        uint32 roundBp,
        uint32 roundDuration
    ) internal returns (address mms) {
        address implementation = address(new MMS());

        mms = factory.create3Deploy(
            type(ERC1967Proxy).creationCode,
            abi.encode(
                implementation,
                abi.encodeCall(
                    MMS.initialize,
                    (smsDataHub, periodLength, firstRoundStartTimestamp, roundBp, roundDuration)
                )
            ),
            "MMS"
        );
    }

    function deploy_SMSOmnichainAdapter(address factory, address smsDataHub, address lzEndpoint)
        internal
        returns (address omnichainAdapter)
    {
        address implementation = address(new SMSOmnichainAdapter(lzEndpoint));

        omnichainAdapter = factory.create3Deploy(
            type(ERC1967Proxy).creationCode,
            abi.encode(implementation, abi.encodeCall(SMSOmnichainAdapter.initialize, (smsDataHub))),
            "SMSOmnichainAdapter"
        );
    }
}

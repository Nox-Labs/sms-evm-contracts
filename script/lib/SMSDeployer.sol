// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {SMS, ISMS} from "../../src/SMS.sol";
import {MMS, IMMS} from "../../src/MMS.sol";
import {
    SMSDataHubMainChain,
    SMSDataHub,
    ISMSDataHubMainChain,
    ISMSDataHub
} from "../../src/SMSDataHub.sol";
import {SMSOmnichainAdapter, ISMSOmnichainAdapter} from "../../src/SMSOmnichainAdapter.sol";

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {Create3Deployer} from "./Create3Deployer.sol";

import {ICREATE3Factory} from "@layerzerolabs/create3-factory/contracts/ICREATE3Factory.sol";

library SMSDeployer {
    using Create3Deployer for ICREATE3Factory;

    function deploy_SMSDataHub(ICREATE3Factory factory, address defaultAdmin, address minter)
        internal
        returns (SMSDataHub smsDataHub)
    {
        address implementation = address(new SMSDataHub());

        smsDataHub = SMSDataHub(
            factory.create3Deploy(
                type(ERC1967Proxy).creationCode,
                abi.encode(
                    implementation, abi.encodeCall(SMSDataHub.initialize, (defaultAdmin, minter))
                ),
                "SMSDataHub"
            )
        );
    }

    function deploy_SMSDataHubMainChain(
        ICREATE3Factory factory,
        address defaultAdmin,
        address minter
    ) internal returns (SMSDataHubMainChain smsDataHub) {
        address implementation = address(new SMSDataHubMainChain());

        smsDataHub = SMSDataHubMainChain(
            factory.create3Deploy(
                type(ERC1967Proxy).creationCode,
                abi.encode(
                    implementation, abi.encodeCall(SMSDataHub.initialize, (defaultAdmin, minter))
                ),
                "SMSDataHubMainChain"
            )
        );
    }

    function deploy_SMS(ICREATE3Factory factory, ISMSDataHub smsDataHub)
        internal
        returns (SMS sms)
    {
        address implementation = address(new SMS());

        sms = SMS(
            factory.create3Deploy(
                type(ERC1967Proxy).creationCode,
                abi.encode(implementation, abi.encodeCall(SMS.initialize, (smsDataHub))),
                "SMS"
            )
        );
    }

    function deploy_MMS(
        ICREATE3Factory factory,
        ISMSDataHub smsDataHub,
        uint32 periodLength,
        uint32 firstRoundStartTimestamp,
        uint32 roundBp,
        uint32 roundDuration
    ) internal returns (MMS mms) {
        address implementation = address(new MMS());

        mms = MMS(
            factory.create3Deploy(
                type(ERC1967Proxy).creationCode,
                abi.encode(
                    implementation,
                    abi.encodeCall(
                        MMS.initialize,
                        (smsDataHub, periodLength, firstRoundStartTimestamp, roundBp, roundDuration)
                    )
                ),
                "MMS"
            )
        );
    }

    function deploy_SMSOmnichainAdapter(
        ICREATE3Factory factory,
        ISMSDataHub smsDataHub,
        address lzEndpoint
    ) internal returns (SMSOmnichainAdapter omnichainAdapter) {
        address implementation = address(new SMSOmnichainAdapter(lzEndpoint));

        omnichainAdapter = SMSOmnichainAdapter(
            factory.create3Deploy(
                type(ERC1967Proxy).creationCode,
                abi.encode(
                    implementation, abi.encodeCall(SMSOmnichainAdapter.initialize, (smsDataHub))
                ),
                "SMSOmnichainAdapter"
            )
        );
    }
}

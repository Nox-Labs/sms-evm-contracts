// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {FileHelpers} from "../test/_utils/FileHelpers.sol";
import {Fork} from "../test/_utils/Fork.sol";

import {SMSDataHub} from "../src/SMSDataHub.sol";
import {PauseLevel} from "../src/interface/ISMSDataHub.sol";

contract Pause is Script, FileHelpers, Fork {
    uint256 pk;

    PauseLevel public pauseLevelToSet = PauseLevel.High;

    function setUp() public {
        pk = vm.envUint("PRIVATE_KEY");
    }

    function run(uint32 chainId) public {
        fork(chainId);

        address smsDataHub = readContractAddress(block.chainid, "SMSDataHub");

        vm.broadcast(pk);
        SMSDataHub(smsDataHub).setPauseLevel(pauseLevelToSet);
    }

    function run(uint32[] calldata chainIds) public {
        for (uint32 i = 0; i < chainIds.length; i++) {
            run(chainIds[i]);
        }
    }
}

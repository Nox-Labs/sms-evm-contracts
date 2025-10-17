// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {FileHelpers} from "../test/_utils/FileHelpers.sol";
import {Fork} from "../test/_utils/Fork.sol";

import {SMSDeployer} from "./lib/SMSDeployer.sol";

import {SMSDataHub, SMSDataHubMainChain} from "../src/SMSDataHub.sol";
import {SMS} from "../src/SMS.sol";
import {MMS} from "../src/MMS.sol";

contract Upgrade is Script, FileHelpers, Fork {
    using SMSDeployer for address;

    uint256 pk;

    function setUp() public {
        pk = vm.envUint("PRIVATE_KEY");
    }

    function run(uint32 chainId) public {
        fork(chainId);

        // _upgradeSMS();
        _upgradeMMS();
        // _upgradeSMSDataHub();
        // _upgradeSMSDataHubMainChain();
    }

    function _upgradeSMSDataHub() internal {
        address smsDataHub = readContractAddress(block.chainid, "SMSDataHub");

        try SMSDataHubMainChain(smsDataHub).getMMS() returns (address) {
            revert("This upgrade should be done with SMSDataHubMainChain");
        } catch {}

        vm.startBroadcast(pk);
        address newImplementation = address(new SMSDataHub());
        SMSDataHub(smsDataHub).upgradeToAndCall(newImplementation, "");
        vm.stopBroadcast();
    }

    function _upgradeSMSDataHubMainChain() internal {
        address smsDataHub = readContractAddress(block.chainid, "SMSDataHub");

        try SMSDataHubMainChain(smsDataHub).getMMS() returns (address) {}
        catch {
            revert("This upgrade should be done with SMSDataHub");
        }

        vm.startBroadcast(pk);
        address newImplementation = address(new SMSDataHubMainChain());
        SMSDataHubMainChain(smsDataHub).upgradeToAndCall(newImplementation, "");
        vm.stopBroadcast();
    }

    function _upgradeSMS() internal {
        address sms = readContractAddress(block.chainid, "SMS");

        vm.startBroadcast(pk);
        address newImplementation = address(new SMS());
        SMS(sms).upgradeToAndCall(newImplementation, "");
        vm.stopBroadcast();
    }

    function _upgradeMMS() internal {
        address mms = readContractAddress(block.chainid, "MMS");

        vm.startBroadcast(pk);
        address newImplementation = address(new MMS());
        MMS(mms).upgradeToAndCall(newImplementation, "");
        vm.stopBroadcast();
    }
}

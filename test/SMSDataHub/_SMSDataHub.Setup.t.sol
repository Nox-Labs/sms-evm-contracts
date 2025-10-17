// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "test/BaseSetup.sol";

contract SMSDataHubSetup is BaseSetup {
    SMSDataHubMainChain public newSMSDataHub;

    address mockAddress = makeAddr("mockAddress");

    function _afterSetUp() internal override {
        address _create3Factory = Create3Deployer._deploy_create3Factory("SMS.CREATE3Factory.2");
        newSMSDataHub = SMSDataHubMainChain(
            SMSDeployer.deploy_SMSDataHubMainChain(_create3Factory, address(this), address(this))
        );
    }
}

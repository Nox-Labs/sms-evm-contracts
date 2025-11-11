// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ISMSDataHub, PauseLevel} from "../interface/ISMSDataHub.sol";
import {ISMS} from "../interface/ISMS.sol";
import {Base} from "./Base.sol";

abstract contract SMSDataHubKeeper is Base {
    /// @custom:storage-location erc7201:sms.storage.SMSDataHubKeeper
    struct SMSDataHubKeeperStorage {
        ISMSDataHub smsDataHub;
    }

    // keccak256(abi.encode(uint256(keccak256("sms.storage.SMSDataHubKeeper")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant SMS_DATA_HUB_KEEPER_STORAGE_LOCATION =
        0x05820494ab0bfc87d0ca29635f87a151aa96e527fc389c40d93cc1f9b63d9a00;

    function __SMSDataHubKeeper_init(ISMSDataHub _smsDataHub)
        internal
        noZeroAddress(address(_smsDataHub))
        onlyInitializing
    {
        _getSMSDataHubKeeperStorage().smsDataHub = _smsDataHub;
    }

    function _getSMSDataHubKeeperStorage()
        private
        pure
        returns (SMSDataHubKeeperStorage storage $)
    {
        assembly {
            $.slot := SMS_DATA_HUB_KEEPER_STORAGE_LOCATION
        }
    }

    function getSMSDataHub() public view returns (ISMSDataHub) {
        return _getSMSDataHubKeeperStorage().smsDataHub;
    }

    function _getSMS() internal view returns (ISMS sms) {
        sms = ISMS(getSMSDataHub().getSMS());
    }

    modifier onlyAdmin() {
        if (!getSMSDataHub().hasRole(bytes32(0), msg.sender)) revert Unauthorized();
        _;
    }

    modifier onlyMinter() {
        ISMSDataHub smsDataHub = getSMSDataHub();
        if (!smsDataHub.hasRole(smsDataHub.SMS_MINTER_ROLE(), msg.sender)) revert Unauthorized();
        _;
    }

    modifier onlyCrossChainMinter() {
        ISMSDataHub smsDataHub = getSMSDataHub();
        if (!smsDataHub.hasRole(smsDataHub.SMS_CROSSCHAIN_MINTER_ROLE(), msg.sender)) {
            revert Unauthorized();
        }
        _;
    }

    modifier onlyDataHub() {
        if (msg.sender != address(getSMSDataHub())) revert Unauthorized();
        _;
    }

    modifier noPauseLevel(PauseLevel _pauseLevel) {
        if (getSMSDataHub().getPauseLevel() >= _pauseLevel) revert Paused();
        _;
    }
}

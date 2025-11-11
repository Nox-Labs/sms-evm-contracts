// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

/**
 * @notice Each pause level is a subset of the previous one.
 * @dev None: Operations paused: `None`
 * @dev Low: Operations paused: SMS.permit (excluding minter)
 * @dev Medium: Operations paused: MMS.claim, MMS.stake, MMS.redeem
 * @dev High: Operations paused: SMS.approve, SMS.transferFrom, SMS.mint (Adapter.bridgePong), SMS.burn (Adapter.bridgePing)
 * @dev Critical: Operations paused: SMS.transfer
 */
enum PauseLevel {
    None,
    Low,
    Medium,
    High,
    Critical
}

interface ISMSDataHub is IAccessControl {
    function SMS_MINTER_ROLE() external view returns (bytes32);
    function SMS_CROSSCHAIN_MINTER_ROLE() external view returns (bytes32);

    function getSMS() external view returns (address);
    function setSMS(address _sms) external;

    function getPauseLevel() external view returns (PauseLevel);
    function setPauseLevel(PauseLevel _pauseLevel) external;

    event PauseLevelChanged(PauseLevel pauseLevel);

    error AlreadySet();
}

interface ISMSDataHubMainChain is ISMSDataHub {
    function setMMS(address _mms) external;
    function getMMS() external view returns (address);
}

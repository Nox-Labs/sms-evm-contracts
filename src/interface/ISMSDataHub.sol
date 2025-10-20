// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

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

interface ISMSDataHub {
    function getAdmin() external view returns (address);
    function getMinter() external view returns (address);
    function getSMS() external view returns (address);
    function getOmnichainAdapter() external view returns (address);

    function setAdmin(address _admin) external;
    function setMinter(address _minter) external;
    function setSMS(address _sms) external;
    function setOmnichainAdapter(address _omnichainAdapter) external;

    function getPauseLevel() external view returns (PauseLevel);
    function setPauseLevel(PauseLevel _pauseLevel) external;

    event PauseLevelChanged(PauseLevel pauseLevel);

    event AdminChanged(address admin);
    event MinterChanged(address minter);

    error AlreadySet();
}

interface ISMSDataHubMainChain is ISMSDataHub {
    function setMMS(address _mms) external;
    function getMMS() external view returns (address);
}

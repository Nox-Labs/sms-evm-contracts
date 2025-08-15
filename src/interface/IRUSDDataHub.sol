// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

/**
 * @notice Each pause level is a subset of the previous one.
 * @dev None: Operations paused: `None`
 * @dev Low: Operations paused: RUSD.permit (excluding minter)
 * @dev Medium: Operations paused: YUSD.claim, YUSD.stake, YUSD.redeem
 * @dev High: Operations paused: RUSD.approve, RUSD.transferFrom, Adapter.bridgePing
 * @dev Critical: Operations paused: RUSD.transfer, RUSD.mint (Adapter.bridgePong), RUSD.burn
 */
enum PauseLevel {
    None,
    Low,
    Medium,
    High,
    Critical
}

interface IRUSDDataHub {
    function getAdmin() external view returns (address);
    function getMinter() external view returns (address);
    function getRUSD() external view returns (address);
    function getOmnichainAdapter() external view returns (address);

    function setAdmin(address _admin) external;
    function setMinter(address _minter) external;
    function setRUSD(address _rusd) external;
    function setOmnichainAdapter(address _omnichainAdapter) external;

    function getPauseLevel() external view returns (PauseLevel);
    function setPauseLevel(PauseLevel _pauseLevel) external;

    event PauseLevelChanged(PauseLevel pauseLevel);

    event AdminChanged(address admin);
    event MinterChanged(address minter);

    error AlreadySet();
}

interface IRUSDDataHubMainChain is IRUSDDataHub {
    function setYUSD(address _yusd) external;
    function getYUSD() external view returns (address);
}

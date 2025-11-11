// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Base} from "./extensions/Base.sol";
import {ISMSDataHub, ISMSDataHubMainChain, PauseLevel} from "./interface/ISMSDataHub.sol";

import {PausableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";

import {AccessControlUpgradeable} from
    "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {SMSOmnichainAdapter} from "./SMSOmnichainAdapter.sol";

/**
 * @title SMSDataHub
 * @notice The central registry and access control contract for the SMS ecosystem.
 * This contract stores and manages the addresses of all critical system components, including the SMS, MMS, omnichain adapter, administrator, and minter.
 * It simplifies contract interactions and centralizes configuration. It also provides a central point for pausing and unpausing the system.
 * All contracts communicate with this contract through the `SMSDataHubKeeper` extension.
 * Admin of this contracts its also the admin of all other contracts.
 */
contract SMSDataHub is ISMSDataHub, UUPSUpgradeable, Base, AccessControlUpgradeable {
    /* ======== STATE ======== */

    PauseLevel internal pauseLevel;

    address internal sms;
    address internal mms; // mms variable declared here to avoid slot collision on future upgrades

    bytes32 public constant SMS_MINTER_ROLE = keccak256("SMS_MINTER_ROLE");
    bytes32 public constant SMS_CROSSCHAIN_MINTER_ROLE = keccak256("SMS_CROSSCHAIN_MINTER_ROLE");

    /* ======== INITIALIZER ======== */

    /**
     * @notice Initializes the contract.
     * @param _admin The admin address.
     */
    function initialize(address _admin) external initializer noZeroAddress(_admin) {
        __UUPSUpgradeable_init();
        __AccessControl_init();
        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        pauseLevel = PauseLevel.None;
    }

    /* ======== VIEW ======== */

    /**
     * @notice Returns the SMS address.
     */
    function getSMS() public view returns (address) {
        return sms;
    }

    /**
     * @notice Returns the pause level.
     */
    function getPauseLevel() public view returns (PauseLevel) {
        return pauseLevel;
    }

    /* ======== ADMIN ======== */

    /**
     * @notice Sets the SMS address.
     * @notice Does not emit events because it's happened only once.
     * @dev Address can be set only once.
     */
    function setSMS(address _sms) public noZeroAddress(_sms) onlyDefaultAdmin onlyUnset(sms) {
        sms = _sms;
    }

    /**
     * @notice Sets the pause level.
     * @notice Emits PauseLevelChanged event.
     * @dev Pause level can be changed.
     */
    function setPauseLevel(PauseLevel _pauseLevel) public onlyDefaultAdmin {
        pauseLevel = _pauseLevel;
        emit PauseLevelChanged(_pauseLevel);
    }

    /* ======== INTERNAL ======== */

    /**
     * @notice Authorizes the upgrade of the contract.
     * @dev Inherits from UUPSUpgradeable.
     * @dev Only the admin can authorize the upgrade.
     */
    function _authorizeUpgrade(address) internal override onlyDefaultAdmin {}

    /* ======== MODIFIER ======== */

    modifier onlyDefaultAdmin() {
        if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) revert Unauthorized();
        _;
    }

    modifier onlyUnset(address _address) {
        if (_address != address(0)) revert AlreadySet();
        _;
    }
}

/**
 * @title SMSDataHubMainChain
 * @notice The main chain implementation of the SMSDataHub contract. Only one instance of this contract is deployed on the main chain.
 * @dev Inherits from SMSDataHub.
 * @dev Adding MMS address.
 */
contract SMSDataHubMainChain is ISMSDataHubMainChain, SMSDataHub {
    /**
     * @notice Returns the MMS address.
     */
    function getMMS() public view returns (address) {
        return mms;
    }

    /* ======== ADMIN ======== */

    /**
     * @notice Sets the MMS address.
     * @notice Does not emit events because it's happened only once.
     * @dev Address can be set only once.
     */
    function setMMS(address _mms) public noZeroAddress(_mms) onlyDefaultAdmin onlyUnset(mms) {
        mms = _mms;
    }
}

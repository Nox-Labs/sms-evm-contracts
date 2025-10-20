// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Base} from "./extensions/Base.sol";
import {ISMSDataHub, ISMSDataHubMainChain, PauseLevel} from "./interface/ISMSDataHub.sol";

import {PausableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";

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
contract SMSDataHub is ISMSDataHub, UUPSUpgradeable, Base {
    /* ======== STATE ======== */

    address private omnichainAdapter;
    address private admin;
    address private minter;
    address private sms;
    address internal mms; // mms variable declared here to avoid slot collision on future upgrades

    PauseLevel private pauseLevel;

    /* ======== INITIALIZER ======== */

    /**
     * @notice Initializes the contract.
     * @param _admin The admin address.
     * @param _minter The minter address.
     */
    function initialize(address _admin, address _minter)
        external
        initializer
        noZeroAddress(_admin)
        noZeroAddress(_minter)
    {
        admin = _admin;
        minter = _minter;
        pauseLevel = PauseLevel.None;
    }

    /* ======== VIEW ======== */

    /**
     * @notice Returns the admin address.
     */
    function getAdmin() public view returns (address) {
        return admin;
    }

    /**
     * @notice Returns the minter address.
     */
    function getMinter() public view returns (address) {
        return minter;
    }

    /**
     * @notice Returns the SMS address.
     */
    function getSMS() public view returns (address) {
        return sms;
    }

    /**
     * @notice Returns the omnichain adapter address.
     */
    function getOmnichainAdapter() public view returns (address) {
        return omnichainAdapter;
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
    function setSMS(address _sms) public noZeroAddress(_sms) onlyAdmin onlyUnset(sms) {
        sms = _sms;
    }

    /**
     * @notice Sets the omnichain adapter address.
     * @notice Does not emit events because it's happened only once.
     * @dev Address can be set only once.
     */
    function setOmnichainAdapter(address _omnichainAdapter)
        public
        noZeroAddress(_omnichainAdapter)
        onlyAdmin
    {
        omnichainAdapter = _omnichainAdapter;
    }

    /**
     * @notice Sets the admin address.
     * @notice Emits AdminChanged event.
     * @dev Address can be changed.
     */
    function setAdmin(address _admin) public onlyAdmin {
        admin = _admin;
        SMSOmnichainAdapter(omnichainAdapter).setDelegate2(_admin);
        emit AdminChanged(_admin);
    }

    /**
     * @notice Sets the minter address.
     * @notice Emits MinterChanged event.
     * @dev Address can be changed.
     */
    function setMinter(address _minter) public onlyAdmin {
        minter = _minter;
        emit MinterChanged(_minter);
    }

    /**
     * @notice Sets the pause level.
     * @notice Emits PauseLevelChanged event.
     * @dev Pause level can be changed.
     */
    function setPauseLevel(PauseLevel _pauseLevel) public onlyAdmin {
        pauseLevel = _pauseLevel;
        emit PauseLevelChanged(_pauseLevel);
    }

    /* ======== INTERNAL ======== */

    /**
     * @notice Authorizes the upgrade of the contract.
     * @dev Inherits from UUPSUpgradeable.
     * @dev Only the admin can authorize the upgrade.
     */
    function _authorizeUpgrade(address) internal override onlyAdmin {}

    /* ======== MODIFIER ======== */

    modifier onlyAdmin() {
        if (msg.sender != getAdmin()) revert Unauthorized();
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
    function setMMS(address _mms) public noZeroAddress(_mms) onlyAdmin onlyUnset(mms) {
        mms = _mms;
    }
}

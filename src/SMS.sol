// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ISMS, IERC20Metadata} from "./interface/ISMS.sol";
import {ISMSDataHub, PauseLevel} from "./interface/ISMSDataHub.sol";

import {Blacklistable} from "./extensions/Blacklistable.sol";
import {SMSDataHubKeeper} from "./extensions/SMSDataHubKeeper.sol";

import {
    ERC20PermitUpgradeable,
    ERC20Upgradeable
} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title SMS
 * @notice Has 6 decimals.
 */
contract SMS is ISMS, Blacklistable, SMSDataHubKeeper, UUPSUpgradeable, ERC20PermitUpgradeable {
    /* ======== STATE ======== */

    /**
     * @notice The constant to identify the cross-chain mint/burn.
     */
    bytes32 public constant CROSS_CHAIN = keccak256("CROSS_CHAIN");

    /* ======== INITIALIZER ======== */

    /**
     * @notice Initializes the contract.
     * @param _smsDataHub The address of the SMSDataHub contract.
     */
    function initialize(ISMSDataHub _smsDataHub) public initializer {
        __SMSDataHubKeeper_init(_smsDataHub);
        __ERC20_init("SMS", "SMS");
        __ERC20Permit_init(name());
        __Blacklistable_init();
        __UUPSUpgradeable_init();
    }

    /* ======== MUTATIVE ======== */

    /**
     * @notice Mints SMS to the specified address.
     * @param to The address to mint SMS to.
     * @param amount The amount of SMS to mint.
     * @param data The data to be passed to the event. Only for off-chain use.
     * @notice Emits Mint event.
     */
    function mint(address to, uint256 amount, bytes calldata data)
        public
        onlyMinter
        noZeroAmount(amount)
        noEmptyBytes(data)
        noCrossChain(data)
        noPauseLevel(PauseLevel.High)
    {
        _mint(to, amount);
        emit Mint(to, amount, data);
    }

    /**
     * @notice Burns SMS from the caller.
     * @param amount The amount of SMS to burn.
     * @param data The data to be passed to the event. Only for off-chain use.
     * @notice Emits Burn event.
     */
    function burn(uint256 amount, bytes calldata data)
        public
        onlyMinter
        noZeroAmount(amount)
        noEmptyBytes(data)
        noPauseLevel(PauseLevel.High)
        noCrossChain(data)
    {
        _burn(msg.sender, amount);
        emit Burn(msg.sender, amount, data);
    }

    /**
     * @notice Mints SMS to the specified address.
     * @param to The address to mint SMS to.
     * @param amount The amount of SMS to mint.
     * @notice Emits Mint event.
     */
    function mint(address to, uint256 amount)
        public
        onlyAdapter
        noZeroAmount(amount)
        noPauseLevel(PauseLevel.High)
    {
        _mint(to, amount);
        emit Mint(to, amount, abi.encodePacked(CROSS_CHAIN));
    }

    /**
     * @notice Burns SMS from the caller.
     * @param amount The amount of SMS to burn.
     * @notice Emits Burn event.
     */
    function burn(uint256 amount)
        public
        onlyAdapter
        noZeroAmount(amount)
        noPauseLevel(PauseLevel.High)
    {
        _burn(msg.sender, amount);
        emit Burn(msg.sender, amount, abi.encodePacked(CROSS_CHAIN));
    }

    function approve(address spender, uint256 amount)
        public
        override(ERC20Upgradeable, IERC20)
        noPauseLevel(PauseLevel.High)
        returns (bool)
    {
        return super.approve(spender, amount);
    }

    function transferFrom(address from, address to, uint256 amount)
        public
        override(ERC20Upgradeable, IERC20)
        noPauseLevel(PauseLevel.High)
        returns (bool)
    {
        return super.transferFrom(from, to, amount);
    }

    function transferFrom(address from, address to, uint256 amount, bytes calldata data)
        public
        noPauseLevel(PauseLevel.High)
        returns (bool)
    {
        super.transferFrom(from, to, amount);
        emit Transfer(from, to, amount, data);
        return true;
    }

    function transfer(address to, uint256 amount)
        public
        override(ERC20Upgradeable, IERC20)
        noPauseLevel(PauseLevel.Critical)
        returns (bool)
    {
        return super.transfer(to, amount);
    }

    function transfer(address to, uint256 amount, bytes calldata data)
        public
        noPauseLevel(PauseLevel.Critical)
        returns (bool)
    {
        super.transfer(to, amount);
        emit Transfer(msg.sender, to, amount, data);
        return true;
    }

    /* ======== VIEW ======== */

    /**
     * @notice Returns the number of decimals used to get its user representation.
     * @dev Inherited from ERC20Upgradeable.
     */
    function decimals() public pure override(ERC20Upgradeable, IERC20Metadata) returns (uint8) {
        return 6;
    }

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public override {
        ISMSDataHub smsDataHub = getSMSDataHub();

        if (smsDataHub.getPauseLevel() >= PauseLevel.Low && smsDataHub.getMinter() != msg.sender) {
            revert Paused();
        }

        super.permit(owner, spender, value, deadline, v, r, s);
    }

    /* ======== INTERNAL ======== */

    /**
     * @notice Updates the balance of the specified address.
     * @param from The address to update the balance from.
     * @param to The address to update the balance to.
     * @param amount The amount of SMS to update.
     * @dev Inherited from Blacklistable.
     */
    function _update(address from, address to, uint256 amount)
        internal
        override
        notBlacklisted(from)
        notBlacklisted(to)
    {
        super._update(from, to, amount);
    }

    /**
     * @notice Authorizes the upgrade of the contract.
     * @dev Inherited from UUPSUpgradeable.
     * @dev This function is empty because we need only admin to authorize the upgrade.
     */
    function _authorizeUpgrade(address) internal view override onlyAdmin {}

    /**
     * @notice Authorizes the blacklist of the contract.
     * @dev Inherited from Blacklistable.
     * @dev This function is empty because we need only admin to authorize the blacklist.
     */
    function _authorizeBlacklist() internal view override onlyAdmin {}

    /* ======== MODIFIERS ======== */

    /**
     * @notice Validates the data.
     * @param data The data to validate.
     * @notice Revert if data is empty or contains the CROSS_CHAIN constant.
     */
    modifier noCrossChain(bytes calldata data) {
        if (data.length == 32 && bytes32(data) == CROSS_CHAIN) revert CrossChainActionNotAllowed();
        _;
    }
}

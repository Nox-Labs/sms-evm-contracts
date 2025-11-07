// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {Base} from "./Base.sol";

abstract contract Blacklistable is Initializable {
    /// @custom:storage-location erc7201:sms.storage.blacklistable
    struct BlacklistableStorage {
        mapping(address => bool) list;
    }

    // keccak256(abi.encode(uint256(keccak256("sms.storage.blacklistable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant BLACKLISTABLE_STORAGE_LOCATION =
        0x37fdfedea7bc71b4b9d383608b0a4df30499c3d3977ac8ddd72e34648cf73000;

    function _getBlacklistableStorage() private pure returns (BlacklistableStorage storage $) {
        assembly {
            $.slot := BLACKLISTABLE_STORAGE_LOCATION
        }
    }

    function __Blacklistable_init() internal onlyInitializing {}

    /* ======== EXTERNAL ======== */

    function isBlacklisted(address account) external view returns (bool) {
        return _isBlacklisted(account);
    }

    function blacklist(address account) external onlyBlacklister {
        if (account == address(0)) revert Base.ZeroAddress();
        _blacklist(account);
    }

    function unBlacklist(address account) external onlyBlacklister {
        _unBlacklist(account);
    }

    /* ======== INTERNAL ======== */

    function _isBlacklisted(address account) internal view virtual returns (bool) {
        return _getBlacklistableStorage().list[account];
    }

    function _blacklist(address account) internal virtual {
        BlacklistableStorage storage $ = _getBlacklistableStorage();
        if ($.list[account]) revert AccountAlreadyBlacklisted(account);
        $.list[account] = true;
        emit Blacklisted(account);
    }

    function _unBlacklist(address account) internal virtual {
        BlacklistableStorage storage $ = _getBlacklistableStorage();
        if (!$.list[account]) revert AccountNotBlacklisted(account);
        $.list[account] = false;
        emit UnBlacklisted(account);
    }

    function _authorizeBlacklist() internal view virtual;

    /* ======== MODIFIERS ======== */

    modifier onlyBlacklister() {
        _authorizeBlacklist();
        _;
    }

    modifier notBlacklisted(address account) {
        if (_isBlacklisted(account)) revert BlacklistedAccount(account);
        _;
    }

    /* ======== EVENTS ======== */

    event Blacklisted(address indexed account);
    event UnBlacklisted(address indexed account);

    /* ======== ERRORS ======== */

    error BlacklistedAccount(address account);
    error AccountAlreadyBlacklisted(address account);
    error AccountNotBlacklisted(address account);
}

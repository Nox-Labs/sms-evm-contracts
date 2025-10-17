// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract Blacklistable is Initializable {
    /// @custom:storage-location erc7201:sms.storage.blacklistable
    struct BlacklistableStorage {
        mapping(address => bool) list;
    }

    // keccak256(abi.encode(uint256(keccak256("sms.storage.blacklistable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant BlacklistableStorageLocation =
        0x37fdfedea7bc71b4b9d383608b0a4df30499c3d3977ac8ddd72e34648cf73000;

    function _getBlacklistableStorage() private pure returns (BlacklistableStorage storage $) {
        assembly {
            $.slot := BlacklistableStorageLocation
        }
    }

    function __Blacklistable_init() internal onlyInitializing {}

    /* ======== EXTERNAL ======== */

    function isBlacklisted(address account) external view returns (bool) {
        return _isBlacklisted(account);
    }

    function blacklist(address account) external onlyBlacklister {
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
        _getBlacklistableStorage().list[account] = true;
        emit Blacklisted(account);
    }

    function _unBlacklist(address account) internal virtual {
        _getBlacklistableStorage().list[account] = false;
        emit UnBlacklisted(account);
    }

    function _authorizeBlacklist() internal view virtual;

    /* ======== MODIFIERS ======== */

    modifier onlyBlacklister() {
        _authorizeBlacklist();
        _;
    }

    modifier notBlacklisted(address account) {
        if (_isBlacklisted(account)) revert Blacklist(account);
        _;
    }

    /* ======== EVENTS ======== */

    event Blacklisted(address indexed account);
    event UnBlacklisted(address indexed account);

    /* ======== ERRORS ======== */

    error Blacklist(address account);
}

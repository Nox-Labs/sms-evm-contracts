// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

interface ISMS is IERC20Metadata {
    function mint(address to, uint256 amount) external;
    function mint(address to, uint256 amount, bytes calldata data) external;
    function burn(uint256 amount) external;
    function burn(uint256 amount, bytes calldata data) external;
    function transfer(address to, uint256 amount, bytes calldata data) external returns (bool);
    function transferFrom(address from, address to, uint256 amount, bytes calldata data)
        external
        returns (bool);

    event Mint(address indexed to, uint256 amount, bytes data);
    event Burn(address indexed from, uint256 amount, bytes data);
    event Transfer(address indexed from, address indexed to, uint256 amount, bytes data);

    error CrossChainActionNotAllowed();
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IAPOLLUMIA {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function _maxTxAmount() external view returns (uint256);
    function removeLimits() external;
    function openTrading() external;
    function manualSwap() external;
}

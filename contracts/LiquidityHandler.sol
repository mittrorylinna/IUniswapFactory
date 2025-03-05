// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";

contract ApollumiaLiquidityManager is Ownable {
    IERC20 public immutable token;
    IUniswapV2Router02 public immutable uniswapRouter;
    address public immutable uniswapPair;

    uint256 public liquidityTaxRate = 5; // Liquidity tax rate in percentage
    uint256 public totalLiquidityProvided;

    event LiquidityAdded(uint256 tokenAmount, uint256 ethAmount);
    event LiquidityRemoved(uint256 liquidityAmount);
    event LiquidityTaxUpdated(uint256 newRate);

    constructor(address _token, address _uniswapRouter) {
        require(_token != address(0), "Invalid token address");
        require(_uniswapRouter != address(0), "Invalid Uniswap router");

        token = IERC20(_token);
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);

        address factory = uniswapRouter.factory();
        uniswapPair = IUniswapV2Factory(factory).getPair(_token, uniswapRouter.WETH());
        require(uniswapPair != address(0), "Pair not created yet");
    }

    function addLiquidity(uint256 tokenAmount) external payable onlyOwner {
        require(tokenAmount > 0 && msg.value > 0, "Invalid amounts");
        token.transferFrom(msg.sender, address(this), tokenAmount);
        token.approve(address(uniswapRouter), tokenAmount);

        (uint256 amountToken, uint256 amountETH, uint256 liquidity) = uniswapRouter.addLiquidityETH{
            value: msg.value
        }(
            address(token),
            tokenAmount,
            0,
            0,
            address(this),
            block.timestamp
        );
        totalLiquidityProvided += liquidity;
        emit LiquidityAdded(amountToken, amountETH);
    }

    function removeLiquidity(uint256 liquidity) external onlyOwner {
        require(liquidity > 0, "Invalid liquidity amount");

        IERC20(uniswapPair).transferFrom(msg.sender, address(this), liquidity);
        IERC20(uniswapPair).approve(address(uniswapRouter), liquidity);

        (uint256 amountToken, uint256 amountETH) = uniswapRouter.removeLiquidityETH(
            address(token),
            liquidity,
            0,
            0,
            msg.sender,
            block.timestamp
        );
        totalLiquidityProvided -= liquidity;
        emit LiquidityRemoved(liquidity);
    }

    function updateLiquidityTax(uint256 newRate) external onlyOwner {
        require(newRate <= 10, "Exceeds maximum limit");
        liquidityTaxRate = newRate;
        emit LiquidityTaxUpdated(newRate);
    }
}

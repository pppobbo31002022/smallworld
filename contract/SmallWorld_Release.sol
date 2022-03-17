// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.12;

interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender,address recipient,uint256 amount) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner,address indexed spender,uint256 value);
}

abstract contract Ownable {
  address private _owner;
  address private _newOwner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor () {
    address msgSender = msg.sender;
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  function owner() public view returns (address) {
    return _owner;
  }

  function newOwner() public view returns (address) {
    return _newOwner;
  }
  
  modifier onlyOwner() {
    require(_owner == msg.sender, "Ownable: caller is not the owner");
    _;
  }
   
  function renounceOwnership() public virtual onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  function transferOwnership(address newOwnerAddress) public virtual onlyOwner {
    require(newOwnerAddress != address(0) && newOwnerAddress != _owner, "Ownable: Invalid new owner address");
    _newOwner = newOwnerAddress;
  }

  function acceptOwnership() public virtual {
    require(msg.sender == _newOwner,"Ownable: Access denied");
    emit OwnershipTransferred(_owner, _newOwner);
    _owner = _newOwner;
    _newOwner = address(0);
  }
}

library SafeMath {
  
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }
  function sub(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }
  function div(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }
}

interface IUniswapV2Factory {
  event PairCreated(address indexed token0,address indexed token1,address pair,uint256);

  function feeTo() external view returns (address);

  function feeToSetter() external view returns (address);

  function getPair(address tokenA, address tokenB) external view returns (address pair);

  function allPairs(uint256) external view returns (address pair);

  function allPairsLength() external view returns (uint256);

  function createPair(address tokenA, address tokenB) external returns (address pair);

  function setFeeTo(address) external;

  function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
  event Approval(address indexed owner,address indexed spender,uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);

  function name() external pure returns (string memory);

  function symbol() external pure returns (string memory);

  function decimals() external pure returns (uint8);

  function totalSupply() external view returns (uint256);

  function balanceOf(address owner) external view returns (uint256);

  function allowance(address owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 value) external returns (bool);

  function transfer(address to, uint256 value) external returns (bool);

  function transferFrom(address from,address to,uint256 value) external returns (bool);

  function DOMAIN_SEPARATOR() external view returns (bytes32);

  function PERMIT_TYPEHASH() external pure returns (bytes32);

  function nonces(address owner) external view returns (uint256);

  function permit(address owner,address spender,uint256 value,uint256 deadline,uint8 v,bytes32 r,bytes32 s) external;

  event Mint(address indexed sender, uint256 amount0, uint256 amount1);
  event Burn(address indexed sender,uint256 amount0,uint256 amount1,address indexed to);
  event Swap(address indexed sender,uint256 amount0In,uint256 amount1In,uint256 amount0Out,uint256 amount1Out,address indexed to);
  event Sync(uint112 reserve0, uint112 reserve1);

  function MINIMUM_LIQUIDITY() external pure returns (uint256);

  function factory() external view returns (address);

  function token0() external view returns (address);

  function token1() external view returns (address);

  function getReserves() external view returns (uint112 reserve0,uint112 reserve1,uint32 blockTimestampLast);

  function price0CumulativeLast() external view returns (uint256);

  function price1CumulativeLast() external view returns (uint256);

  function kLast() external view returns (uint256);

  function mint(address to) external returns (uint256 liquidity);

  function burn(address to) external returns (uint256 amount0, uint256 amount1);

  function swap(uint256 amount0Out,uint256 amount1Out,address to,bytes calldata data) external;

  function skim(address to) external;

  function sync() external;

  function initialize(address, address) external;
}

interface IUniswapV2Router01 {
  function factory() external pure returns (address);

  function WETH() external pure returns (address);

  function addLiquidity(
    address tokenA,
    address tokenB,
    uint256 amountADesired,
    uint256 amountBDesired,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
  )
    external
    returns (
      uint256 amountA,
      uint256 amountB,
      uint256 liquidity
    );

  function addLiquidityETH(
    address token,
    uint256 amountTokenDesired,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  )
    external
    payable
    returns (
      uint256 amountToken,
      uint256 amountETH,
      uint256 liquidity
    );

  function removeLiquidity(
    address tokenA,
    address tokenB,
    uint256 liquidity,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountA, uint256 amountB);

  function removeLiquidityETH(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountToken, uint256 amountETH);

  function removeLiquidityWithPermit(
    address tokenA,
    address tokenB,
    uint256 liquidity,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountA, uint256 amountB);

  function removeLiquidityETHWithPermit(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountToken, uint256 amountETH);

  function swapExactTokensForTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapTokensForExactTokens(
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapExactETHForTokens(
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable returns (uint256[] memory amounts);

  function swapTokensForExactETH(
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapExactTokensForETH(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapETHForExactTokens(
    uint256 amountOut,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable returns (uint256[] memory amounts);

  function quote(
    uint256 amountA,
    uint256 reserveA,
    uint256 reserveB
  ) external pure returns (uint256 amountB);

  function getAmountOut(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountOut);

  function getAmountIn(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountIn);

  function getAmountsOut(uint256 amountIn, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);

  function getAmountsIn(uint256 amountOut, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
  function removeLiquidityETHSupportingFeeOnTransferTokens(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountETH);

  function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountETH);

  function swapExactTokensForTokensSupportingFeeOnTransferTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external;

  function swapExactETHForTokensSupportingFeeOnTransferTokens(
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable;

  function swapExactTokensForETHSupportingFeeOnTransferTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external;
}

contract SmallWorld is IERC20, Ownable {
  using SafeMath for uint256;
  
  bool private isSwapping;
  modifier swaping() { isSwapping = true; _; isSwapping = false; }


  IUniswapV2Router02 public immutable uniswapV2Router;
  
  address public immutable uniswapV2Pair;

  address public constant deadAddress = 0x000000000000000000000000000000000000dEaD;

  address public daoAddress;                                          // DAO Commission
  address public foundationAddress;                                   // Foundation Group

  uint256 public burnFee = 300;                                       // each transaction burn 3%
  uint256 public poolBackFee = 300;                                   // each transaction pool back 3%
  uint256 public daoFee = 300;                                        // each transaction send 3% to ${daoAddress}
  uint256 public foundationFee = 100;                                 // each transaction send 2% to ${foundationAddress}
  
  uint256 public tHeldLimit = 30000 * 10 ** 9;                        // cumulative token held limit per account

  uint256 private _decimals = 9;
  uint256 private _tTotal = 1_000_000_000 * 10 ** 9;                  // total issue amount
  string private _name = "Small World";
  string private _symbol = "S-world";

  mapping(address => bool) private _isExcludedFromFee;

  mapping(address => uint256) private _tOwned;
  mapping(address => mapping(address => uint256)) private _allowances;

  constructor(address tokenReceiver,address dao,address foundation) {
    _tOwned[tokenReceiver] = _tTotal;
    daoAddress = dao;
    foundationAddress = foundation;

    //exclude this contract from fee
    _isExcludedFromFee[address(this)] = true;

    // pancakeswap object
    IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    // Create a uniswap pair for this new token
    uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
      .createPair(address(this), _uniswapV2Router.WETH());

    // set the rest of the contract variables
    uniswapV2Router = _uniswapV2Router;
 
    _approve(address(this), address(uniswapV2Router), ~uint256(0));

    emit Transfer(address(0), tokenReceiver, _tTotal);
  }


  // -------------------------------------------- Public Call -----------------------------------------------------

  function name() public view returns (string memory) {
    return _name;
  }
  function symbol() public view returns (string memory) {
    return _symbol;
  }
  function decimals() public view returns (uint256) {
    return _decimals;
  }
  function totalSupply() public view override returns (uint256) {
    return _tTotal;
  }
  function balanceOf(address account) public view override returns (uint256) {
    return _tOwned[account];
  }
  function transfer(address recipient, uint256 amount) public override returns (bool) {
    _transfer(msg.sender, recipient, amount);
    return true;
  }
  function transferFrom(address sender,address recipient,uint256 amount) public override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(
      sender,
      msg.sender,
      _allowances[sender][msg.sender].sub(
        amount,
        "ERC20: transfer amount exceeds allowance"
      )
    );
    return true;
  }  
  function allowance(address owner, address spender) public view override returns (uint256) {
    return _allowances[owner][spender];
  }
  function approve(address spender, uint256 amount) public override returns (bool) {
    _approve(msg.sender, spender, amount);
    return true;
  }
  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
    _approve(
      msg.sender,
      spender,
      _allowances[msg.sender][spender].add(addedValue)
    );
    return true;
  }
  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
    _approve(
      msg.sender,
      spender,
      _allowances[msg.sender][spender].sub(
        subtractedValue,
        "ERC20: decreased allowance below zero"
      )
    );
    return true;
  }


  function isExcludedFromFee(address account) public view returns (bool) {
    return _isExcludedFromFee[account];
  }
  function excludeFromFee(address account) public onlyOwner {
    _isExcludedFromFee[account] = true;
  }
  function includeInFee(address account) public onlyOwner {
    _isExcludedFromFee[account] = false;
  }

  //to recieve ETH from uniswapV2Router when swaping
  receive() external payable {}

  // --------------------------------------------- Private Call ----------------------------------------------------

  function _approve(address owner,address spender,uint256 amount) private {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }
  function _transfer(address from,address to,uint256 amount) private {
    require(from != address(0), "ERC20: transfer from the zero address");
    require(to != address(0), "ERC20: transfer to the zero address");

    if(isSwapping) {
       _basicTransfer(from, to, amount);
       return;
    }
  
    // 1.hold limit
    if(to != uniswapV2Pair && !_isExcludedFromFee[to] && to != deadAddress && balanceOf(to).add(amount) > tHeldLimit) {
      revert("cumulative token held limit");
    }

    // 2.should pay fee ?
    bool shouldPayFee = !(_isExcludedFromFee[from] || _isExcludedFromFee[to]);
    if (from != uniswapV2Pair && to != uniswapV2Pair) {
      if(shouldPayFee) shouldPayFee = false;
    }
    
    // 3.pay the fee required and then transfer amount
    _payFeeThenTransfer(from, to, amount, shouldPayFee);
  }
  function _payFeeThenTransfer(address sender,address recipient,uint256 tAmount,bool shouldPayFee) private {
    uint256 recipientRate = 10000;

    // 1.pay fee
    if(shouldPayFee) {
      if(burnFee > 0) {
        _payBurnFee(sender, tAmount.mul(burnFee).div(10000));
        recipientRate = recipientRate.sub(burnFee);
      }
      if(daoFee > 0) {
        _paySupportFee(sender,daoAddress, tAmount.mul(daoFee).div(10000));
        recipientRate = recipientRate.sub(daoFee);
      }
      if(foundationFee > 0) {
        _paySupportFee(sender,foundationAddress, tAmount.mul(foundationFee).div(10000));
        recipientRate = recipientRate.sub(foundationFee);
      }
      if(poolBackFee > 0) {
        _payPoolBackFee(sender,tAmount.mul(poolBackFee).div(10000));
        recipientRate = recipientRate.sub(poolBackFee);
      }
    }
    // 2. transfer amount
    uint256 willReceive = tAmount.mul(recipientRate).div(10000);
    _basicTransfer(sender, recipient, willReceive);
  }

  function _paySupportFee(address sender,address team,uint256 amount) private {
    _basicTransfer(sender, team, amount);
  }
  function _payBurnFee(address sender,uint256 amount) private returns (bool) {
    return _burn(sender,amount);
  }
  function _payPoolBackFee(address sender,uint256 amount) private {
    _basicTransfer(sender,address(this),amount);
    if(sender != uniswapV2Pair) {
      _swapAndLiquify();
    }
  }

  function _burn(address sender,uint256 amount) private returns (bool) {
    if(_tTotal.sub(_tOwned[deadAddress]) <= _tTotal.div(10)) { return false; }
    return _basicTransfer(sender,deadAddress,amount);
  }

  event SwapAndLiquified(uint256 tokensSwapped,uint256 ethReceived,uint256 tokensIntoLiqudity);

  function _swapAndLiquify() private swaping {
    uint256 contractTokenBalance = balanceOf(address(this));
    uint256 half = contractTokenBalance.div(2);
    uint256 otherHalf = contractTokenBalance.sub(half);
    uint256 initialBalance = address(this).balance;
    _swapTokensForEth(half); 
    uint256 newBalance = address(this).balance.sub(initialBalance);
    _addLiquidity(otherHalf, newBalance);
    emit SwapAndLiquified(half, newBalance, otherHalf);
  }
  function _swapTokensForEth(uint256 tokenAmount) private {
    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = uniswapV2Router.WETH();
    uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
      tokenAmount,
      0, 
      path,
      address(this),
      block.timestamp
    );
  }
  function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
    uniswapV2Router.addLiquidityETH{value: ethAmount}(
      address(this),
      tokenAmount,
      0, 
      0, 
      owner(),
      block.timestamp
    );
  }

  function _basicTransfer(address sender, address recipient, uint256 amount) private returns (bool) {
    _tOwned[sender] = _tOwned[sender].sub(amount, "Insufficient Balance");
    _tOwned[recipient] = _tOwned[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
    return true;
  }
}

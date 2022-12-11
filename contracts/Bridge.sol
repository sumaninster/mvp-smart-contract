pragma solidity ^0.4.23;

interface ERC20Token {
    function transfer(address, uint256) external returns (bool);
    function approve(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
    function totalSupply() external view returns (uint256);
    function balanceOf(address) external view returns (uint256);
    function allowance(address, address) external view returns (uint256);
}

contract BridgeContract {
    
    struct ERC20Tokens {
        address tokenAddress;
        string tokenName;
        string tokenSymbol;
        bool exists;
    }
    
    struct UserWallet {
        uint256 amount;
        string jurAddress; //Substrate (JurChain) Address
    }
    
    mapping(address => mapping(string => UserWallet)) public userWallet;
    mapping(string => ERC20Tokens) public eRC20Tokens;
    
    string[] public tokenSymbols;

    function addToken(address _tokenAddress, string memory _tokenName, string memory _tokenSymbol) public {
        if (!eRC20Tokens[_tokenSymbol].exists) {
            eRC20Tokens[_tokenSymbol].exists = true;
            eRC20Tokens[_tokenSymbol].tokenAddress = _tokenAddress;
            eRC20Tokens[_tokenSymbol].tokenName = _tokenName;
            eRC20Tokens[_tokenSymbol].tokenSymbol = _tokenSymbol;
            tokenSymbols.push(_tokenSymbol);
        }
    }
    
    //NOTE: The smart contract should be approved by the Token contract before the deposit function is called
    function deposit(string memory _tokenSymbol, uint256 _amount, string memory _jurAddress) public {
        address tokenAddress = eRC20Tokens[_tokenSymbol].tokenAddress;
        ERC20Token token = ERC20Token(tokenAddress);
        address from = msg.sender;
        address to = address(this);
        token.transferFrom(from, to, _amount);
        userWallet[msg.sender][_tokenSymbol].amount += _amount;
        userWallet[msg.sender][_tokenSymbol].jurAddress = _jurAddress;
    }
}
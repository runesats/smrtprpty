contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
contract owned{
  address public owner;
  function owned(){
    owner = msg.sender;
  }
  modifier onlyOwner{
    if(msg.sender != owner) throw;
    _
  }
  function transferOwnership(address newOwner) onlyOwner{
    owner = newOwner;
  }
}
contract MyToken is owned{
    /* Public variables of the token */
    string public standard = 'Token 0.1';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    /* Simple array of tokenholders */
    address[] tokenHolders;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    /* Indexes for people's addresses*/
    mapping (uint => address) public indexes;
    uint public currentIndex;
    mapping (address => mapping (address => uint256)) public allowance;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function MyToken(
        uint256 initialSupply,
        string tokenName,
        uint8 decimalUnits,
        string tokenSymbol,
        ) {
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        totalSupply = initialSupply;                        // Update total supply
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
        decimals = decimalUnits;                            // Amount of decimals for display purposes
        msg.sender.send(msg.value);                         // Send back any ether sent accidentally
        currentIndex = 0;
        indexes[currentIndex] = msg.sender;                 // Hashes an index to an address.
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        currentIndex++;                                      // increments the currentIndex by 1
        indexes[currentIndex] = _to;                         // keeps a hash to the address by index.
        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
    }

    //Don't need this anymore if I use a hash with indexes as keys and values as addresses
    /* Fix tokenholder array */
    /*function checkTokenHolders() returns(bool success){
      address[] newTokenHolders
      for(var i = 0; i < tokenHolders.length; i++){
        if(balanceOf[tokenHolders[i]] > 0){
          newTokenHolders.push(tokenHolders[i])
        }
      }
      delete tokenHolders;
      for(var i = 0; i < newTokenHolders.length; i++){
        tokenHolders.push(newTokenHolders[i]);
      }
      delete newTokenHolders;
      return true;
    }*/


    /* Allow another contract to spend some tokens in your behalf */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        tokenRecipient spender = tokenRecipient(_spender);
        spender.receiveApproval(msg.sender, _value, this, _extraData);
        return true;
    }

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
        if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
        balanceOf[_from] -= _value;                          // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        allowance[_from][msg.sender] -= _value;
        //tokenHolders.push(_to);                             // Adds the address coin is being sent to in to the array
        //checkTokenHolders()                                 // Makes sure there aren't empty addresses in the array
        currentIndex ++;
        indexes[currentIndex] = _to;
        Transfer(_from, _to, _value);
        return true;
    }

    /* Transfer funds based on number of coins. This will later be moved in to the unnamed function */
    function transferFunds() returns(bool success){
        
    }


    /* This unnamed function is called whenever someone tries to send ether to it */
    function () {

    }
}

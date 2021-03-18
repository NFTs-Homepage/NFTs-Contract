let Pixel = artifacts.require("Pixel");
let pixelInstance;

contract("Pixel", function (accounts){
  //accounts[0] is the default account
  it("Contract deployment", function(){
    //Fetching the contract instance of our smart contract
    return Pixel.deployed().then(function (instance){
      //We save the instance in a gDlobal variable and all smart contract functions are called using this
      pixelInstance = instance;
      assert(pixelInstance !== undefined, 'Auction contract should be defined');
    })
  });

  //Mint PIXEL token with _tokenId = 1 and row = col = 3
  it("Should mint token", function() {
    let row = 3;
    let col = 3;
    return pixelInstance.mint(row, col, {from:accounts[1], value: web3.utils.toWei('100000000000000000', 'wei')}).then(function(result) {
        return pixelInstance._tokenIds();
    }).then(function(result) {
      let token_id = result
      assert(token_id != 0, 'token_id must not equal to 0');
    })
  });
  
})

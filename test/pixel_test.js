let Pixel = artifacts.require("Pixel");
let pixelInstance;

contract("Pixel", function (accounts){
  //accounts[0] is the default account
  it("Contract deployment", function(){
    //Fetching the contract instance of our smart contract
    return Pixel.deployed().then(function (instance){
      //We save the instance in a global variable and all smart contract functions are called using this
      pixelInstance = instance;
      assert(pixelInstance !== undefined, 'Pixel contract should be defined');
    })
  });

  //Mint PIXEL token with _tokenId = 1 
  it("Should mint token", function() {

    let row = 3;
    let col = 9;

    //mint pixel by accounts 1 at (3, 9)
    return pixelInstance.mint(
      row, 
      col, {
        from:accounts[1], 
        value: web3.utils.toWei('100000000000000000', 'wei')}
        ).then(function() {

          return pixelInstance._tokenIds(); //get recently tokenIds

    }).then(function(token_id) {

      //check that number of pixel in contract not equal 0
      assert(token_id != 0, 'token_id must not equal to 0');

      return pixelInstance.tokenIdToPixelIndex.call(token_id); //get pixelIndex

    }).then(function(pixelIndex){

      //check if pixelIndex match with row
      assert(Math.floor(pixelIndex/100) == row, "pixelIndex isn't match with row");
      //check if pixelIndex match with col
      assert(pixelIndex%100 == col, "pixelIndex isn't match with col");

      return pixelInstance.getPixelOwner(pixelIndex);

    }).then(function(pixelOwner){

      assert(accounts[1] == pixelOwner, "Wrong owner address");
      
    })
  });
})

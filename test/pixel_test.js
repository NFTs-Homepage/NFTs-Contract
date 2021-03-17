const Pixel = artifacts.require("Pixel");

contract("Pixel", async accounts => {
  it("should set admin and dev address", async () => {
    let instance = await Pixel.deployed();
    let masterAdminAddress = await instance.masterAdminAddress.call();
    assert.equal(masterAdminAddress, accounts[0]);
  });
})
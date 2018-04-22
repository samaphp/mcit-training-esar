var USD = artifacts.require("./USD.sol");
var LandRegistry = artifacts.require("./LandRegistry.sol");
var AtomicSwap_USD = artifacts.require("./AtomicSwap_USD.sol");
var AtomicSwap_LandRegistry = artifacts.require("./AtomicSwap_LandRegistry.sol");

contract("USD", function(accounts){
	it("Account 0 should issue 50,000 USD to account 1", async function() {
		let USD_Instance = await USD.deployed();
		await USD_Instance.issueUSD(accounts[1], 50000);
		let balance = await USD_Instance.getUSDBalance.call(accounts[1])

		assert.equal(50000, balance.toNumber());

		let AtomicSwap_USD_Instance = await AtomicSwap_USD.deployed();
		await USD_Instance.approve(AtomicSwap_USD_Instance.address, 50000, {from: accounts[1]})
  });

	it("Account 0 should issue land to account 2", async function() {
		let LandRegistry_Instance = await LandRegistry.deployed();
		await LandRegistry_Instance.issueLand(accounts[2], "land123");
		let owner = await LandRegistry_Instance.getOwner.call("land123")

		assert.equal(accounts[2], owner);

		let AtomicSwap_LandRegistry_Instance = await AtomicSwap_LandRegistry.deployed();
		await LandRegistry_Instance.approve(AtomicSwap_LandRegistry_Instance.address, "land123", {from: accounts[2]})
  });

	it("assets exchange using hash locking", async function(){
		let AtomicSwap_USD_Instance = await AtomicSwap_USD.deployed();
		let USD_Instance = await USD.deployed();
		let hash = await AtomicSwap_USD_Instance.calculateHash.call("12345");
		await AtomicSwap_USD_Instance.lock(accounts[2], hash, 30, 50000, {from: accounts[1]})
		let balance = await USD_Instance.getUSDBalance.call(AtomicSwap_USD_Instance.address)

		assert.equal(50000, balance.toNumber())

		let LandRegistry_Instance = await LandRegistry.deployed();
		let AtomicSwap_LandRegistry_Instance = await AtomicSwap_LandRegistry.deployed();

		await AtomicSwap_LandRegistry_Instance.lock(accounts[1], hash, 15, "land123", {from: accounts[2]})
		let owner = await LandRegistry_Instance.getOwner.call("land123")

		assert.equal(owner, AtomicSwap_LandRegistry.address);


		await AtomicSwap_LandRegistry_Instance.claim("12345");
		await AtomicSwap_USD_Instance.claim("12345");
		balance = await USD_Instance.getUSDBalance.call(accounts[2])
		owner = await LandRegistry_Instance.getOwner.call("land123")

		assert.equal(balance.toNumber(), 50000)
		assert.equal(owner, accounts[1])
	})

})

const mintRun = async () => {
    const CONTRACT_ADDRESS = "0x9A4Ea4Ec7f13d255bC9B855dcBb97595F1E49253";
  
    const metadata = "https://jsonkeeper.com/b/1KV4";
  
    const DropContractFactory = await hre.ethers.getContractFactory('mintNfts');
    const dropContract = DropContractFactory.attach(CONTRACT_ADDRESS);
  
    console.log("Contract address:", dropContract.address);
  
    // for (let i = 0; i < address.length; i++) {
      try {
        let txn = await dropContract.safeMint(metadata);
        console.log("Mining, please wait...");
        await txn.wait();
      } catch (e) {
        console.log(e);
      }
    // }
  };
  
  const runMintRun = async () => {
    try {
      await mintRun();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMintRun();
<script>

  import { ethers } from 'ethers';
  
  export let web3Props = {
    provider: null,
    signer: null,
    account: null,
    chainId: null,
    contract: null,
  };
  export let contractAddr;
  export let contractAbi;

  async function connectWallet() {
    let provider = new ethers.providers.Web3Provider(window.ethereum, 'any');
    await provider.send("eth_requestAccounts", []);
    const signer = provider.getSigner();
    const account = signer.getAddress();
    const chainId =  signer._checkProvider();
    const contract = new ethers.Contract(contractAddr, contractAbi.abi, signer);
    web3Props = { provider, signer, account, chainId, contract };
  }
</script>


  <button class="btn btn-primary" on:click={connectWallet}>Attach Wallet</button
  >


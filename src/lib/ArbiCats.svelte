<script>
  import Bar from "./Bar.svelte";

  export let web3Props = {
    provider: null,
    signer: null,
    account: null,
    chainId: null,
    contract: null,
  };
  $: image = "";
  $: hunger = 0;
  $: health = 0;
  $: happiness = 0;

  const getMyGotchi = async () => {
    let currentGotchi = await web3Props.contract.myGotchi();
    image = await currentGotchi[4];
    happiness = await currentGotchi[0].toNumber();
    hunger = await currentGotchi[1].toNumber();
    health = await currentGotchi[2].toNumber();
    web3Props.contract.on("CatUpdated", async () => {
      currentGotchi = await web3Props.contract.myGotchi();
      image = await currentGotchi[4];
      happiness = await currentGotchi[0].toNumber();
      hunger = await currentGotchi[1].toNumber();
      health = await currentGotchi[2].toNumber();
    });
  };
  getMyGotchi();
</script>



<div
  class="card bg-gray-800 backdrop-blur ring-1 ring-inset ring-gray-500 mx-auto rounded-lg flex cursor-context-menu"
>
  <figure class="px-10 pt-10">
    <img
      src="https://ipfs.io/ipfs/{image}"
      alt="Your Cat"
      class="object-cover"
    />
  </figure>
  <div class="mx-10">
    <div>
      Hunger: {hunger}
      <br />
      <Bar bind:status={hunger} />
    </div>
    <div>
      Health: {health}
      <br />

      <Bar bind:status={health} />
    </div>
    <div>
      Happiness: {happiness}
      <br />
      <Bar bind:status={happiness} />
    </div>
    <div class="card-actions flex justify-center gap-x-2 py-5">
      <button
        class="btn btn-primary tooltip"
        data-tip="Pass-Time"
        on:click={() => {
          web3Props.contract.passTime(0);
        }}>⏱</button
      >
      <button
        class="btn btn-primary tooltip"
        data-tip="Play"
        on:click={() => {
          web3Props.contract.play();
        }}>🛼</button
      >
      <button
        class="btn btn-primary tooltip"
        data-tip="Feed"
        on:click={() => {
          web3Props.contract.feed();
        }}>🍔</button
      >
      <button
        class="btn btn-primary tooltip"
        data-tip="Mint"
        on:click={() => {
          web3Props.contract.safeMint(web3Props.account);
        }}>🎟</button
      >
    </div>
  </div>

  </div>



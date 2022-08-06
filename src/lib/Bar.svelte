<script>
  export let status;
</script>

<div class="status animate-shimmer bg-gradient-to-r from-blue-900 via-cyan-800 to-cyan-900" style={`width: ${status}%;`}  />

<style>
  .status {
    height: 8px;
    /* background: rgb(20, 188, 255); */
    /* opacity: 0.5; */
    /* width: 33%; */
  }
</style>

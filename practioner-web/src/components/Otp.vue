<template>
  <div class="card">
    <div class="card-body text-center">
      <img class="logo mb-0 pb-0" src="@/assets/logo.png" alt="MedicNest Logo">
      <p class="card-text text-dark">Enter the code sent to your phone number ending in {{maskedPhoneNumber}}</p>
      <div class="mb-3 text-dark">
        <input placeholder="Enter verification code"  type="text" class="form-control" id="verificationCode" v-model="verificationCode" maxlength="6" autocomplete="off">
      </div>
      <button type="button" class="btn btn-primary w-100" @click="verifyCode">Verify</button>
    </div>
  </div>
</template>

<script>

export default {
  name: 'Otp',
  data() {
    return {
      verificationCode: '',
    };
  },
  mounted() {
    console.log('This is the passed number : '+ this.$route.query.number);
  },
  computed: {
     maskedPhoneNumber() {
       const last4Digits = this.$route.query.number.slice(-4);
       return `*****${last4Digits}`;
     },
  },
  methods: {
    verifyCode() {
      console.log('Verification code:', this.verificationCode);
      this.$router.push({
        name: 'Signup',
        query: this.$route.query
      });
    },
  },
};
</script>

<style scoped>
.card {
  /* Add custom styles for the card as needed */
}
</style>

<template>
    <div class="card shadow-sm" style="width: 30rem;">
      <div class="card-body">
        <div class="text-center mb-4">
          <img class="logo mb-0 pb-0" src="@/assets/logo.png" alt="MedicNest Logo">
          <h4 class="card-title text-dark">Register</h4>
        </div>
        <p class="text-dark">
          To register a new account, please provide your registered HPCSA number and we will send a verification code to your registered cell number.
        </p>
        <form @submit.prevent="handleVerify">
          <div class="mb-3">
            <input type="text" class="form-control form-control" id="hpcsaNumber" name="hpcsaNumber" v-model="hpcsaNumber" placeholder="Enter HPCSA number">
          </div>
          <button type="submit" class="btn btn-primary btn w-100 " :disabled="isLoading">
            <span v-if="!isLoading">Send Verification Code</span>
            <span v-else>
              <span class="spinner-border spinner-border-sm mr-2" role="status" aria-hidden="true"></span>
              Verifying...
            </span>
          </button>
        </form>
        <div v-if="errorMessage" class="alert alert-danger mt-3" role="alert">
          {{ errorMessage }}
        </div>
        <div class="text-center mt-4 text-dark ">
          Already have an account? <a href="#">Login</a>
        </div>
      </div>
    </div>

</template>

<script>
import { getFirestore, collection, where, query, getDocs } from 'firebase/firestore';
import axios from 'axios';
import router from "@/routes/index.js";
export default {
  name: 'Register',
  data() {
    return {
      phoneNumber: '',
      hpcsaNumber: '',
      isLoading: false,
      errorMessage: null,
    };
  },
  methods: {
    async handleVerify() {
      this.isLoading = true;
      this.errorMessage = null;

      const db = getFirestore();
      const q = query(collection(db, 'hpcsa'), where('registration', '==', this.hpcsaNumber));
      try {
        const querySnapshot = await getDocs(q);
        if (querySnapshot.empty) {
          this.errorMessage = 'The provided number is invalid or doesn\'t exist. Please re-enter.';
        } else {
          let response = querySnapshot.docs[0].data()
          // const response = await axios.post('http://localhost:3000/send-otp', {
          //   'phoneNumber' :number,
          // });

          await router.push({name: 'Otp', query: response});
        }
      } catch (error) {
        console.error('Error verifying HPCSA number:', error);
        this.errorMessage = 'An error occurred during verification. Please try again.';
      } finally {
        this.isLoading = false;
      }
    },
  },
};
</script>

<style scoped>
</style>

<template>
  <div class="mt-5">
    <div class="row justify-content-center">
      <div class="col-md-9">
        <div class="card">
          <div class="card-body text-center text-dark">
            <img class="logo mb-0 pb-0" src="@/assets/logo.png" alt="MedicNest Logo">
            <p>To continue, please sign up with your email address and a secure password.</p>
            <form @submit.prevent="createAccount" class="form-group">
              <div class="mb-3">
                <input placeholder="Email Address" type="email" id="email" v-model="email" class="form-control" required>
              </div>
              <div class="mb-3">
                <input placeholder="Password"  type="password" id="password" v-model="password" class="form-control" required>
              </div>
              <div class="form-check mb-3">
                <input type="checkbox" class="form-check-input" id="disclaimer" v-model="disclaimerAccepted" required>
                <label class="form-check-label" for="disclaimer">
                  I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>.
                </label>
              </div>
              <button type="submit" :disabled="isCreatingAccount || !email || !password.length >= 8 || !disclaimerAccepted" class="btn btn-primary w-100">
                <span v-if="!isCreatingAccount">Create Account</span>
                <span v-else>
                  <span class="spinner-border spinner-border-sm mr-2" role="status" aria-hidden="true"></span>
                  Creating Account...
                </span>
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {auth, db} from '../firebase.js';
import {createUserWithEmailAndPassword} from 'firebase/auth';
import { toast } from 'vue3-toastify';
import 'vue3-toastify/dist/index.css';
import {doc, setDoc} from "firebase/firestore";

export default {
  name: 'Signup',
  data() {
    return {
      verificationSuccessful: false,
      isCreatingAccount: false,
      email: '',
      password: '',
      disclaimerAccepted: false,
    };
  },
  methods: {
    async createAccount() {
      this.isCreatingAccount = true;

      try {
        const createUser = await createUserWithEmailAndPassword(auth, this.email, this.password);
        const userId = createUser.user.uid;
        const doctorData = {
          ...this.$route.query
        };
        await setDoc(doc(db, 'doctors', userId), doctorData);
        toast.success("Account created successfully!", {
          position: toast.POSITION.BOTTOM_CENTER,
          onClose: ()=>{
            this.$router.push('/login'); // Replace with your desired redirection
          },
          autoClose: 3000,
        });

      } catch (error) {
        console.error('Error creating account:', error.code, error.message);
        // Handle specific Firebase errors (e.g., display error messages to the user)
        switch (error.code) {
          case 'auth/email-already-in-use':
            toast.error("Email address already registered", {
              position: toast.POSITION.BOTTOM_CENTER,
              autoClose: 3000,
            });
            break;
          case 'auth/weak-password':
            toast.error("Password is weak. ", {
              position: toast.POSITION.BOTTOM_CENTER,
              autoClose: 3000,
            });
            break;

          default:
            toast.error("Unkown error occured. Please try again", {
              position: toast.POSITION.BOTTOM_CENTER,
              autoClose: 3000,
            });
        }
      }
    },
  },
};
</script>

<style scoped>
.form-group {
  margin-bottom: 15px;
}
</style>

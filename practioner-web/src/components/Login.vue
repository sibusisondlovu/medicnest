<template>
  <div class="">
    <div class="card shadow-sm" style="width: 30rem;">
      <div class="card-body">
        <div class="text-center mb-4">
          <img class="logo mb-0 pb-0" src="@/assets/logo.png" alt="MedicNest Logo">
          <h4 class="card-title text-dark">Login</h4>
        </div>
        <form @submit.prevent="handleSubmit">
          <div class="mb-3 input-group">
            <span class="input-group-text">
              <i class="fas fa-user"></i>
            </span>
            <input type="text" class="form-control form-control" id="username" name="username" v-model="username" placeholder="Enter username">
          </div>
          <div class="mb-3 input-group">
            <span class="input-group-text">
              <i class="fas fa-lock"></i>
            </span>
            <input type="password" class="form-control form-control" id="password" name="password" v-model="password" placeholder="Enter password">
          </div>
          <button type="submit" :disabled="isLoading" class="btn btn-primary btn w-100">
            <span v-if="!isLoading">Login</span>
            <span v-else>
              <span class="spinner-border spinner-border-sm mr-2" role="status" aria-hidden="true"></span>
              Authenticating...
            </span>
          </button>
          <div v-if="errorMessage" class="alert alert-danger mt-3" role="alert">
            {{ errorMessage }}
          </div>
        </form>
        <div class="d-flex justify-content-between mt-4">
          <a href="#">Don't have an account? Sign Up</a>
          <a href="#">Forgot Password?</a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getAuth, signInWithEmailAndPassword } from 'firebase/auth';
import { toast } from 'vue3-toastify';
import 'vue3-toastify/dist/index.css';

export default {
  name: 'Login',
  data() {
    return {
      username: '',
      password: '',
      isLoading: false,
      errorMessage: null,
      //logo: require('@/assets/your_logo.png'), // Assuming logo is in assets folder
    };
  },
  methods: {
    async handleSubmit() {
      this.isLoading = true;
      try {
        const auth = getAuth();
        const userCredential = await signInWithEmailAndPassword(auth, this.username, this.password);
        toast.success("Login successfully!", {
          position: toast.POSITION.BOTTOM_CENTER,
          onClose: ()=>{
            this.$router.push('/dashboard'); // Replace with your desired redirection
          },
          autoClose: 3000,
        });

      } catch (error) {
        console.error('Login error:', error);
        this.errorMessage = error.message;
      } finally {
        this.isLoading = false;
      }
    },
    togglePasswordVisibility() {
      this.isPasswordVisible = !this.isPasswordVisible;
    },
  },
};
</script>

<style scoped>
.text-center img {
  margin-bottom: 1rem;
}
.password-toggle {
  cursor: pointer;
}
</style>

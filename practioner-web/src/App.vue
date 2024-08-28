<template>
  <div>
    <nav v-if="!isLoginPage && !isRegisterPage && !isOtpPage && !isSignUpPage" class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
      <div class="container-fluid">
        <img class="logo mb-0 pb-0" src="@/assets/logo.png" alt="MedicNest Logo">
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-center" id="navbarNavAltMarkup">
          <div class="navbar-nav">
            <a class="nav-link" href="#">
              <i class="fas fa-chart-line"></i> Dashboard
            </a>
            <a class="nav-link" href="#">
              <i class="fas fa-envelope-open-text"></i> Requests  </a>
            <a class="nav-link active" aria-current="page" href="#">
              <i class="fas fa-calendar-alt"></i> My Appointments
            </a>
            <a class="nav-link" href="#">
              <i class="fas fa-user-injured"></i> My Patients
            </a>
          </div>
        </div>
        <div class="d-flex">
          <a class="btn btn-outline-primary ms-auto" href="#">Log Out</a>
        </div>
      </div>
    </nav>
    <router-view></router-view>
    <footer class="footer bg-dark fixed-bottom">
      <div class="container">
      <span class="text-white small">© 2024 TechPulse (Pty) Ltd. All rights reserved. | Version 1.0.0
        Developed
        by
        Jaspa</span>
      </div>
    </footer>
  </div>

</template>

<script>
export default {
  computed: {
    isLoginPage() {
      return this.$route.path === '/login';
    },
    isRegisterPage() {
      return this.$route.path === '/register';
    },
    isOtpPage() {
      return this.$route.path === '/otp';
    },
    isSignUpPage() {
      return this.$route.path === '/signup';
    }
  },
  data() {
    return {
      isLoggedIn: false
    };
  },
  methods: {
    toggleLogin() {
      this.isLoggedIn = !this.isLoggedIn;
    }
  }
};
</script>

<style>
body {
  font-family: 'Lato', sans-serif; /* Apply Lato font to the entire body */
  background: linear-gradient(135deg, #4c4f8d, #3c9b8e, #00a5cf);
  min-height: 100vh;
  margin: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  color: white;
}

.navbar .nav-link {
  margin-right: 2rem; /* Adjust margin as needed */
  padding: 10px 15px; /* Adjust padding as needed */
  border: 1px solid #e0e0e0;
  border-radius: 5px;
}


.container {
  display: flex;
  min-height: 100vh;
}



#content {

  flex: 1;
}


.list-unstyled li a {
  display: flex;
  align-items: center;
  padding: 10px 15px;
  color: #adb5bd;
  /* Light grey text */
  text-decoration: none;
}

.list-unstyled li a:hover {
  background-color: #495057;
  /* Slightly lighter grey for hover */
  color: #fff;
}

.list-unstyled li a i {
  margin-right: 10px;
  /* Margin between icon and menu item name */
}

/* Footer styles */
.footer {
  text-align: center;
  height: 56px;
  /* Same height as navbar */
  line-height: 56px;
  /* Vertically center content */
}
</style>
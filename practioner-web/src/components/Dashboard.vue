<template>
    <div class="card">
      <div class="card-body">
        <h3 class="card-title text-left text-dark">Welcome, {{ doctor.title }} {{ doctorInitials }} {{ doctor.surname }}!</h3>
        <div class="alert alert-secondary text-left">
          <p>Welcome to MedicNest, your virtual practice! Here you can create an appointment, join scheduled appointments, and search for patien</p>
        </div>
        <div class="btn-group" role="group" aria-label="Appointment buttons">
          <button type="button" class="btn btn-primary mx-3">
            <i class="fas fa-calendar-alt"></i> View your Schedule
          </button>
          <button type="button" class="btn btn-secondary">
            <i class="fa fa-search"></i> Find a patient
          </button>
        </div>
        <div class="my-5">
          <h4>Upcoming Appointment</h4>
          <div v-if="appointments.length > 0">
            <div v-for="appointment in appointments" :key="appointment.id" class="card mb-3 shadow-sm h-100">
              <div class="row g-0">
                <div class="col-md-4 d-flex flex-column align-items-center justify-content-center border-end border-primary">
                  <p class="mb-0 fw-bold text-primary">{{ getMonth(appointment.dateTime) }}</p>
                  <h1 class="display-4 mb-0">{{ getDate(appointment.dateTime) }}</h1>
                </div>
                <div class="col-md-8">
                  <div class="card-body">
                    <h5 class="card-title text-left">{{ appointment.title }}</h5>
                    <p class="card-text text-left">{{ appointment.description }}</p>
                    <div class="d-flex justify-content-between align-items-center">
                      <span class="text-muted">{{ appointment.doctorName }}</span>
                      <button type="button" class="btn-close" @click="cancelAppointment(appointment.id)"></button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <p v-else>No appointments found.</p>
        </div>
      </div>
    </div>
</template>

<script>
import {getAuth} from "firebase/auth";
import {doc, getFirestore, getDoc, collection, getDocs, query, where} from "firebase/firestore";

export default {
  name: 'Dashboard',
  data() {
    return {
      doctor: {},
      appointments: []
    };
  },
  async created() {
    await this.fetchDoctor();
    await this.fetchAppointments();
  },
  computed: {
    doctorInitials() {
      if (this.doctor.names) {
        return this.doctor.names
            .split(' ')
            .map(name => name.charAt(0))
            .join('');
      }
      return '';
    }
  },
  methods: {
    async fetchDoctor() {
      const auth = getAuth();
      const user = auth.currentUser;
      if (user) {
        const uid = user.uid;
        const db = getFirestore();
        const docRef = doc(db, "doctors", uid);
        const docSnap = await getDoc(docRef);
        if (docSnap.exists()) {
          this.doctor = docSnap.data();
        } else {
          console.log("No such document!");
        }
      }
    },
    async fetchAppointments() {
      const auth = getAuth();
      const user = auth.currentUser;
      if (user) {
        const uid = user.uid;
        const db = getFirestore();
        const appointmentsRef = collection(db, "appointments");
        const q = query(appointmentsRef, where("doctorId", "==", uid));
        const querySnapshot = await getDocs(q);
        this.appointments = querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
      }
    },
    getMonth(dateTime) {
      const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      const monthIndex = new Date(dateTime).getMonth();
      return monthNames[monthIndex];
    },
    getDate(dateTime) {
      return new Date(dateTime).getDate();
    },
    cancelAppointment(id) {
      // Handle appointment cancellation logic
      console.log(`Cancel appointment with ID: ${id}`);
    }
  },
};
</script>

<style scoped>

</style>
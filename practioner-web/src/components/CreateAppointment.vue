<template>
  <div class="h-100">
    <div class="card shadow-sm">
      <h2 class="card-title text-center">Schedule an appointment</h2>
      <div class="card-body">
        <form @submit.prevent="handleSubmit">
          <div class="mb-3">
            <label for="title" class="form-label font-weight-bold">Title</label>
            <input type="text" class="form-control" id="title" name="title" v-model="title" placeholder="Enter appointment title">
          </div>
          <div class="mb-3">
            <label for="description" class="form-label font-weight-bold">Description</label>
            <textarea class="form-control" id="description" name="description" v-model="description" rows="4" placeholder="Add notes or details about the appointment"></textarea>
          </div>
          <div class="mb-3">
            <label for="patient" class="form-label font-weight-bold d-flex">Patient</label>
            <select class="form-select form-control" id="patient" name="patient" v-model="selectedPatient">
              <option value="">Select Patient</option>
              <option v-for="patient in patients" :key="patient.id" :value="patient.id">{{ patient.name }}</option>
            </select>
          </div>
          <div class="mb-3">
            <label for="duration" class="form-label font-weight-bold">Duration (minutes)</label>
            <input type="number" class="form-control" id="duration" name="duration" min="0" v-model.number="duration" placeholder="Enter duration">
          </div>
          <div class="mb-3">
            <label for="datetime" class="form-label font-weight-bold">Date and Time</label>
            <div class="input-group">
              <input type="datetime-local" class="form-control" id="datetime" name="datetime" v-model="dateTime">

            </div>
          </div>
          <button type="submit" class="btn btn-success w-100" :disabled="!allFieldsFilled">{{ isSubmitting ? 'Saving Appointment...' : 'Create Appointment' }}</button>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import {db} from "@/firebase.js";
import { setDoc, doc, } from 'firebase/firestore';
export default {
  data() {
    return {
      title: '',
      description: '',
      patients: [ // Replace with your actual patient data
        { id: 1, name: 'Patient 1' },
        { id: 2, name: 'Patient 2' },
      ],
      selectedPatient: '',
      duration: 0,
      dateTime: '',
      isSubmitting: false,
    };
  },
  computed: {
    allFieldsFilled() {
      return this.title && this.description && this.selectedPatient && this.duration && this.dateTime;
    },
  },
  methods: {
    async handleSubmit() {
      this.isSubmitting = true;
      try {
        const now = new Date();
        const day = String(now.getDate()).padStart(2, '0');
        const month = String(now.getMonth() + 1).padStart(2, '0'); // Months are 0-based in JavaScript
        const timestamp = String(Date.now()).slice(-3); // Get the last three digits of the timestamp
        const appointmentRefNumber = `MN${day}${month}${timestamp}`;

        const appointmentData = {
          title: this.title,
          description: this.description,
          patient: this.selectedPatient,
          duration: this.duration,
          dateTime: this.dateTime,
        }

        await setDoc(doc(db, 'appointments', appointmentRefNumber), appointmentData);
        this.$router.push('/dashboard');
        console.log('Form submitted:', this.title, this.description, this.selectedPatient, this.duration, this.dateTime);
      }catch (e) {
        console.log(e);
      }finally {
        this.isSubmitting = false;
      }
    },
  },
};
</script>

<style scoped>
.card-body .form-label {
  text-align: left; /* Ensure labels are left-aligned */
}
.card-body .form-label.font-weight-bold {
  font-weight: bold; /* Make bold labels */
}
.card-body .form-label.d-flex {
  display: flex; /* Allow vertical alignment with select element */
}
.form-label {
  text-align: left; /* Ensure labels are left-aligned */
}
.form-label.font-weight-bold {
  font-weight: bold; /* Make bold labels */
}
.form-label.d-flex {
  display: flex; /* Allow vertical alignment with select element */
}
</style>

import { createRouter, createWebHistory } from "vue-router";
import Dashboard from "@/components/Dashboard.vue";
import CreateAppointment from "@/components/CreateAppointment.vue";
import Login from "@/components/Login.vue";
import Register from "@/components/Register.vue";
import Otp from "@/components/Otp.vue";
import CreateAccount from "@/components/CreateAccount.vue";

const router = createRouter({
    history: createWebHistory(),
    routes: [
        { path: "/", name: "Dashboard", component: Dashboard },
        { path: "/login", name: "Login", component: Login },
        { path: "/register", name: "Register", component: Register },
        { path: "/otp", name: "Otp", component: Otp, props: true },
        { path: "/signup", name: "Signup", component: CreateAccount, props: true },
        { path: "/dashboard", name: "Dashboard", component: Dashboard },
        { path: "/createAppointment", name: "CreateAppointment", component: CreateAppointment },
        { path: "/:catchAll(.*)", redirect: "/login" },
    ],
});

export default router;

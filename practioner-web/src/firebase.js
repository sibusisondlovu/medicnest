import { initializeApp } from "firebase/app";
import { getFirestore, doc, updateDoc } from "firebase/firestore";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
    apiKey: "AIzaSyCwZEnCyyYEiY0X9YWB3i_VYOMmC-v3o0w",
    authDomain: "medicnest-jaspa.firebaseapp.com",
    projectId: "medicnest-jaspa",
    storageBucket: "medicnest-jaspa.appspot.com",
    messagingSenderId: "136537596969",
    appId: "1:136537596969:web:93f8f9209485374122a838",
    measurementId: "G-ZMCTQLB0ZJ"

};

export const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
export { doc, updateDoc };

Project Plan

1. Problem - What problem are we solving?
South African patients move between GPs, specialists, clinics and pharmacies with their information scattered across paper files, handwritten scripts and systems that do not talk to each other. The next doctor rarely sees what the last one found, so patients repeat their story, bring the wrong documents and travel without a confirmed appointment. Patients often cannot read their own prescriptions, do not know what each medicine is for, and when they feel unwell they guess, search the internet or wait too long because they do not know how urgent it is or which doctor nearby can help. On the doctor's side, GPs still think and write by hand: they make quick notes during the consultation and then re-type them into the practice system, type referral letters from scratch and phone specialist rooms to find out whether a patient was ever seen. AI scribes have arrived (Heidi, Nora, GoodX's scribe), but they record the consultation and none of them connects GP and specialist practices into a referral network. Medicnest fixes this from both sides: doctors write by hand on a tablet and Medicnest turns it into a doctor-approved record, referral letter and prescription draft that can follow the patient; patients scan their existing prescriptions to understand them, describe how they feel by typing, voice note or photo, get safe guidance on how urgently to seek care, and see GPs nearby. The prototype exists (Android app in Google Play closed testing, Laravel back end). The problem now is proving value with a small group of real users (Proof of Value), then shipping a safe MVP, without the patient-facing AI giving unsafe advice or breaking POPIA, HPCSA or SAHPRA rules.

2. Users - Who is this for?
Primary paying customer: independent private GPs (solo and small practices of 1 to 5 doctors), starting in Tshwane (Pretoria), then the rest of Gauteng, then KwaZulu-Natal and the Free State. Primary users on the doctor side: GPs, practice receptionists and administrators. Receiving side: specialist practices and their administrators (free while the network grows). Primary users on the patient side: adults (18+) in South Africa with an Android smartphone who see private GPs, including caregivers who manage a family member's medicines; patients without smartphones still receive SMS and printed instructions from their doctor. Secondary: Medicnest's own staff in the admin panel (support, clinical safety reviewer, admin and superadmin roles) who verify practitioners, manage the GP directory, review flagged AI outputs and handle data requests. Supporting: Jaspa, which builds, hosts (Jaspa Hosting) and maintains Medicnest, with a practising clinician as clinical adviser. Pre-launch audience: health practitioners and patients who join the waiting list on the landing page. Existing data: only test users in the closed-testing build; production starts empty.

3. Features - What does v1 need?
Delivery is in three stages. Nothing from a later stage is built early.

Stage 0 - Landing page and waiting list (now):
- One page at medicnest.co.za (domain to confirm) with two paths: "I'm a health practitioner" and "I'm a patient"
- Waiting-list form on each path: name, WhatsApp number, email, POPIA consent; role captured automatically
- Analytics on every step (GA4 events with UTM source) so we know who is interested and where they came from
- AI pop-up that explains what Medicnest is and what is coming; it answers product questions only and never gives medical advice
- Submissions stored in the Medicnest API (waitlist table) with an export for the Brand and Partnerships Manager

Stage 1 - Proof of Value (PoV) app (simple; closed testing only; synthetic or consented test data):
- Doctor: sign in; write a consultation note by hand with a stylus on a tablet (or type); AI turns the handwriting into a structured note with the original shown beside it; unclear words, medicine names, doses and units flagged; doctor edits and approves; approved note becomes a PDF referral letter and a prescription draft for wet signature
- Patient: sign up (18+); scan a prescription with the phone camera; AI decodes it into a list of medicines (name, strength, how to take, what it is commonly used for) with a confidence marker on every line and "Confirm with your pharmacist or doctor" on every result; save to "My medicines" as patient-scanned
- Patient: Health Assistant - describe how you feel by typing, a voice note or a photo; the assistant asks follow-up questions, checks for emergency warning signs first, then gives an urgency level (emergency now, see a doctor today, see a GP in the next few days, self-care and monitor), plain-language self-care advice and what to tell the doctor; it does not give a diagnosis
- Patient: Find a GP - list and map of GPs near the patient's location (Google Places, with Medicnest-registered GPs shown first), with distance, open now, call and directions
- Admin: practitioner verification queue, AI output review queue (flagged and sampled conversations), waiting-list export
- Feedback button on every screen; analytics events for the PoV value metrics

Stage 2 - MVP (basic functionality for a paid pilot with 5 to 10 GPs and 2 to 3 specialist practices):
- Practice accounts and roles (GP, receptionist, practice owner), practitioner verification against the HPCSA public register (manual), two-factor sign-in
- Patient records per practice with two-identifier identity check and duplicate review
- Encounters with handwriting and typed notes, approval, versions and amendments
- Documents: consultation summary, referral letter, patient instructions, prescription draft (print and wet signature)
- Referral network: directory of participating practices, required-information checklist, send, accept, ask for more information, decline or redirect with reasons, appointment confirmed by the receiving practice, feedback back to the GP, closure; status and next owner always visible
- Patient app linked to the practice: appointment details, instructions, shared summaries the patient has agreed to, My medicines, Health Assistant and Find a GP (GPs on Medicnest first, with "book through Medicnest" where the practice allows it)
- Consent and sharing controls; full audit log; patient export; practice export
- Notifications: push (OneSignal), email (Mailgun), minimal-content SMS; no clinical details in SMS or email bodies
- GP subscription billing

Must be done before any public release (P0):
- Regulatory review of the Health Assistant and the prescription decoder: written advice on whether they are medical devices under SAHPRA's AI/ML guidance and what must change; until then they run in closed testing only
- Clinical safety case and hazard log signed off by the clinical adviser; red-flag rules and emergency wording reviewed
- POPIA: information officer named, privacy notice, separate consent for AI processing of health information, voice and photos; operator agreements with AI, maps and messaging providers; record of cross-border processing
- Security: secrets out of the code, keys rotated, encryption at rest, role checks enforced on the server, rate limits, backups with a tested restore
- Production cleared of test data; test accounts live in staging only
- Analytics events and crash reporting live

4. Data - What are we storing?
The Medicnest API database on the Jaspa-hosted VPS is the source of truth for all clinical, consent, referral and billing data. Firebase is used only for push token handling (through OneSignal) and remote app configuration; it never stores clinical content.

- Waiting list: name, WhatsApp number, email, role (practitioner or patient), consent, UTM source, timestamps
- Users and practices: accounts, roles, HPCSA registration number and verification record (practitioners), practice details, two-factor settings
- Patients (practice records): names, date of birth, sex, identifiers (SA ID, passport, file number, scheme number), contact details, representatives
- Clinical: encounters, handwriting images and strokes, AI drafts, approved note versions, amendments, documents (PDF), attachments
- Referrals: services, checklists, referral events, information requests, appointments, feedback
- Patient app: profile (18+ check), My medicines (source: scanned, doctor, typed), prescription scan images and decoded results, Health Assistant conversations (text, voice notes, photos, transcripts, urgency outcome), saved GPs, consent choices
- Directory: Medicnest-registered GPs and practices; Google Places results are not stored beyond what Google's terms allow (place ID only)
- AI: prompt and model versions, flags, review outcomes, de-identified quality metrics
- Audit: every view, change, export and share of personal or health information
- Analytics events (no clinical content, no free text)

Retention: clinical records follow HPCSA guidance (at least six years after the record becomes dormant, longer for minors); voice notes and photos sent to the Health Assistant are deleted after 30 days unless the patient saves them; prescription images are deleted after decoding unless saved. Health information is special personal information under POPIA: explicit consent for AI processing, encryption, access logs, patient access, correction and deletion requests.

5. Tech - What stack are we using?
The stack the prototype already uses, extended for the new features. No rewrite.

- Mobile: Flutter (one codebase), Android first (phone app for patients, tablet layout with stylus for doctors); iPhone and iPad in a later release
- API and admin: PHP Laravel (REST API, queues, scheduler), admin panel in Laravel (Filament) or React, on a dedicated Linux VPS hosted by Jaspa Hosting
- Database: MySQL 8 (or PostgreSQL if confirmed in the code audit); Redis for queues and cache; encrypted file storage on the VPS for handwriting images, documents, voice notes and photos
- AI: provider-agnostic AI gateway in the API; handwriting and prescription reading with a vision-capable model; speech-to-text for voice notes; a language model with a fixed, versioned system prompt and rule-based safety checks for the Health Assistant; no AI provider trains on Medicnest data
- Maps and places: Google Maps SDK and Places API (Nearby Search, type doctor) with Google attribution; Medicnest directory first
- Push: OneSignal; email: Mailgun; SMS: SA aggregator with delivery receipts; WhatsApp Business messages later (Meta)
- Landing page: static HTML on the website host; GA4 analytics; waiting-list and chat endpoints on the API
- Payments (GP subscriptions, MVP): PayFast or debit order, to be decided
- Monitoring: Sentry or Crashlytics, uptime alerts, nightly encrypted backups

6. Monetize - How will this make money?
GPs pay, patients use Medicnest free. Planned GP subscriptions (to be tested in the PoV): Medicnest Notes R650 to R950 per doctor per month; Medicnest Notes + Referrals R1,100 to R1,600 per doctor per month (excluding VAT). Receiving specialist practices join free while the network grows. The patient app is free; it brings patients to GPs on Medicnest, which is the reason GPs pay. Later options, only if data supports them: booking or convenience fee for appointments made through the app, featured listing for practices in Find a GP (clearly labelled), enterprise licences for GP groups and clinic networks. Never: selling patient data, paid placement disguised as advice, or payment for referrals. Main costs: AI usage (handwriting, prescriptions, voice and chat), Google Places calls, SMS, hosting, insurance and compliance. Funding: TIA Pre-Seed application (R380,000) covers the doctor-side handwriting and referral work only; the patient Health Assistant and prescription decoder are funded by Jaspa and are outside the grant scope.

7. UI/UX - How should this look and feel?
Calm, clinical and trustworthy, not flashy. Doctors: the tablet feels like a clean notepad; writing is never interrupted; the typed version appears beside the handwriting, with flags in amber and nothing final until the doctor taps Approve. Patients: plain South African English, large text, one task per screen. The Health Assistant always starts by asking about emergency warning signs, shows an urgency level in plain words with a colour, says clearly "This is not a diagnosis", and ends with nearby GPs and an option to share the summary with the doctor. Prescription results show every medicine as a card with a confidence marker and "Confirm with your pharmacist". Emergency numbers are one tap away on every Health Assistant screen. Every button works or is hidden. Never "AI doctor" or "diagnose yourself" in copy; we say "Health Assistant" and "check how urgent it is". The landing page says "Launching soon" and asks one thing: join the waiting list.

# 🌉 SkillBridge - Student Skill Exchange

> **A modern, responsive web application connecting college students to exchange skills and knowledge for free.**
> Built with vanilla HTML, CSS, JavaScript, and Supabase Free Tier — completely self-contained in a single `index.html`.

---

## ✨ Features Overview

| Feature | Description |
| :--- | :--- |
| **🔐 Student Auth** | Email/Password signup and login via Supabase Auth + 1-Click test accounts for immediate multi-user exploration. |
| **👤 Student Profiles** | Avatar generator, university, major, graduation year, availability toggle, star rating, and bio. |
| **💡 Teach & Learn Skills** | Categorized skill management (Tech & Coding, Design, Languages, Math & Science, Business, Music) with proficiency levels (*Beginner*, *Intermediate*, *Advanced*, *Expert*). |
| **🔍 Search & Discovery** | Instant text search (by skill, name, college), category pill filters, and "Who can teach" vs "Who wants to learn" filter. |
| **⚡ Smart Skill Matchmaker** | Proprietary compatibility algorithm that identifies **Mutual Reciprocal Swaps** (Student A teaches what Student B wants AND Student B teaches what Student A wants) with match percentage score. |
| **📬 Learning Requests** | Send structured exchange proposals with target skills, exchange offers, and custom notes; track *Pending*, *Accepted*, *Rejected*, and *Completed* states. |
| **📅 Study Session Scheduler** | Calendar scheduling with duration, notes, and **100% Free Virtual Meeting generation** powered by Jitsi Meet (no account or paid API key needed). |
| **💬 Real-Time Peer Chat** | Direct peer-to-peer messaging powered by Supabase Realtime WebSocket subscriptions with instant local auto-reply simulation in sandbox mode. |
| **🎨 Modern Purple-Blue UI** | Glassmorphism, animated glow accents, gradient cards, toast notifications, responsive desktop top-nav and mobile bottom-nav. |

---

## 🚀 Quick Start (Instant Run)

### Option 1: Direct File Open (Offline Sandbox Mode)
You don't need any server to test the app!
1. Double-click `index.html` in your file explorer to open it directly in any modern browser (Chrome, Edge, Firefox, Safari).
2. The application will start in **Interactive Sandbox Mode** pre-populated with 6 diverse university student profiles (Alex, Maya, Dev, Elena, Marcus, Sophia).
3. Try switching accounts via the **"✨ 1-Click Demo Accounts"** button in the sign-in modal to experience both sides of the skill exchange.

### Option 2: Local HTTP Server (Recommended)
You can serve the directory using any static file server:

```bash
# Using Python 3 (if installed):
python -m http.server 3000

# Using Node (if installed):
npx serve .
```
Then navigate to `http://localhost:3000` in your web browser.

---

## 🗄️ Supabase Free Tier Setup Guide

SkillBridge connects directly to Supabase's free tier for PostgreSQL storage, user authentication, and real-time WebSocket events.

### Step 1: Create a Free Supabase Project
1. Go to [https://supabase.com](https://supabase.com) and create a free account.
2. Click **"New Project"**, choose a project name (e.g. `skillbridge`), and set a database password.

### Step 2: Run Database Schema
1. In your Supabase project dashboard, navigate to the **SQL Editor** tab on the left sidebar.
2. Click **"New Query"**.
3. Open `schema.sql` from this repository, copy its entire contents, paste it into the Supabase SQL editor, and click **Run**.
4. *(Optional)* If you would like sample students and skills pre-loaded into your Supabase database, open `seed.sql`, paste it into the SQL editor, and click **Run**.

### Step 3: Retrieve Project URL & Public Anon Key
1. In Supabase, click **Project Settings** (gear icon) -> **API**.
2. Find:
   - **Project URL** (e.g., `https://xyzcompany.supabase.co`)
   - **Project API Keys** -> `anon` / `public` key (e.g., `eyJhbGciOiJIUzI1Ni...`)
   > ⚠️ **SECURITY NOTICE**: Never copy or expose the `service_role` secret key. SkillBridge only requires the `anon` public key. All tables are protected by Row Level Security (RLS) policies.

### Step 4: Connect in SkillBridge
1. Open `index.html` in your browser.
2. Click the **Database Status Pill** in the top navigation bar (labeled "Local Sandbox Mode" or "Configure Database").
3. Paste your **Supabase Project URL** and **Anon Key**.
4. Click **"Connect to Supabase"**.
5. Your app is now live with real PostgreSQL authentication and Realtime chat!

---

## 🔒 Security Architecture & RLS Policies

All database access is secured by PostgreSQL Row Level Security (RLS):

- **Profiles**: Viewable by any user to enable discovery; updates are restricted strictly to `auth.uid() = id`.
- **Skills**: Publicly readable so students can match; can only be inserted, updated, or deleted by their owner (`auth.uid() = user_id`).
- **Learning Requests**: Visible only to the sender or receiver (`auth.uid() = sender_id OR auth.uid() = receiver_id`).
- **Sessions**: Visible and editable only by the two participating students (`auth.uid() = mentor_id OR auth.uid() = student_id`).
- **Messages**: Visible only to the conversation participants. Insert is restricted to authenticated senders (`auth.uid() = sender_id`).

---

## 🎥 100% Free Virtual Meeting Integration

SkillBridge uses **Jitsi Meet** (`https://meet.jit.si`) for one-click study sessions.
- **Cost**: 100% Free, open-source WebRTC.
- **Privacy & Ease**: No API keys, no registration, and no credit card required.
- **Features**: Live high-definition video, crystal-clear audio, and screen sharing directly in the browser.
- **How it works**: When scheduling a session, SkillBridge generates a unique room link (e.g. `https://meet.jit.si/SkillBridge-[topic]-[hash]`). Both participants click **"Join Video Call"** to immediately enter the virtual study room.

---

## 🌐 Free 1-Click Deployment

Because SkillBridge is contained in a single `index.html` file, you can deploy it for free anywhere:

### Deploy to GitHub Pages:
1. Create a GitHub repository and push `index.html`.
2. Go to **Settings** -> **Pages**.
3. Under **Branch**, select `main` and root `/`.
4. Click **Save**. Your site will be live at `https://<username>.github.io/<repo>/`!

### Deploy to Vercel:
1. Drag and drop the folder into [Vercel](https://vercel.com).
2. It will deploy instantly with a free SSL certificate.

### Deploy to Netlify:
1. Drag and drop the folder into [Netlify Drop](https://app.netlify.com/drop).
2. Your web app is live in 10 seconds.

---

## 📁 Repository Structure

```text
├── index.html     # Complete responsive web app (HTML, CSS, JS, Supabase CDN, Jitsi Meet)
├── schema.sql     # Full Supabase PostgreSQL schema with RLS policies and Realtime triggers
├── seed.sql       # Optional sample data with students, skills, and exchange requests
└── README.md      # Documentation and deployment instructions
```

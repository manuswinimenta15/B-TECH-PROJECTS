-- ========================================================
-- SkillBridge - Student Skill Exchange Database Schema
-- Compatible with Supabase PostgreSQL (Free Tier)
-- ========================================================

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. PROFILES TABLE
-- Stores student profile information linked to Supabase Auth users
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT NOT NULL,
    avatar_url TEXT,
    university TEXT,
    major TEXT,
    grad_year INT,
    bio TEXT,
    rating NUMERIC(3,2) DEFAULT 5.00,
    reviews_count INT DEFAULT 0,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. SKILLS TABLE
-- Stores skills that students can teach or want to learn
CREATE TABLE IF NOT EXISTS public.skills (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    skill_name TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN (
        'Tech & Coding',
        'Design & Creative',
        'Languages',
        'Academics & Science',
        'Business & Career',
        'Music & Arts',
        'Other'
    )),
    skill_type TEXT NOT NULL CHECK (skill_type IN ('teach', 'learn')),
    proficiency TEXT CHECK (proficiency IN ('Beginner', 'Intermediate', 'Advanced', 'Expert')),
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. LEARNING REQUESTS TABLE
-- Tracks exchange / mentorship requests sent between students
CREATE TABLE IF NOT EXISTS public.learning_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    receiver_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    skill_wanted TEXT NOT NULL,
    skill_offered TEXT,
    message TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN (
        'pending',
        'accepted',
        'rejected',
        'completed',
        'cancelled'
    )),
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. SESSIONS TABLE
-- Schedules study sessions between matched students
CREATE TABLE IF NOT EXISTS public.sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID REFERENCES public.learning_requests(id) ON DELETE SET NULL,
    mentor_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    topic TEXT NOT NULL,
    scheduled_at TIMESTAMPTZ NOT NULL,
    duration_minutes INT NOT NULL DEFAULT 45,
    meeting_link TEXT NOT NULL,
    notes TEXT,
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled')),
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. MESSAGES TABLE
-- Direct peer-to-peer messages for real-time chat
CREATE TABLE IF NOT EXISTS public.messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    receiver_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ========================================================
-- INDEXES FOR MAXIMUM QUERY PERFORMANCE
-- ========================================================
CREATE INDEX IF NOT EXISTS idx_skills_user_id ON public.skills(user_id);
CREATE INDEX IF NOT EXISTS idx_skills_type ON public.skills(skill_type);
CREATE INDEX IF NOT EXISTS idx_skills_name ON public.skills(skill_name);
CREATE INDEX IF NOT EXISTS idx_learning_requests_sender ON public.learning_requests(sender_id);
CREATE INDEX IF NOT EXISTS idx_learning_requests_receiver ON public.learning_requests(receiver_id);
CREATE INDEX IF NOT EXISTS idx_sessions_participants ON public.sessions(mentor_id, student_id);
CREATE INDEX IF NOT EXISTS idx_messages_pair ON public.messages(sender_id, receiver_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON public.messages(created_at);

-- ========================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ========================================================

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.learning_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- PROFILES POLICIES
-- Anyone can view student profiles
CREATE POLICY "Public profiles are viewable by everyone" 
ON public.profiles FOR SELECT 
USING (true);

-- Users can insert their own profile
CREATE POLICY "Users can insert their own profile" 
ON public.profiles FOR INSERT 
WITH CHECK (auth.uid() = id);

-- Users can update only their own profile
CREATE POLICY "Users can update their own profile" 
ON public.profiles FOR UPDATE 
USING (auth.uid() = id);

-- SKILLS POLICIES
-- Anyone can view skills to enable student search
CREATE POLICY "Skills are viewable by everyone" 
ON public.skills FOR SELECT 
USING (true);

-- Users can manage their own skills
CREATE POLICY "Users can insert their own skills" 
ON public.skills FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own skills" 
ON public.skills FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own skills" 
ON public.skills FOR DELETE 
USING (auth.uid() = user_id);

-- LEARNING REQUESTS POLICIES
-- Users can see requests where they are either sender or receiver
CREATE POLICY "Users can view their own requests" 
ON public.learning_requests FOR SELECT 
USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- Authenticated users can create requests as sender
CREATE POLICY "Users can create learning requests" 
ON public.learning_requests FOR INSERT 
WITH CHECK (auth.uid() = sender_id);

-- Sender or receiver can update status (e.g. accept/reject/cancel)
CREATE POLICY "Participants can update requests" 
ON public.learning_requests FOR UPDATE 
USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- SESSIONS POLICIES
-- Participants can view their sessions
CREATE POLICY "Participants can view sessions" 
ON public.sessions FOR SELECT 
USING (auth.uid() = mentor_id OR auth.uid() = student_id);

-- Participants can create sessions
CREATE POLICY "Participants can create sessions" 
ON public.sessions FOR INSERT 
WITH CHECK (auth.uid() = mentor_id OR auth.uid() = student_id);

-- Participants can update their sessions (e.g. mark completed)
CREATE POLICY "Participants can update sessions" 
ON public.sessions FOR UPDATE 
USING (auth.uid() = mentor_id OR auth.uid() = student_id);

-- MESSAGES POLICIES
-- Users can view messages they sent or received
CREATE POLICY "Users can view their conversation messages" 
ON public.messages FOR SELECT 
USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- Authenticated users can send messages
CREATE POLICY "Users can insert messages as sender" 
ON public.messages FOR INSERT 
WITH CHECK (auth.uid() = sender_id);

-- Receiver can mark message as read
CREATE POLICY "Receivers can update read status" 
ON public.messages FOR UPDATE 
USING (auth.uid() = receiver_id);

-- ========================================================
-- AUTOMATIC PROFILE CREATION TRIGGER ON AUTH SIGNUP
-- ========================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name, avatar_url)
    VALUES (
        new.id,
        new.email,
        COALESCE(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
        COALESCE(new.raw_user_meta_data->>'avatar_url', 'https://api.dicebear.com/7.x/bottts/svg?seed=' || new.id)
    );
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger the function on auth.users insert
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ========================================================
-- ENABLE REALTIME REPLICATION FOR INSTANT CHAT & REQUESTS
-- ========================================================
-- Adds tables to the supabase_realtime publication
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' AND tablename = 'messages'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' AND tablename = 'learning_requests'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.learning_requests;
    END IF;
END $$;

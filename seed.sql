-- ========================================================
-- SkillBridge - Sample Seed Data for Testing (Optional)
-- Run this in Supabase SQL Editor if you want pre-populated data!
-- Note: Replace UUIDs if you are linking to real auth.users,
-- or use these directly for dummy profile/skills exploration.
-- ========================================================

-- Insert Sample Profiles (mock auth user IDs)
INSERT INTO public.profiles (id, email, full_name, avatar_url, university, major, grad_year, bio, rating, reviews_count, is_available)
VALUES 
    ('00000000-0000-0000-0000-000000000001', 'alex.rivera@campus.edu', 'Alex Rivera', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alex', 'Stanford University', 'Computer Science', 2025, 'Passionate full-stack developer eager to teach React & Node.js, and looking to practice conversational Spanish!', 4.95, 18, true),
    ('00000000-0000-0000-0000-000000000002', 'maya.lin@campus.edu', 'Maya Lin', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Maya', 'UC Berkeley', 'Design & Human-Centered Computing', 2026, 'Product designer passionate about Figma, UI/UX prototyping, and design systems. Looking to learn Python for data analysis.', 4.90, 14, true),
    ('00000000-0000-0000-0000-000000000003', 'dev.patel@campus.edu', 'Dev Patel', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Dev', 'Georgia Tech', 'Applied Mathematics', 2025, 'Math enthusiast who loves breaking down Calculus and Linear Algebra. Wanting to learn UI design basics in Figma.', 4.88, 22, true),
    ('00000000-0000-0000-0000-000000000004', 'elena.rossi@campus.edu', 'Elena Rossi', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Elena', 'NYU', 'Linguistics & Romance Languages', 2024, 'Native Italian & fluent Spanish speaker. Happy to practice conversational Spanish. Wanting to learn Web Development.', 5.00, 31, true),
    ('00000000-0000-0000-0000-000000000005', 'marcus.vance@campus.edu', 'Marcus Vance', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Marcus', 'UT Austin', 'Business Administration', 2025, 'Startup founder and growth marketer. Can teach pitch decks & SEO marketing. Eager to learn Python for scraping.', 4.75, 9, true),
    ('00000000-0000-0000-0000-000000000006', 'sophia.chen@campus.edu', 'Sophia Chen', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Sophia', 'MIT', 'Electrical Engineering & AI', 2026, 'Building ML models and PyTorch pipelines. Looking to learn acoustic guitar and music theory!', 4.92, 16, true)
ON CONFLICT (id) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    university = EXCLUDED.university,
    bio = EXCLUDED.bio;

-- Insert Skills
INSERT INTO public.skills (user_id, skill_name, category, skill_type, proficiency, description)
VALUES
    -- Alex
    ('00000000-0000-0000-0000-000000000001', 'React & Web Dev', 'Tech & Coding', 'teach', 'Expert', 'Component design, state management, modern hooks and responsive CSS.'),
    ('00000000-0000-0000-0000-000000000001', 'Python & APIs', 'Tech & Coding', 'teach', 'Advanced', 'RESTful APIs, Flask, FastAPI and web scraping.'),
    ('00000000-0000-0000-0000-000000000001', 'Conversational Spanish', 'Languages', 'learn', 'Beginner', 'Looking for conversational practice to prepare for study abroad.'),

    -- Maya
    ('00000000-0000-0000-0000-000000000002', 'UI/UX Design in Figma', 'Design & Creative', 'teach', 'Expert', 'Design systems, auto-layout, interactive prototypes and user research.'),
    ('00000000-0000-0000-0000-000000000002', 'Python Data Science', 'Tech & Coding', 'learn', 'Beginner', 'Want to learn pandas, matplotlib and basic data visualization scripts.'),

    -- Dev
    ('00000000-0000-0000-0000-000000000003', 'Calculus & Linear Algebra', 'Academics & Science', 'teach', 'Expert', 'College level calculus, derivatives, integrals, and matrix operations.'),
    ('00000000-0000-0000-0000-000000000003', 'UI/UX Design in Figma', 'Design & Creative', 'learn', 'Beginner', 'Want to make clean dashboards and understand design principles.'),

    -- Elena
    ('00000000-0000-0000-0000-000000000004', 'Conversational Spanish', 'Languages', 'teach', 'Expert', 'Native level fluency, grammar, pronunciation and slang.'),
    ('00000000-0000-0000-0000-000000000004', 'Italian Language', 'Languages', 'teach', 'Expert', 'From basic phrases to advanced conversational fluency.'),
    ('00000000-0000-0000-0000-000000000004', 'React & Web Dev', 'Tech & Coding', 'learn', 'Beginner', 'Building my portfolio website from scratch.'),

    -- Marcus
    ('00000000-0000-0000-0000-000000000005', 'Startup Pitch Decks & SEO', 'Business & Career', 'teach', 'Advanced', 'Investor deck framing, storytelling, SEO keyword research.'),
    ('00000000-0000-0000-0000-000000000005', 'Python & APIs', 'Tech & Coding', 'learn', 'Beginner', 'Automating spreadsheet data with basic Python.'),

    -- Sophia
    ('00000000-0000-0000-0000-000000000006', 'Machine Learning & PyTorch', 'Tech & Coding', 'teach', 'Expert', 'Deep learning basics, neural networks, image and NLP tasks.'),
    ('00000000-0000-0000-0000-000000000006', 'Acoustic Guitar', 'Music & Arts', 'learn', 'Beginner', 'Learning chords, rhythm and fingerpicking basics.');

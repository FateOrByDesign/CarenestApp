-- ============================================
-- CareNest - Supabase Database Schema
-- Shared by Admin Portal + Mobile App
-- ============================================
-- Run this in Supabase Dashboard > SQL Editor
-- ============================================


-- ============================================
-- 1. Admins (Admin Portal users)
-- ============================================
CREATE TABLE IF NOT EXISTS admins (
    id SERIAL PRIMARY KEY,
    auth_id UUID REFERENCES auth.users(id),
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    role TEXT DEFAULT 'admin',
    created_at TIMESTAMPTZ DEFAULT now()
);


-- ============================================
-- 2. Caregiver Profiles
-- ============================================
CREATE TABLE IF NOT EXISTS caregiver_profiles (
    id SERIAL PRIMARY KEY,
    auth_id UUID REFERENCES auth.users(id),
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    nic TEXT,
    date_of_birth DATE,
    gender TEXT,
    profile_image_url TEXT,
    location TEXT,
    service_area TEXT,
    address TEXT,
    about TEXT,
    license_number TEXT,
    hourly_rate DECIMAL(10,2),
    experience_years INTEGER,
    total_patients INTEGER DEFAULT 0,
    rating DECIMAL(2,1) DEFAULT 0,
    on_time_rate DECIMAL(5,2),
    completion_rate DECIMAL(5,2),
    satisfaction_rating DECIMAL(2,1),
    response_time TEXT,
    status TEXT DEFAULT 'Active',
    verified BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);


-- ============================================
-- 3. Patient Profiles
-- ============================================
CREATE TABLE IF NOT EXISTS patient_profiles (
    id SERIAL PRIMARY KEY,
    auth_id UUID REFERENCES auth.users(id),
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    patient_code TEXT,
    date_of_birth DATE,
    age INTEGER,
    gender TEXT,
    blood_type TEXT,
    height_cm DECIMAL(5,1),
    weight_kg DECIMAL(5,1),
    bmi DECIMAL(4,1),
    profile_image_url TEXT,
    address TEXT,
    location TEXT,
    status TEXT DEFAULT 'Active',
    created_at TIMESTAMPTZ DEFAULT now()
);


-- ============================================
-- 4. Caregiver Applications
-- ============================================
CREATE TABLE IF NOT EXISTS caregiver_applications (
    id SERIAL PRIMARY KEY,
    caregiver_id INTEGER REFERENCES caregiver_profiles(id),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    nic TEXT,
    submitted_date DATE NOT NULL,
    status TEXT DEFAULT 'Pending',
    skills TEXT,
    experience TEXT,
    rejection_reason TEXT,
    doc_nic_front TEXT,
    doc_nic_back TEXT,
    doc_certificate TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);


-- ============================================
-- 5. Bookings
-- ============================================
CREATE TABLE IF NOT EXISTS bookings (
    id TEXT PRIMARY KEY,
    patient_id INTEGER REFERENCES patient_profiles(id),
    caregiver_id INTEGER REFERENCES caregiver_profiles(id),
    service_type TEXT NOT NULL,
    status TEXT DEFAULT 'Pending',
    date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    time_slot TEXT,
    location TEXT NOT NULL,
    description TEXT,
    care_notes TEXT,
    payment_status TEXT DEFAULT 'Unpaid',
    flagged BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);


-- ============================================
-- 6. Caregiver Specializations
-- ============================================
CREATE TABLE IF NOT EXISTS caregiver_specializations (
    id SERIAL PRIMARY KEY,
    caregiver_id INTEGER REFERENCES caregiver_profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL
);


-- ============================================
-- 7. Caregiver Certifications
-- ============================================
CREATE TABLE IF NOT EXISTS caregiver_certifications (
    id SERIAL PRIMARY KEY,
    caregiver_id INTEGER REFERENCES caregiver_profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    issuer TEXT,
    issued_date DATE,
    valid_until DATE,
    document_url TEXT
);


-- ============================================
-- 8. Caregiver Languages
-- ============================================
CREATE TABLE IF NOT EXISTS caregiver_languages (
    id SERIAL PRIMARY KEY,
    caregiver_id INTEGER REFERENCES caregiver_profiles(id) ON DELETE CASCADE,
    language TEXT NOT NULL,
    proficiency TEXT NOT NULL
);


-- ============================================
-- 9. Caregiver Availability
-- ============================================
CREATE TABLE IF NOT EXISTS caregiver_availability (
    id SERIAL PRIMARY KEY,
    caregiver_id INTEGER REFERENCES caregiver_profiles(id) ON DELETE CASCADE,
    day_of_week TEXT NOT NULL,
    start_time TIME,
    end_time TIME,
    is_available BOOLEAN DEFAULT true
);


-- ============================================
-- 10. Caregiver Documents
-- ============================================
CREATE TABLE IF NOT EXISTS caregiver_documents (
    id SERIAL PRIMARY KEY,
    caregiver_id INTEGER REFERENCES caregiver_profiles(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    document_url TEXT,
    verified BOOLEAN DEFAULT false,
    uploaded_at TIMESTAMPTZ DEFAULT now()
);

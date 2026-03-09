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

-- ============================================
-- CareNest.lk Admin Portal - Database Schema
-- ============================================

CREATE DATABASE IF NOT EXISTS carenest_admin;
USE carenest_admin;

-- ============================================
-- 1. Admins Table
-- ============================================
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS caregiver_applications;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS admins;

CREATE TABLE admins (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(30) DEFAULT 'admin',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 2. Users Table (Family + Caregiver)
-- ============================================
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  phone VARCHAR(30),
  role ENUM('Family', 'Caregiver') NOT NULL,
  status ENUM('Active', 'Suspended') DEFAULT 'Active',
  location VARCHAR(200),
  nic VARCHAR(20) DEFAULT NULL,
  rating DECIMAL(2,1) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 3. Caregiver Applications Table
-- ============================================
CREATE TABLE caregiver_applications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL,
  phone VARCHAR(30),
  nic VARCHAR(20),
  submitted_date DATE NOT NULL,
  status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
  skills TEXT,
  experience TEXT,
  rejection_reason TEXT DEFAULT NULL,
  doc_nic_front VARCHAR(255) DEFAULT NULL,
  doc_nic_back VARCHAR(255) DEFAULT NULL,
  doc_certificate VARCHAR(255) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 4. Bookings Table
-- ============================================
CREATE TABLE bookings (
  id VARCHAR(20) PRIMARY KEY,
  service_type ENUM('Hospital', 'Home Visit') NOT NULL,
  status ENUM('Pending', 'Accepted', 'Ongoing', 'Completed', 'Cancelled') DEFAULT 'Pending',
  created_at DATE NOT NULL,
  date DATE NOT NULL,
  time_slot VARCHAR(30) NOT NULL,
  location VARCHAR(300) NOT NULL,
  family_id INT,
  caregiver_id INT,
  payment_status ENUM('Unpaid', 'Paid', 'Refunded') DEFAULT 'Unpaid',
  flagged BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (family_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (caregiver_id) REFERENCES users(id) ON DELETE SET NULL
);

/**
 * Test Setup - Creates a fresh in-memory SQLite DB for each test suite.
 *
 * Usage in test files:
 *   const { app, getToken, db } = require("./setup");
 *
 * getToken() returns a valid JWT for authenticated requests.
 */

const Database = require("better-sqlite3");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

// --- Use in-memory DB for tests (must be prefixed with "mock" for jest.mock) ---
const mockDb = new Database(":memory:");
mockDb.pragma("journal_mode = WAL");
mockDb.pragma("foreign_keys = ON");

// Override the db module BEFORE requiring anything else
jest.mock("../config/db", () => mockDb);

// Mock initDatabase so server.js doesn't try to seed the real DB
jest.mock("../config/initDb", () => jest.fn());

// Set env vars for JWT
process.env.JWT_SECRET = "test_jwt_secret";
process.env.JWT_EXPIRES_IN = "1h";

// Now require app (it will use the mocked db)
const app = require("../server");

/**
 * Seeds the test database with tables and sample data.
 */
function seedDatabase() {
  // Create tables
  mockDb.exec(`
    CREATE TABLE IF NOT EXISTS admins (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      role TEXT DEFAULT 'admin',
      created_at TEXT DEFAULT (datetime('now'))
    );

    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      phone TEXT,
      role TEXT NOT NULL CHECK(role IN ('Family', 'Caregiver')),
      status TEXT DEFAULT 'Active' CHECK(status IN ('Active', 'Suspended')),
      location TEXT,
      nic TEXT DEFAULT NULL,
      rating REAL DEFAULT NULL,
      created_at TEXT DEFAULT (datetime('now'))
    );

    CREATE TABLE IF NOT EXISTS caregiver_applications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      phone TEXT,
      nic TEXT,
      submitted_date TEXT NOT NULL,
      status TEXT DEFAULT 'Pending' CHECK(status IN ('Pending', 'Approved', 'Rejected')),
      skills TEXT,
      experience TEXT,
      rejection_reason TEXT DEFAULT NULL,
      doc_nic_front TEXT DEFAULT NULL,
      doc_nic_back TEXT DEFAULT NULL,
      doc_certificate TEXT DEFAULT NULL,
      created_at TEXT DEFAULT (datetime('now'))
    );

    CREATE TABLE IF NOT EXISTS bookings (
      id TEXT PRIMARY KEY,
      service_type TEXT NOT NULL CHECK(service_type IN ('Hospital', 'Home Visit')),
      status TEXT DEFAULT 'Pending' CHECK(status IN ('Pending', 'Accepted', 'Ongoing', 'Completed', 'Cancelled')),
      created_at TEXT NOT NULL,
      date TEXT NOT NULL,
      time_slot TEXT NOT NULL,
      location TEXT NOT NULL,
      family_id INTEGER,
      caregiver_id INTEGER,
      payment_status TEXT DEFAULT 'Unpaid' CHECK(payment_status IN ('Unpaid', 'Paid', 'Refunded')),
      flagged INTEGER DEFAULT 0,
      FOREIGN KEY (family_id) REFERENCES users(id),
      FOREIGN KEY (caregiver_id) REFERENCES users(id)
    );
  `);

  // Seed admin
  const hash = bcrypt.hashSync("admin123", 10);
  mockDb.prepare(
    "INSERT INTO admins (name, email, password_hash, role) VALUES (?, ?, ?, ?)"
  ).run("Super Admin", "admin@carenest.lk", hash, "admin");

  // Seed users
  const insertUser = mockDb.prepare(
    "INSERT INTO users (id, name, email, phone, role, status, location, nic, rating, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
  );
  const usersData = [
    [1, "Kamal Perera", "kamal@email.com", "+94 77 100 2001", "Family", "Active", "Colombo 07", null, null, "2025-11-12"],
    [2, "Nimalika Fernando", "nimalika@email.com", "+94 77 123 4567", "Caregiver", "Active", "Nugegoda", "197234567V", 4.8, "2025-10-05"],
    [3, "Sanduni Jayawardena", "sanduni@email.com", "+94 71 200 3003", "Family", "Active", "Dehiwala", null, null, "2025-12-01"],
    [4, "Priya Wijesinghe", "priya@email.com", "+94 71 234 5678", "Caregiver", "Active", "Kandy", "198523456V", 4.6, "2025-09-18"],
    [5, "Ruwan Silva", "ruwan@email.com", "+94 76 300 4004", "Family", "Suspended", "Galle", null, null, "2025-08-22"],
  ];
  const insertUsers = mockDb.transaction(() => {
    usersData.forEach((u) => insertUser.run(...u));
  });
  insertUsers();

  // Seed caregiver applications
  const insertApp = mockDb.prepare(
    "INSERT INTO caregiver_applications (name, email, phone, nic, submitted_date, status, skills, experience, doc_nic_front, doc_nic_back, doc_certificate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
  );
  const appsData = [
    ["Nimalika Fernando", "nimalika@email.com", "+94 77 123 4567", "197234567V", "2026-02-05", "Pending", "Ward care, ICU", "15+ years", "nic_front_1.jpg", "nic_back_1.jpg", "cert_1.pdf"],
    ["Priya Wijesinghe", "priya@email.com", "+94 71 234 5678", "198523456V", "2026-02-04", "Pending", "Elder care", "10 years", "nic_front_2.jpg", "nic_back_2.jpg", "cert_2.pdf"],
    ["Kumari Perera", "kumari@email.com", "+94 76 345 6789", "199012345V", "2026-02-04", "Approved", "Pediatric care", "8 years", "nic_front_3.jpg", "nic_back_3.jpg", "cert_3.pdf"],
    ["Tharushi Bandara", "tharushi@email.com", "+94 78 678 9012", "200156789V", "2026-02-02", "Rejected", "General nursing", "3 years", "nic_front_4.jpg", "nic_back_4.jpg", "cert_4.pdf"],
  ];
  const insertApps = mockDb.transaction(() => {
    appsData.forEach((a) => insertApp.run(...a));
  });
  insertApps();

  // Seed bookings
  const insertBooking = mockDb.prepare(
    "INSERT INTO bookings (id, service_type, status, created_at, date, time_slot, location, family_id, caregiver_id, payment_status, flagged) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
  );
  const bookingsData = [
    ["BKG-10021", "Hospital", "Pending", "2026-02-05", "2026-02-08", "18:00 - 06:00", "Lanka Hospital", 1, 2, "Unpaid", 0],
    ["BKG-10022", "Home Visit", "Accepted", "2026-02-04", "2026-02-07", "08:00 - 14:00", "42/A Galle Road", 3, 4, "Unpaid", 0],
    ["BKG-10023", "Hospital", "Completed", "2026-01-28", "2026-02-01", "09:00 - 17:00", "Nawaloka Hospital", 1, 4, "Paid", 0],
    ["BKG-10024", "Home Visit", "Cancelled", "2026-01-30", "2026-02-03", "18:00 - 06:00", "15 Temple Lane", 5, 2, "Refunded", 1],
  ];
  const insertBookings = mockDb.transaction(() => {
    bookingsData.forEach((b) => insertBooking.run(...b));
  });
  insertBookings();
}

/**
 * Clears all tables and re-seeds the database.
 */
function resetDatabase() {
  mockDb.exec(`
    DELETE FROM bookings;
    DELETE FROM caregiver_applications;
    DELETE FROM users;
    DELETE FROM admins;
    DELETE FROM sqlite_sequence;
  `);
  seedDatabase();
}

/**
 * Returns a valid JWT token for the seeded admin user.
 */
function getToken() {
  return jwt.sign(
    { id: 1, email: "admin@carenest.lk", role: "admin" },
    process.env.JWT_SECRET,
    { expiresIn: "1h" }
  );
}

// Seed on first load
seedDatabase();

module.exports = { app, db: mockDb, getToken, resetDatabase, seedDatabase };

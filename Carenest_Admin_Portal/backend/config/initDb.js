const db = require("./db");
const bcrypt = require("bcryptjs");

function initDatabase() {
  // Create tables
  db.exec(`
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

  // Seed only if admins table is empty
  const adminCount = db.prepare("SELECT COUNT(*) AS count FROM admins").get();
  if (adminCount.count > 0) return;

  console.log("Seeding database...");

  // Admin (password: admin123)
  const hash = bcrypt.hashSync("admin123", 10);
  db.prepare("INSERT INTO admins (name, email, password_hash, role) VALUES (?, ?, ?, ?)").run(
    "Super Admin", "admin@carenest.lk", hash, "admin"
  );

  // Users
  const insertUser = db.prepare(
    "INSERT INTO users (id, name, email, phone, role, status, location, nic, rating, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
  );
  const users = [
    [1,  "Kamal Perera",        "kamal.perera@email.com", "+94 77 100 2001", "Family",    "Active",    "Colombo 07",   null,         null, "2025-11-12"],
    [2,  "Nimalika Fernando",   "nimalika.f@email.com",   "+94 77 123 4567", "Caregiver", "Active",    "Nugegoda",     "197234567V", 4.8,  "2025-10-05"],
    [3,  "Sanduni Jayawardena", "sanduni.j@email.com",    "+94 71 200 3003", "Family",    "Active",    "Dehiwala",     null,         null, "2025-12-01"],
    [4,  "Priya Wijesinghe",    "priya.w@email.com",      "+94 71 234 5678", "Caregiver", "Active",    "Kandy",        "198523456V", 4.6,  "2025-09-18"],
    [5,  "Ruwan Silva",         "ruwan.silva@email.com",  "+94 76 300 4004", "Family",    "Suspended", "Galle",        null,         null, "2025-08-22"],
    [6,  "Kumari Perera",       "kumari.p@email.com",     "+94 76 345 6789", "Caregiver", "Active",    "Colombo 05",   "199012345V", 4.9,  "2025-11-30"],
    [7,  "Dilshan Ratnayake",   "dilshan.r@email.com",    "+94 70 400 5005", "Family",    "Active",    "Rajagiriya",   null,         null, "2026-01-03"],
    [8,  "Tharushi Bandara",    "tharushi.b@email.com",   "+94 78 678 9012", "Caregiver", "Suspended", "Matara",       "200156789V", 3.2,  "2025-07-14"],
    [9,  "Amaya Dissanayake",   "amaya.d@email.com",      "+94 75 500 6006", "Family",    "Active",    "Battaramulla", null,         null, "2025-12-20"],
    [10, "Sachini Mendis",      "sachini.m@email.com",    "+94 74 890 1234", "Caregiver", "Active",    "Maharagama",   "199578901V", 4.5,  "2025-10-28"],
    [11, "Tharindu Gunasekara", "tharindu.g@email.com",   "+94 72 600 7007", "Family",    "Suspended", "Negombo",      null,         null, "2025-06-10"],
    [12, "Dilani Rajapaksa",    "dilani.r@email.com",     "+94 72 789 0123", "Caregiver", "Active",    "Colombo 03",   "198267890V", 4.7,  "2025-11-15"],
    [13, "Hasitha Weerasinghe", "hasitha.w@email.com",    "+94 77 700 8008", "Family",    "Active",    "Kottawa",      null,         null, "2026-01-18"],
    [14, "Iresha Gunasekara",   "iresha.g@email.com",     "+94 77 901 2345", "Caregiver", "Suspended", "Panadura",     "198890123V", 2.9,  "2025-05-22"],
    [15, "Nuwan Bandara",       "nuwan.b@email.com",      "+94 70 800 9009", "Family",    "Active",    "Piliyandala",  null,         null, "2025-12-08"],
    [16, "Chamari Athapaththu", "chamari.a@email.com",    "+94 71 012 3456", "Caregiver", "Active",    "Moratuwa",     "199301234V", 4.4,  "2025-09-30"],
    [17, "Lakshitha Fernando",  "lakshitha.f@email.com",  "+94 78 900 1010", "Family",    "Active",    "Colombo 06",   null,         null, "2026-02-01"],
  ];
  const insertUsers = db.transaction(() => { users.forEach((u) => insertUser.run(...u)); });
  insertUsers();

  // Caregiver Applications
  const insertApp = db.prepare(
    "INSERT INTO caregiver_applications (name, email, phone, nic, submitted_date, status, skills, experience, doc_nic_front, doc_nic_back, doc_certificate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
  );
  const apps = [
    ["Nimalika Fernando",   "nimalika.f@email.com",  "+94 77 123 4567", "197234567V", "2026-02-05", "Pending",  "Ward care, ICU monitoring, First Aid certified",           "15+ years in hospital ward care and patient support at Lanka Hospital.",       "nic_front_nimalika.jpg", "nic_back_nimalika.jpg", "cert_nimalika.pdf"],
    ["Priya Wijesinghe",    "priya.w@email.com",     "+94 71 234 5678", "198523456V", "2026-02-04", "Pending",  "Elder care, Dementia support, Medication management",       "10 years experience in elderly care and dementia patient support.",            "nic_front_priya.jpg",    "nic_back_priya.jpg",    "cert_priya.pdf"],
    ["Kumari Perera",       "kumari.p@email.com",    "+94 76 345 6789", "199012345V", "2026-02-04", "Pending",  "Pediatric care, Newborn care, CPR certified",               "8 years in pediatric nursing at Colombo Children's Hospital.",                "nic_front_kumari.jpg",   "nic_back_kumari.jpg",   "cert_kumari.pdf"],
    ["Niluka Silva",        "niluka.s@email.com",    "+94 70 456 7890", "198834567V", "2026-02-03", "Approved", "Post-surgery care, Wound management, Patient mobility",     "12 years in post-operative patient care and rehabilitation.",                  "nic_front_niluka.jpg",   "nic_back_niluka.jpg",   "cert_niluka.pdf"],
    ["Ayesha Silva",        "ayesha.s@email.com",    "+94 75 567 8901", "199145678V", "2026-02-03", "Approved", "Home care, Companion care, Meal preparation",               "6 years providing home-based companion care for elderly patients.",            "nic_front_ayesha.jpg",   "nic_back_ayesha.jpg",   "cert_ayesha.pdf"],
    ["Tharushi Bandara",    "tharushi.b@email.com",  "+94 78 678 9012", "200156789V", "2026-02-02", "Rejected", "General nursing, Vital signs monitoring",                    "3 years as a general nursing assistant.",                                      "nic_front_tharushi.jpg", "nic_back_tharushi.jpg", "cert_tharushi.pdf"],
    ["Dilani Rajapaksa",    "dilani.r@email.com",    "+94 72 789 0123", "198267890V", "2026-02-01", "Pending",  "Palliative care, Pain management, Emotional support",       "9 years in palliative care at National Cancer Hospital.",                      "nic_front_dilani.jpg",   "nic_back_dilani.jpg",   "cert_dilani.pdf"],
    ["Sachini Mendis",      "sachini.m@email.com",   "+94 74 890 1234", "199578901V", "2026-01-31", "Pending",  "Physiotherapy assistance, Mobility training",               "5 years assisting physiotherapists with patient recovery programs.",            "nic_front_sachini.jpg",  "nic_back_sachini.jpg",  "cert_sachini.pdf"],
    ["Iresha Gunasekara",   "iresha.g@email.com",    "+94 77 901 2345", "198890123V", "2026-01-30", "Rejected", "Basic nursing, Patient hygiene care",                        "2 years in a private nursing facility.",                                       "nic_front_iresha.jpg",   "nic_back_iresha.jpg",   "cert_iresha.pdf"],
    ["Chamari Athapaththu", "chamari.a@email.com",   "+94 71 012 3456", "199301234V", "2026-01-29", "Pending",  "Overnight hospital care, IV monitoring, Emergency response", "7 years in overnight hospital care and emergency ward assistance.",            "nic_front_chamari.jpg",  "nic_back_chamari.jpg",  "cert_chamari.pdf"],
  ];
  const insertApps = db.transaction(() => { apps.forEach((a) => insertApp.run(...a)); });
  insertApps();

  // Bookings
  const insertBooking = db.prepare(
    "INSERT INTO bookings (id, service_type, status, created_at, date, time_slot, location, family_id, caregiver_id, payment_status, flagged) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
  );
  const bookings = [
    ["BKG-10021", "Hospital",   "Pending",   "2026-02-05", "2026-02-08", "18:00 - 06:00", "Lanka Hospital, Colombo 05",          1,  2,  "Unpaid",   0],
    ["BKG-10022", "Home Visit", "Accepted",  "2026-02-04", "2026-02-07", "08:00 - 14:00", "42/A Galle Road, Dehiwala",           3,  4,  "Unpaid",   0],
    ["BKG-10023", "Hospital",   "Ongoing",   "2026-02-03", "2026-02-06", "20:00 - 08:00", "Nawaloka Hospital, Colombo 02",       7,  6,  "Paid",     0],
    ["BKG-10024", "Home Visit", "Completed", "2026-01-28", "2026-02-01", "09:00 - 17:00", "15 Temple Lane, Nugegoda",            9,  10, "Paid",     0],
    ["BKG-10025", "Hospital",   "Cancelled", "2026-01-30", "2026-02-03", "18:00 - 06:00", "Asiri Central Hospital, Colombo 10",  5,  12, "Refunded", 0],
    ["BKG-10026", "Home Visit", "Pending",   "2026-02-05", "2026-02-09", "07:00 - 13:00", "88 Kotte Road, Rajagiriya",           13, 16, "Unpaid",   0],
    ["BKG-10027", "Hospital",   "Accepted",  "2026-02-04", "2026-02-07", "22:00 - 06:00", "Durdans Hospital, Colombo 03",        15, 2,  "Unpaid",   0],
    ["BKG-10028", "Home Visit", "Ongoing",   "2026-02-03", "2026-02-06", "10:00 - 18:00", "27 Park Avenue, Battaramulla",        17, 4,  "Paid",     0],
    ["BKG-10029", "Hospital",   "Completed", "2026-01-25", "2026-01-28", "18:00 - 06:00", "Lanka Hospital, Colombo 05",          1,  12, "Paid",     0],
    ["BKG-10030", "Home Visit", "Cancelled", "2026-01-29", "2026-02-02", "08:00 - 16:00", "5 Lake View, Kottawa",                11, 10, "Refunded", 0],
    ["BKG-10031", "Hospital",   "Pending",   "2026-02-06", "2026-02-10", "19:00 - 07:00", "Hemas Hospital, Wattala",             3,  6,  "Unpaid",   0],
    ["BKG-10032", "Home Visit", "Accepted",  "2026-02-05", "2026-02-08", "06:00 - 14:00", "112 High Level Road, Maharagama",     9,  16, "Unpaid",   0],
    ["BKG-10033", "Hospital",   "Completed", "2026-01-20", "2026-01-23", "18:00 - 06:00", "Asiri Surgical Hospital, Colombo 05", 7,  2,  "Paid",     0],
    ["BKG-10034", "Home Visit", "Ongoing",   "2026-02-04", "2026-02-06", "14:00 - 22:00", "33 Flower Road, Colombo 07",          13, 12, "Paid",     0],
    ["BKG-10035", "Hospital",   "Cancelled", "2026-01-27", "2026-01-30", "20:00 - 08:00", "Nawaloka Hospital, Colombo 02",       5,  4,  "Refunded", 0],
    ["BKG-10036", "Home Visit", "Pending",   "2026-02-06", "2026-02-11", "09:00 - 15:00", "7 Sea View Lane, Panadura",           17, 10, "Unpaid",   0],
    ["BKG-10037", "Hospital",   "Accepted",  "2026-02-05", "2026-02-09", "18:00 - 06:00", "Lanka Hospital, Colombo 05",          15, 6,  "Unpaid",   0],
    ["BKG-10038", "Home Visit", "Completed", "2026-01-22", "2026-01-25", "08:00 - 16:00", "19 Temple Road, Moratuwa",            1,  16, "Paid",     0],
  ];
  const insertBookings = db.transaction(() => { bookings.forEach((b) => insertBooking.run(...b)); });
  insertBookings();

  console.log("Database seeded successfully.");
}

module.exports = initDatabase;

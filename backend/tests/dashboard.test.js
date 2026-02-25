const request = require("supertest");
const { app, getToken, resetDatabase } = require("./setup");

let token;

beforeAll(() => {
  token = getToken();
});

beforeEach(() => {
  resetDatabase();
});

describe("GET /api/dashboard/stats", () => {
  it("should return all 4 stat counts", async () => {
    const res = await request(app)
      .get("/api/dashboard/stats")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data).toHaveProperty("pendingApplications");
    expect(res.body.data).toHaveProperty("totalBookings");
    expect(res.body.data).toHaveProperty("totalUsers");
    expect(res.body.data).toHaveProperty("activeCaregivers");
  });

  it("should return correct counts from seed data", async () => {
    const res = await request(app)
      .get("/api/dashboard/stats")
      .set("Authorization", `Bearer ${token}`);

    // Seed has: 2 pending apps, 4 bookings, 5 users, 2 active caregivers
    expect(res.body.data.pendingApplications).toBe(2);
    expect(res.body.data.totalBookings).toBe(4);
    expect(res.body.data.totalUsers).toBe(5);
    expect(res.body.data.activeCaregivers).toBe(2);
  });

  it("should return 401 without token", async () => {
    const res = await request(app).get("/api/dashboard/stats");
    expect(res.status).toBe(401);
  });
});

describe("GET /api/dashboard/recent-applications", () => {
  it("should return array of recent applications", async () => {
    const res = await request(app)
      .get("/api/dashboard/recent-applications")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(Array.isArray(res.body.data)).toBe(true);
    expect(res.body.data.length).toBeGreaterThan(0);
  });

  it("should include name, email, submitted_date, status fields", async () => {
    const res = await request(app)
      .get("/api/dashboard/recent-applications")
      .set("Authorization", `Bearer ${token}`);

    const first = res.body.data[0];
    expect(first).toHaveProperty("name");
    expect(first).toHaveProperty("email");
    expect(first).toHaveProperty("submitted_date");
    expect(first).toHaveProperty("status");
  });

  it("should return max 10 results ordered by date DESC", async () => {
    const res = await request(app)
      .get("/api/dashboard/recent-applications")
      .set("Authorization", `Bearer ${token}`);

    expect(res.body.data.length).toBeLessThanOrEqual(10);

    // Check ordering - first date >= second date
    if (res.body.data.length >= 2) {
      expect(res.body.data[0].submitted_date >= res.body.data[1].submitted_date).toBe(true);
    }
  });
});

describe("GET /api/dashboard/recent-bookings", () => {
  it("should return array of recent bookings", async () => {
    const res = await request(app)
      .get("/api/dashboard/recent-bookings")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(Array.isArray(res.body.data)).toBe(true);
    expect(res.body.data.length).toBeGreaterThan(0);
  });

  it("should include booking id, family_name, caregiver_name, status", async () => {
    const res = await request(app)
      .get("/api/dashboard/recent-bookings")
      .set("Authorization", `Bearer ${token}`);

    const first = res.body.data[0];
    expect(first).toHaveProperty("id");
    expect(first).toHaveProperty("family_name");
    expect(first).toHaveProperty("caregiver_name");
    expect(first).toHaveProperty("status");
  });
});

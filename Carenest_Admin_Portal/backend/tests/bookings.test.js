const request = require("supertest");
const { app, getToken, resetDatabase } = require("./setup");

let token;

beforeAll(() => {
  token = getToken();
});

beforeEach(() => {
  resetDatabase();
});

describe("GET /api/bookings", () => {
  it("should return all bookings", async () => {
    const res = await request(app)
      .get("/api/bookings")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(Array.isArray(res.body.data)).toBe(true);
    expect(res.body.data.length).toBe(4);
  });

  it("should return bookings with camelCase fields and nested objects", async () => {
    const res = await request(app)
      .get("/api/bookings")
      .set("Authorization", `Bearer ${token}`);

    const booking = res.body.data[0];
    expect(booking).toHaveProperty("id");
    expect(booking).toHaveProperty("serviceType");
    expect(booking).toHaveProperty("status");
    expect(booking).toHaveProperty("date");
    expect(booking).toHaveProperty("timeSlot");
    expect(booking).toHaveProperty("location");
    expect(booking).toHaveProperty("paymentStatus");
    expect(booking).toHaveProperty("flagged");
    expect(booking).toHaveProperty("family");
    expect(booking).toHaveProperty("caregiver");
    expect(booking.family).toHaveProperty("name");
    expect(booking.family).toHaveProperty("email");
    expect(booking.family).toHaveProperty("phone");
    expect(booking.caregiver).toHaveProperty("name");
  });

  it("should filter by status=Pending", async () => {
    const res = await request(app)
      .get("/api/bookings?status=Pending")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    res.body.data.forEach((b) => {
      expect(b.status).toBe("Pending");
    });
  });

  it("should filter by serviceType=Hospital", async () => {
    const res = await request(app)
      .get("/api/bookings?serviceType=Hospital")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    res.body.data.forEach((b) => {
      expect(b.serviceType).toBe("Hospital");
    });
  });

  it("should filter by serviceType=Home Visit", async () => {
    const res = await request(app)
      .get("/api/bookings?serviceType=Home Visit")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    res.body.data.forEach((b) => {
      expect(b.serviceType).toBe("Home Visit");
    });
  });

  it("should filter by date range (from)", async () => {
    const res = await request(app)
      .get("/api/bookings?from=2026-02-05")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    res.body.data.forEach((b) => {
      expect(b.date >= "2026-02-05").toBe(true);
    });
  });

  it("should filter by date range (from + to)", async () => {
    const res = await request(app)
      .get("/api/bookings?from=2026-02-01&to=2026-02-07")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    res.body.data.forEach((b) => {
      expect(b.date >= "2026-02-01").toBe(true);
      expect(b.date <= "2026-02-07").toBe(true);
    });
  });

  it("should search by booking ID", async () => {
    const res = await request(app)
      .get("/api/bookings?search=BKG-10021")
      .set("Authorization", `Bearer ${token}`);

    expect(res.body.data.length).toBe(1);
    expect(res.body.data[0].id).toBe("BKG-10021");
  });

  it("should search by family name", async () => {
    const res = await request(app)
      .get("/api/bookings?search=Kamal")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.data.length).toBeGreaterThan(0);
    res.body.data.forEach((b) => {
      expect(b.family.name.toLowerCase()).toContain("kamal");
    });
  });

  it("should combine multiple filters", async () => {
    const res = await request(app)
      .get("/api/bookings?status=Pending&serviceType=Hospital")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    res.body.data.forEach((b) => {
      expect(b.status).toBe("Pending");
      expect(b.serviceType).toBe("Hospital");
    });
  });

  it("should return empty array for no matches", async () => {
    const res = await request(app)
      .get("/api/bookings?search=nonexistent_booking")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.data.length).toBe(0);
  });
});

describe("GET /api/bookings/:id", () => {
  it("should return a single booking with full details", async () => {
    const res = await request(app)
      .get("/api/bookings/BKG-10021")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.id).toBe("BKG-10021");
    expect(res.body.data.serviceType).toBe("Hospital");
    expect(res.body.data.family.name).toBe("Kamal Perera");
    expect(res.body.data.caregiver.name).toBe("Nimalika Fernando");
  });

  it("should return 404 for non-existent booking", async () => {
    const res = await request(app)
      .get("/api/bookings/BKG-99999")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });
});

describe("PATCH /api/bookings/:id/flag", () => {
  it("should flag an unflagged booking", async () => {
    const res = await request(app)
      .patch("/api/bookings/BKG-10021/flag")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.flagged).toBe(true);
    expect(res.body.message).toMatch(/flagged/i);

    // Verify persisted
    const check = await request(app)
      .get("/api/bookings/BKG-10021")
      .set("Authorization", `Bearer ${token}`);
    expect(check.body.data.flagged).toBe(true);
  });

  it("should unflag a flagged booking", async () => {
    // BKG-10024 is seeded as flagged=1
    const res = await request(app)
      .patch("/api/bookings/BKG-10024/flag")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.data.flagged).toBe(false);
    expect(res.body.message).toMatch(/unflagged/i);
  });

  it("should toggle back and forth", async () => {
    // First: unflagged -> flagged
    const res1 = await request(app)
      .patch("/api/bookings/BKG-10021/flag")
      .set("Authorization", `Bearer ${token}`);
    expect(res1.body.data.flagged).toBe(true);

    // Second: flagged -> unflagged
    const res2 = await request(app)
      .patch("/api/bookings/BKG-10021/flag")
      .set("Authorization", `Bearer ${token}`);
    expect(res2.body.data.flagged).toBe(false);
  });

  it("should return 404 for non-existent booking", async () => {
    const res = await request(app)
      .patch("/api/bookings/BKG-99999/flag")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });
});

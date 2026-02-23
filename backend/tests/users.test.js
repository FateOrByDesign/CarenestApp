const request = require("supertest");
const { app, getToken, resetDatabase } = require("./setup");

let token;

beforeAll(() => {
  token = getToken();
});

beforeEach(() => {
  resetDatabase();
});

describe("GET /api/users", () => {
  it("should return all users", async () => {
    const res = await request(app)
      .get("/api/users")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(Array.isArray(res.body.data)).toBe(true);
    expect(res.body.data.length).toBe(5);
  });

  it("should filter by role=Family", async () => {
    const res = await request(app)
      .get("/api/users?role=Family")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.data.length).toBe(3);
    res.body.data.forEach((u) => {
      expect(u.role).toBe("Family");
    });
  });

  it("should filter by role=Caregiver", async () => {
    const res = await request(app)
      .get("/api/users?role=Caregiver")
      .set("Authorization", `Bearer ${token}`);

    expect(res.body.data.length).toBe(2);
    res.body.data.forEach((u) => {
      expect(u.role).toBe("Caregiver");
    });
  });

  it("should filter by status=Active", async () => {
    const res = await request(app)
      .get("/api/users?status=Active")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    res.body.data.forEach((u) => {
      expect(u.status).toBe("Active");
    });
  });

  it("should filter by status=Suspended", async () => {
    const res = await request(app)
      .get("/api/users?status=Suspended")
      .set("Authorization", `Bearer ${token}`);

    expect(res.body.data.length).toBe(1);
    expect(res.body.data[0].name).toBe("Ruwan Silva");
  });

  it("should combine role and status filters", async () => {
    const res = await request(app)
      .get("/api/users?role=Family&status=Active")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    res.body.data.forEach((u) => {
      expect(u.role).toBe("Family");
      expect(u.status).toBe("Active");
    });
  });

  it("should search by name", async () => {
    const res = await request(app)
      .get("/api/users?search=Kamal")
      .set("Authorization", `Bearer ${token}`);

    expect(res.body.data.length).toBe(1);
    expect(res.body.data[0].name).toBe("Kamal Perera");
  });

  it("should search by email", async () => {
    const res = await request(app)
      .get("/api/users?search=nimalika")
      .set("Authorization", `Bearer ${token}`);

    expect(res.body.data.length).toBe(1);
    expect(res.body.data[0].email).toContain("nimalika");
  });

  it("should search by phone", async () => {
    const res = await request(app)
      .get("/api/users?search=77 100")
      .set("Authorization", `Bearer ${token}`);

    expect(res.body.data.length).toBe(1);
    expect(res.body.data[0].name).toBe("Kamal Perera");
  });

  it("should return empty array for no matches", async () => {
    const res = await request(app)
      .get("/api/users?search=zzzzzzz")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.data.length).toBe(0);
  });
});

describe("GET /api/users/:id", () => {
  it("should return a single user", async () => {
    const res = await request(app)
      .get("/api/users/1")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.name).toBe("Kamal Perera");
    expect(res.body.data.role).toBe("Family");
  });

  it("should return caregiver-specific fields for caregiver user", async () => {
    const res = await request(app)
      .get("/api/users/2")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.data.role).toBe("Caregiver");
    expect(res.body.data.nic).toBe("197234567V");
    expect(res.body.data.rating).toBe(4.8);
  });

  it("should return 404 for non-existent user", async () => {
    const res = await request(app)
      .get("/api/users/9999")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });
});

describe("PATCH /api/users/:id/status", () => {
  it("should suspend an active user", async () => {
    const res = await request(app)
      .patch("/api/users/1/status")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.status).toBe("Suspended");

    // Verify change persisted
    const check = await request(app)
      .get("/api/users/1")
      .set("Authorization", `Bearer ${token}`);
    expect(check.body.data.status).toBe("Suspended");
  });

  it("should activate a suspended user", async () => {
    // User 5 is Suspended
    const res = await request(app)
      .patch("/api/users/5/status")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.status).toBe("Active");
  });

  it("should toggle back and forth", async () => {
    // First toggle: Active -> Suspended
    const res1 = await request(app)
      .patch("/api/users/1/status")
      .set("Authorization", `Bearer ${token}`);
    expect(res1.body.data.status).toBe("Suspended");

    // Second toggle: Suspended -> Active
    const res2 = await request(app)
      .patch("/api/users/1/status")
      .set("Authorization", `Bearer ${token}`);
    expect(res2.body.data.status).toBe("Active");
  });

  it("should return 404 for non-existent user", async () => {
    const res = await request(app)
      .patch("/api/users/9999/status")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });
});

const request = require("supertest");
const { app, getToken, resetDatabase } = require("./setup");

let token;

beforeAll(() => {
  token = getToken();
});

beforeEach(() => {
  resetDatabase();
});

describe("GET /api/caregivers/applications", () => {
  it("should return all applications", async () => {
    const res = await request(app)
      .get("/api/caregivers/applications")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(Array.isArray(res.body.data)).toBe(true);
    expect(res.body.data.length).toBe(4);
  });

  it("should filter by status=Pending", async () => {
    const res = await request(app)
      .get("/api/caregivers/applications?status=Pending")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.data.length).toBe(2);
    res.body.data.forEach((app) => {
      expect(app.status).toBe("Pending");
    });
  });

  it("should filter by status=Approved", async () => {
    const res = await request(app)
      .get("/api/caregivers/applications?status=Approved")
      .set("Authorization", `Bearer ${token}`);

    expect(res.body.data.length).toBe(1);
    expect(res.body.data[0].status).toBe("Approved");
  });

  it("should filter by status=Rejected", async () => {
    const res = await request(app)
      .get("/api/caregivers/applications?status=Rejected")
      .set("Authorization", `Bearer ${token}`);

    expect(res.body.data.length).toBe(1);
    expect(res.body.data[0].status).toBe("Rejected");
  });

  it("should search by name", async () => {
    const res = await request(app)
      .get("/api/caregivers/applications?search=Nimalika")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.data.length).toBe(1);
    expect(res.body.data[0].name).toBe("Nimalika Fernando");
  });

  it("should search by email", async () => {
    const res = await request(app)
      .get("/api/caregivers/applications?search=priya")
      .set("Authorization", `Bearer ${token}`);

    expect(res.body.data.length).toBe(1);
    expect(res.body.data[0].email).toContain("priya");
  });

  it("should search by NIC", async () => {
    const res = await request(app)
      .get("/api/caregivers/applications?search=197234567V")
      .set("Authorization", `Bearer ${token}`);

    expect(res.body.data.length).toBe(1);
    expect(res.body.data[0].nic).toBe("197234567V");
  });

  it("should combine status filter and search", async () => {
    const res = await request(app)
      .get("/api/caregivers/applications?status=Pending&search=Nimalika")
      .set("Authorization", `Bearer ${token}`);

    expect(res.body.data.length).toBe(1);
    expect(res.body.data[0].status).toBe("Pending");
    expect(res.body.data[0].name).toBe("Nimalika Fernando");
  });

  it("should return empty array for no matches", async () => {
    const res = await request(app)
      .get("/api/caregivers/applications?search=nonexistent")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.data.length).toBe(0);
  });
});

describe("GET /api/caregivers/applications/:id", () => {
  it("should return a single application", async () => {
    const res = await request(app)
      .get("/api/caregivers/applications/1")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data).toHaveProperty("name");
    expect(res.body.data).toHaveProperty("email");
    expect(res.body.data).toHaveProperty("skills");
    expect(res.body.data).toHaveProperty("doc_nic_front");
  });

  it("should return 404 for non-existent ID", async () => {
    const res = await request(app)
      .get("/api/caregivers/applications/9999")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });
});

describe("PATCH /api/caregivers/applications/:id/approve", () => {
  it("should approve a pending application", async () => {
    const res = await request(app)
      .patch("/api/caregivers/applications/1/approve")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.message).toMatch(/approved/i);

    // Verify status changed
    const check = await request(app)
      .get("/api/caregivers/applications/1")
      .set("Authorization", `Bearer ${token}`);
    expect(check.body.data.status).toBe("Approved");
  });

  it("should return 404 for already approved application", async () => {
    // Application 3 is already Approved
    const res = await request(app)
      .patch("/api/caregivers/applications/3/approve")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });

  it("should return 404 for non-existent application", async () => {
    const res = await request(app)
      .patch("/api/caregivers/applications/9999/approve")
      .set("Authorization", `Bearer ${token}`);

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });
});

describe("PATCH /api/caregivers/applications/:id/reject", () => {
  it("should reject a pending application with reason", async () => {
    const res = await request(app)
      .patch("/api/caregivers/applications/1/reject")
      .set("Authorization", `Bearer ${token}`)
      .send({ reason: "Insufficient experience" });

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.message).toMatch(/rejected/i);

    // Verify status and reason
    const check = await request(app)
      .get("/api/caregivers/applications/1")
      .set("Authorization", `Bearer ${token}`);
    expect(check.body.data.status).toBe("Rejected");
    expect(check.body.data.rejection_reason).toBe("Insufficient experience");
  });

  it("should return 400 if no reason is provided", async () => {
    const res = await request(app)
      .patch("/api/caregivers/applications/1/reject")
      .set("Authorization", `Bearer ${token}`)
      .send({});

    expect(res.status).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toMatch(/reason/i);
  });

  it("should return 400 if reason is empty string", async () => {
    const res = await request(app)
      .patch("/api/caregivers/applications/1/reject")
      .set("Authorization", `Bearer ${token}`)
      .send({ reason: "   " });

    expect(res.status).toBe(400);
    expect(res.body.success).toBe(false);
  });

  it("should return 404 for already rejected application", async () => {
    // Application 4 is already Rejected
    const res = await request(app)
      .patch("/api/caregivers/applications/4/reject")
      .set("Authorization", `Bearer ${token}`)
      .send({ reason: "Some reason" });

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });
});

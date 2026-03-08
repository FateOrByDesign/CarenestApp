const request = require("supertest");
const { app, getToken, resetDatabase } = require("./setup");

beforeEach(() => {
  resetDatabase();
});

describe("POST /api/auth/login", () => {
  it("should login with valid credentials", async () => {
    const res = await request(app)
      .post("/api/auth/login")
      .send({ email: "admin@carenest.lk", password: "admin123" });

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body).toHaveProperty("token");
    expect(res.body.admin).toMatchObject({
      name: "Super Admin",
      email: "admin@carenest.lk",
      role: "admin",
    });
  });

  it("should return 400 if email is missing", async () => {
    const res = await request(app)
      .post("/api/auth/login")
      .send({ password: "admin123" });

    expect(res.status).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toMatch(/required/i);
  });

  it("should return 400 if password is missing", async () => {
    const res = await request(app)
      .post("/api/auth/login")
      .send({ email: "admin@carenest.lk" });

    expect(res.status).toBe(400);
    expect(res.body.success).toBe(false);
  });

  it("should return 401 for wrong password", async () => {
    const res = await request(app)
      .post("/api/auth/login")
      .send({ email: "admin@carenest.lk", password: "wrongpass" });

    expect(res.status).toBe(401);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toMatch(/invalid/i);
  });

  it("should return 401 for non-existent email", async () => {
    const res = await request(app)
      .post("/api/auth/login")
      .send({ email: "nobody@email.com", password: "admin123" });

    expect(res.status).toBe(401);
    expect(res.body.success).toBe(false);
  });
});

describe("POST /api/auth/register", () => {
  it("should register a new admin", async () => {
    const res = await request(app)
      .post("/api/auth/register")
      .send({ name: "New Admin", email: "new@carenest.lk", password: "newpass123" });

    expect(res.status).toBe(201);
    expect(res.body.success).toBe(true);
    expect(res.body).toHaveProperty("token");
    expect(res.body.admin).toMatchObject({
      name: "New Admin",
      email: "new@carenest.lk",
      role: "admin",
    });
  });

  it("should return 400 if required fields are missing", async () => {
    const res = await request(app)
      .post("/api/auth/register")
      .send({ email: "test@email.com" });

    expect(res.status).toBe(400);
    expect(res.body.success).toBe(false);
  });

  it("should return 409 if email already exists", async () => {
    const res = await request(app)
      .post("/api/auth/register")
      .send({ name: "Dup Admin", email: "admin@carenest.lk", password: "pass123" });

    expect(res.status).toBe(409);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toMatch(/already/i);
  });
});

describe("JWT Authentication Middleware", () => {
  it("should return 401 if no token is provided", async () => {
    const res = await request(app).get("/api/dashboard/stats");

    expect(res.status).toBe(401);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toMatch(/denied|no token/i);
  });

  it("should return 401 if token is invalid", async () => {
    const res = await request(app)
      .get("/api/dashboard/stats")
      .set("Authorization", "Bearer invalid_token_here");

    expect(res.status).toBe(401);
    expect(res.body.success).toBe(false);
  });

  it("should allow access with a valid token", async () => {
    const res = await request(app)
      .get("/api/dashboard/stats")
      .set("Authorization", `Bearer ${getToken()}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
  });
});

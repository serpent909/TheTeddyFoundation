const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");
const path = require("path");
require("dotenv").config();

const app = express();

if (process.env.NODE_ENV !== "production") {
    app.use(cors({ origin: [/^http:\/\/localhost:\d+$/, /^http:\/\/127\.0\.0\.1:\d+$/] }));
}

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

// DB connection
const pool = process.env.DATABASE_URL
    ? new Pool({ connectionString: process.env.DATABASE_URL, ssl: process.env.DATABASE_URL.includes("neon.tech") ? { rejectUnauthorized: false } : false })
    : new Pool({
        host: process.env.PGHOST || "127.0.0.1",
        port: Number(process.env.PGPORT || 5433),
        database: process.env.PGDATABASE || "servicesdb",
        user: process.env.PGUSER || "postgres",
        password: process.env.PGPASSWORD || "",
    });

// small helper to avoid try/catch soup
const asyncHandler = (fn) => (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);

// health check (good for render/railway)
app.get("/healthz", asyncHandler(async (req, res) => {
    const { rows } = await pool.query("SELECT 1 as ok");
    res.json({ ok: rows[0].ok === 1 });
}));

app.get("/api/categories", asyncHandler(async (req, res) => {
    const { rows } = await pool.query("SELECT name FROM categories ORDER BY name ASC");
    res.json(rows.map(r => r.name));
}));

// list all businesses (add pagination soon)
app.get("/api/businesses", asyncHandler(async (req, res) => {
    const { rows } = await pool.query(`
    SELECT
      b.id, b.name, b.description,
      b.phone, b.email, b.website,
      b.street, b.suburb, b.city, b.postcode, b.region,
      b.logo_url,
      b.latitude, b.longitude,
      COALESCE(
        json_agg(c.name) FILTER (WHERE c.name IS NOT NULL),
        '[]'
      ) AS categories
    FROM businesses b
    LEFT JOIN business_categories bc ON bc.business_id = b.id
    LEFT JOIN categories c          ON c.id = bc.category_id
    GROUP BY b.id
    ORDER BY b.name ASC
    LIMIT 200
  `);
    res.json(rows);
}));

app.get("/api/search", asyncHandler(async (req, res) => {
    const q = String(req.query.q || "").trim();
    const category = String(req.query.category || "").trim();

    const params = [];
    const where = [];

    // free-text q → ILIKE across a few columns
    if (q) {
        params.push(`%${q}%`);
        const p = `$${params.length}`;
        // stick to columns you actually have & have indexes for
        where.push(`(
      b.name ILIKE ${p} OR
      b.suburb ILIKE ${p} OR
      b.postcode ILIKE ${p} OR
      b.description ILIKE ${p} OR
      b.city ILIKE ${p}
    )`);
    }

    // optional category filter by name
    if (category) {
        params.push(category);
        where.push(`
      EXISTS (
        SELECT 1
        FROM business_categories bc
        JOIN categories c ON c.id = bc.category_id
        WHERE bc.business_id = b.id
          AND c.name = $${params.length}
      )
    `);
    }

    const clause = where.length ? `WHERE ${where.join(" AND ")}` : "";

    const sql = `
    SELECT
      b.id, b.name,
      b.suburb, b.city, b.postcode, b.region,
      b.logo_url,
      b.latitude, b.longitude
    FROM businesses b
    ${clause}
    ORDER BY b.name ASC
    LIMIT 200
  `;

    const { rows } = await pool.query(sql, params);
    res.json(rows);
}));

//Central error middleware
app.use((err, req, res, next) => {
    if (process.env.NODE_ENV !== "production") {
        console.error("Unhandled error:", err);
    } else {
        console.error("Unhandled error:", err.message, err.stack);
    }
    res.status(500).json({ error: "Internal server error" });
});


const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");

const app = express();
app.use(cors());
app.use(express.json());

// DB connection
const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "servicesdb",
  password: "14145",
  port: 5433,
});

//test route
app.get("/", (req, res) => res.send("Server + DB ready!"));

// Get services
app.get("/api/services", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM businesses");
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

const PORT = 4000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
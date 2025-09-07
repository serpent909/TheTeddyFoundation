CREATE TABLE IF NOT EXISTS businesses (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name         TEXT NOT NULL,
  description  TEXT,

  -- contact
  phone        TEXT,
  email        TEXT,
  website      TEXT,

  -- address (structured for search)
  street       TEXT,
  suburb       TEXT,
  city         TEXT,
  postcode     TEXT,     -- keep as TEXT to preserve leading zeros
  region       TEXT,

  -- geo (for map; nullable until you geocode)
  latitude     DOUBLE PRECISION,
  longitude    DOUBLE PRECISION,

  -- media
  logo_url     TEXT,
  image_url    TEXT,

  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT email_format_chk
    CHECK (email IS NULL OR email ~* '^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$'),
  CONSTRAINT website_format_chk
    CHECK (website IS NULL OR website ~* '^https?://')
);

-- Trigger to auto-update updated_at
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := NOW();
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS businesses_set_updated_at ON businesses;

CREATE TRIGGER businesses_set_updated_at
BEFORE UPDATE ON businesses
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

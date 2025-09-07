-- exact/equality lookups
CREATE INDEX IF NOT EXISTS biz_postcode_idx ON businesses (postcode);
CREATE INDEX IF NOT EXISTS biz_suburb_idx   ON businesses (suburb);

-- fast ILIKE / partial matches (requires pg_trgm)
CREATE INDEX IF NOT EXISTS biz_name_trgm_idx
  ON businesses USING GIN (name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS biz_suburb_trgm_idx
  ON businesses USING GIN (suburb gin_trgm_ops);

-- efficient category filtering
CREATE INDEX IF NOT EXISTS bc_category_idx
  ON business_categories (category_id, business_id);

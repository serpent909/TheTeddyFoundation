CREATE TABLE IF NOT EXISTS business_categories (
  business_id  BIGINT NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  category_id  INT    NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
  PRIMARY KEY (business_id, category_id)
);
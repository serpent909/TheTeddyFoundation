-- 0 = Sun … 6 = Sat
CREATE TABLE IF NOT EXISTS business_hours (
  business_id  BIGINT   NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  weekday      SMALLINT NOT NULL CHECK (weekday BETWEEN 0 AND 6),
  open_time    TIME     NOT NULL,
  close_time   TIME     NOT NULL,
  PRIMARY KEY (business_id, weekday, open_time)
);
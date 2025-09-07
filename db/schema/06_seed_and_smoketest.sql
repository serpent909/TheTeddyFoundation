-- Seed a couple categories (idempotent)
INSERT INTO categories(name) VALUES ('Healthcare') ON CONFLICT DO NOTHING;
INSERT INTO categories(name) VALUES ('Legal') ON CONFLICT DO NOTHING;

-- Add a business
WITH b AS (
  INSERT INTO businesses
    (name, suburb, postcode, phone, email, website, logo_url)
  VALUES
    ('City Clinic', 'Te Aro', '6011', '+64 4 123 4567',
     'info@cityclinic.nz', 'https://cityclinic.nz',
     'https://cdn.example.com/logos/city-clinic.png')
  RETURNING id
)
INSERT INTO business_categories(business_id, category_id)
SELECT b.id, c.id FROM b CROSS JOIN LATERAL (SELECT id FROM categories WHERE name='Healthcare') c;

-- Hours
INSERT INTO business_hours(business_id, weekday, open_time, close_time)
SELECT (SELECT id FROM businesses WHERE name='City Clinic'), 1, '08:00', '18:00'
WHERE NOT EXISTS (
  SELECT 1 FROM business_hours
  WHERE business_id = (SELECT id FROM businesses WHERE name='City Clinic')
    AND weekday=1 AND open_time='08:00'
);

-- Try a search
SELECT id, name, suburb, postcode
FROM businesses
WHERE name ILIKE '%cli%' OR suburb ILIKE '%aro%';
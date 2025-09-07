-- Categories
INSERT INTO categories (name) VALUES
  ('Health'),
  ('Education'),
  ('Food'),
  ('Legal'),
  ('Community'),
  ('Sports'),
  ('Housing'),
  ('Finance'),
  ('Transport'),
  ('Technology')
ON CONFLICT (name) DO NOTHING;

-- Businesses
INSERT INTO businesses
  (name, description, phone, email, website,
   street, suburb, city, postcode, region,
   logo_url, latitude, longitude)
VALUES
  ('Auckland Health Clinic', 'General medical practice offering GP services', '09-555-1234', 'info@aklhealth.co.nz', 'http://aklhealth.co.nz', '123 Queen St', 'CBD', 'Auckland', '1010', 'Auckland', NULL, -36.8485, 174.7633),
  ('City Legal Aid', 'Free legal advice for the community', '09-555-2233', 'support@citylegal.org.nz', 'http://citylegal.org.nz', '45 High St', 'CBD', 'Auckland', '1010', 'Auckland', NULL, -36.8478, 174.7661),
  ('Westside Food Bank', 'Community food support for families in need', '09-555-3344', 'contact@westfoodbank.nz', 'http://westfoodbank.nz', '89 Lincoln Rd', 'Henderson', 'Auckland', '0610', 'Auckland', NULL, -36.8836, 174.6270),
  ('East Auckland Sports Club', 'Sports and recreation facilities for all ages', '09-555-4455', 'hello@eastsports.org', 'http://eastsports.org', '12 Pakuranga Rd', 'Pakuranga', 'Auckland', '2010', 'Auckland', NULL, -36.9052, 174.8616),
  ('North Shore Education Hub', 'Tutoring and after-school programs', '09-555-5566', 'admin@nshoreedu.nz', 'http://nshoreedu.nz', '200 Lake Rd', 'Takapuna', 'Auckland', '0622', 'Auckland', NULL, -36.7917, 174.7759),
  ('Community Housing Trust', 'Affordable housing for low-income families', '09-555-6677', 'housing@cht.nz', 'http://cht.nz', '15 Dominion Rd', 'Mt Eden', 'Auckland', '1024', 'Auckland', NULL, -36.8790, 174.7640),
  ('South Auckland Transport Service', 'Shuttle and mobility services', '09-555-7788', 'book@satran.co.nz', 'http://satran.co.nz', '60 Great South Rd', 'Papatoetoe', 'Auckland', '2104', 'Auckland', NULL, -36.9750, 174.8440),
  ('Tech Access NZ', 'Free computer access and training programs', '09-555-8899', 'team@techaccess.nz', 'http://techaccess.nz', '8 Karangahape Rd', 'Newton', 'Auckland', '1010', 'Auckland', NULL, -36.8580, 174.7595),
  ('Financial Literacy Project', 'Workshops on budgeting and debt management', '09-555-9900', 'info@finlit.org.nz', 'http://finlit.org.nz', '33 Symonds St', 'CBD', 'Auckland', '1010', 'Auckland', NULL, -36.8515, 174.7692),
  ('Central Community Centre', 'Meeting rooms, classes, and community events', '09-555-1112', 'contact@centralcc.nz', 'http://centralcc.nz', '75 Albert St', 'CBD', 'Auckland', '1010', 'Auckland', NULL, -36.8489, 174.7636),
  ('Healthy Kids Dental', 'Pediatric dental services', '09-555-1212', 'kids@healthydental.nz', 'http://healthydental.nz', '50 Manukau Rd', 'Epsom', 'Auckland', '1023', 'Auckland', NULL, -36.8848, 174.7764),
  ('Southside Legal Aid', 'Legal help for low-income residents', '09-555-1313', 'support@southlegal.nz', 'http://southlegal.nz', '10 Cavendish Dr', 'Manukau', 'Auckland', '2104', 'Auckland', NULL, -37.0020, 174.8790),
  ('Good Food Co-op', 'Affordable groceries for members', '09-555-1414', 'hello@goodfood.nz', 'http://goodfood.nz', '240 Sandringham Rd', 'Sandringham', 'Auckland', '1025', 'Auckland', NULL, -36.8824, 174.7351),
  ('Youth Sports Trust', 'Organized sports leagues for youth', '09-555-1515', 'info@youthsports.org.nz', 'http://youthsports.org.nz', '18 Te Irirangi Dr', 'Botany', 'Auckland', '2013', 'Auckland', NULL, -36.9502, 174.9001),
  ('City Tutoring Centre', 'Tutoring services in maths and science', '09-555-1616', 'contact@citytutors.nz', 'http://citytutors.nz', '99 Khyber Pass Rd', 'Newmarket', 'Auckland', '1023', 'Auckland', NULL, -36.8684, 174.7756),
  ('West Auckland Housing Support', 'Emergency housing referrals and support', '09-555-1717', 'help@westhousing.nz', 'http://westhousing.nz', '22 Railside Ave', 'Henderson', 'Auckland', '0612', 'Auckland', NULL, -36.8855, 174.6299),
  ('Kiwi Transport Volunteers', 'Free rides for elderly and disabled', '09-555-1818', 'rides@ktv.nz', 'http://ktv.nz', '77 Dominion Rd', 'Mt Roskill', 'Auckland', '1041', 'Auckland', NULL, -36.9084, 174.7360),
  ('Digital Skills Hub', 'Coding and IT workshops for job seekers', '09-555-1919', 'info@digiskills.nz', 'http://digiskills.nz', '120 Broadway', 'Newmarket', 'Auckland', '1023', 'Auckland', NULL, -36.8744, 174.7785),
  ('Budget Advice Centre', 'Free budgeting and debt advice', '09-555-2020', 'support@budgetadvice.nz', 'http://budgetadvice.nz', '5 Queen St', 'CBD', 'Auckland', '1010', 'Auckland', NULL, -36.8484, 174.7633),
  ('Onehunga Community Kitchen', 'Community meals and cooking classes', '09-555-2121', 'info@onehungakitchen.nz', 'http://onehungakitchen.nz', '15 Onehunga Mall', 'Onehunga', 'Auckland', '1061', 'Auckland', NULL, -36.9243, 174.7844);

-- Business ↔ Categories (just a few examples)
INSERT INTO business_categories (business_id, category_id)
SELECT b.id, c.id FROM businesses b
JOIN categories c ON c.name IN ('Health')
WHERE b.name IN ('Auckland Health Clinic', 'Healthy Kids Dental');

INSERT INTO business_categories (business_id, category_id)
SELECT b.id, c.id FROM businesses b
JOIN categories c ON c.name IN ('Legal')
WHERE b.name IN ('City Legal Aid', 'Southside Legal Aid');

INSERT INTO business_categories (business_id, category_id)
SELECT b.id, c.id FROM businesses b
JOIN categories c ON c.name IN ('Food')
WHERE b.name IN ('Westside Food Bank', 'Good Food Co-op', 'Onehunga Community Kitchen');

INSERT INTO business_categories (business_id, category_id)
SELECT b.id, c.id FROM businesses b
JOIN categories c ON c.name IN ('Education')
WHERE b.name IN ('North Shore Education Hub', 'City Tutoring Centre', 'Digital Skills Hub');

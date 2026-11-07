ALTER TABLE products ADD COLUMN retailer_name TEXT;
ALTER TABLE products ADD COLUMN price_checked_at TEXT;
ALTER TABLE products ADD COLUMN product_source_url TEXT;
ALTER TABLE products ADD COLUMN editorial_note TEXT;

-- Imported starter entries are drafts until real retailer links and product details are verified.
UPDATE products SET published=0, featured=0 WHERE id LIKE 'builtin-%' AND (affiliate_url IS NULL OR affiliate_url='');
UPDATE categories SET image='/assets/category-1.jpg' WHERE slug='fashion' AND (image IS NULL OR image='');
UPDATE categories SET image='/assets/category-2.jpg' WHERE slug='bags-travel' AND (image IS NULL OR image='');
UPDATE categories SET image='/assets/category-3.jpg' WHERE slug='beauty-self-care' AND (image IS NULL OR image='');
UPDATE categories SET image='/assets/category-4.jpg' WHERE slug='accessories' AND (image IS NULL OR image='');
UPDATE categories SET image='/assets/category-5.jpg' WHERE slug='watches-jewellery' AND (image IS NULL OR image='');
UPDATE categories SET image='/assets/category-6.jpg' WHERE slug='shoes' AND (image IS NULL OR image='');
UPDATE categories SET image='/assets/category-7.jpg' WHERE slug='perfumes' AND (image IS NULL OR image='');
UPDATE categories SET image='/assets/category-8.jpg' WHERE slug='phone-accessories' AND (image IS NULL OR image='');

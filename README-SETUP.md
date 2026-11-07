# Trendy Lifestyle Hub — Cloudflare deployment package

## What this package is
This is a multi-page Cloudflare Workers + Static Assets + D1 starter implementation built from the uploaded Trendy Lifestyle Hub `index.html`. It preserves the supplied hero, logo and eight existing product images, and adds dedicated category URLs, legal/content pages, API endpoints and a server-verified admin login.

## Important status
This is a deployment foundation, not a claim that your live Cloudflare website has already been deployed or connected. You must create your Cloudflare D1 database, set its ID, deploy the Worker, create the first admin, and test the deployed endpoints. Workers AI is optional and requires an account binding/availability. This expanded build includes admin APIs and screens for products, categories, editable pages, blog posts, R2 image uploads, AI writing, AdSense placement settings, and basic first-party analytics. Several integrations still require Cloudflare bindings and configuration; see the limitations section before treating it as production-ready.

## Files
- `public/` — public multi-page site, category pages, assets and `/admin/`
- `src/worker.js` — API, authentication, session and static asset Worker
- `migrations/0001_init.sql` — D1 schema
- `migrations/0002_seed.sql` — categories and imported product drafts (not published until verified)
- `migrations/0003_extended_features.sql` — analytics, ad settings and media metadata
- `migrations/0004_affiliate_product_fields.sql` — retailer, price-check date and editorial-note fields
- `wrangler.toml` — Cloudflare configuration
- `scripts/create-admin.mjs` — generates a PBKDF2 admin hash
- `TEST-REPORT.md` — review, feature status and test results
- `AFFILIATE-LAUNCH-CHECKLIST.md` — owner checklist before going live

## Safe deployment plan
1. Keep your existing Cloudflare website and deployment unchanged.
2. Deploy this package as a separate Worker/test hostname first. Do not attach your main domain yet.
3. Configure D1, create the admin, and verify login, product drafts, contact form and affiliate redirect on the test hostname.
4. Create and bind R2 only when ready to test image uploads. Enable Workers AI only after confirming account availability.
5. Attach the main domain only after the test version passes your checks and you have a backup of the current site.

## Deploy from a computer (recommended)
1. Install Node.js 20+ and Wrangler: `npm install -g wrangler`.
2. Sign in: `npx wrangler login`.
3. Create D1: `npx wrangler d1 create trendy-lifestyle-hub`.
4. Copy the returned database ID into `wrangler.toml`, replacing `REPLACE-WITH-YOUR-D1-DATABASE-ID`.
5. Apply schema and seed: `npx wrangler d1 migrations apply trendy-lifestyle-hub --remote`.
6. Create an admin hash: `node scripts/create-admin.mjs admin@yourdomain.com 'Use-a-unique-password-14chars'`. Run the printed SQL command, replacing the example email and hash as appropriate. Never publish the password or hash.
7. Deploy: `npx wrangler deploy`.
8. Open the test deployment URL, test `/api/health`, then visit `/admin/`. The imported eight products should remain drafts until you add verified affiliate links.
9. Keep using the separate `workers.dev` test hostname while you test. Only after it passes should you add the real custom domain under your Worker Settings > Domains & Routes.
10. The Worker fills canonical and Open Graph placeholder domains using the active request origin, and generates robots.txt and sitemap.xml for the current hostname. Confirm both on the test hostname before connecting your custom domain.

## Mobile-friendly workflow
Cloudflare dashboard can be opened on mobile, but first-time D1 creation, secrets, and code deployment are much easier from a laptop/desktop. After deployment, ordinary product edits can be made through the admin product editor without redeploying.

## Security notes
- Admin password hashes are generated using PBKDF2-SHA256 with 210,000 iterations and a random salt.
- Sessions are random, stored as SHA-256 hashes in D1, expire after eight hours, and use HttpOnly, Secure and SameSite=Strict cookies.
- Never commit `.dev.vars`, API tokens, raw passwords or secret keys.
- Add Cloudflare WAF/rate limiting rules for production and configure backups for D1.
- Use a strong unique admin password and HTTPS only.

## Product and affiliate data
The eight imported starter products and images are retained as drafts. They are not publicly published until you add a real HTTPS affiliate link and verify the product details. Published products must have a verified affiliate link. Do not enter a price unless you have checked it and supplied its check date. The site does not invent affiliate links, prices or ratings.

## AI assistant
The admin AI Writer uses `/api/admin/ai/generate`. Enable the Workers AI binding in `wrangler.toml` only if Workers AI is available to your account. Generated text must be reviewed for accuracy before publishing.

## R2 image uploads
Create an R2 bucket in Cloudflare, then uncomment the `[[r2_buckets]]` block in `wrangler.toml` and set its real bucket name. The binding must be named `MEDIA`. Uploads accept JPG, PNG, WEBP and GIF up to 5 MB.

## AdSense settings
The Admin > AdSense screen stores publisher IDs, slot IDs and enablement for the two implemented placements (homepage mid-page and footer). Add real values only after your Google AdSense account is approved. Ads load only after the visitor chooses to allow ads. This simple preference is not a Google-certified CMP; configure Google's certified CMP for EEA/UK/Switzerland before serving ads there. Approval, policy compliance and earnings are controlled by Google.

## CMS and analytics
Admin screens manage products (including drafts), categories, pages and blog articles; they also show contact messages and newsletter subscriber records. Published pages are available at `/page/?slug=your-page-slug`; published blog posts at `/article/?slug=your-article-slug`. Basic first-party page views, product views, search events and affiliate click totals are stored in D1 only after a visitor accepts analytics. Analytics is basic, not a replacement for Google Analytics, conversion attribution or legal review.

## Newsletter and contact
The D1 APIs save subscribers and contact messages. Admin can view both lists. Automated newsletter sending and contact email notifications are not implemented yet; these require an email provider integration plus additional Worker code. The unsubscribe endpoint supports confirmation by token, but no unsubscribe emails are sent by this package.

## Current limitations
See `TEST-REPORT.md`. This package does not claim Google AdSense approval, revenue, production security certification, advanced analytics, email campaign delivery, or legal/privacy compliance. The included consent notice is a basic preference UI, not a certified CMP. Public pages and article detail use simple text rendering; a rich text editor, media library browser, advanced SEO preview, newsletter sending, contact email notifications and full campaign analytics are not included. Product detail pages include affiliate disclosures, structured product data without invented prices/ratings, and a Pinterest Save link.

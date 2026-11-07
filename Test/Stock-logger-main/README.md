# StockLogger — Warehouse Management

Original Vite / TypeScript warehouse project, extended with inventory product browsing, POS sales history, delivery fulfillment and a delivery log. The original light, monochrome typography and card styling are preserved.

## Start in VS Code (temporary demo login)

1. Extract this ZIP and open the `Stock-logger-main` folder in VS Code.
2. Open **Terminal → New Terminal** and run:

   ```bash
   npm install
   npm run dev
   ```
3. Open the Vite localhost link (usually `http://localhost:5173/`). Select **Admin** and enter:

   - **Username:** `demo-admin`
   - **Password:** `DemoAdmin2026!`

`.env.development` enables temporary local preview (`VITE_DEMO_MODE=true`). Demo mode works *without Supabase*; its sample inventory, stock movements, sales, returns, deliveries, suppliers, categories and audit logs are stored in isolated `preview-wh-*` keys in your current browser's `localStorage`. Test with the **same browser/profile** to see saved changes. This account is not a real Supabase user. Production builds and non-localhost hosts cannot use this demo login because it is gated behind Vite's development-only flag and a localhost-only check.

## What changed

- **Inventory → Products:** two tabs, **Log a movement** (the original form) and **All products** (a searchable POS-style catalog showing SKU, name, stock status, available quantity, price and rack slot).
- **Sales → POS:** third **Recent sales** tab (next to Returns), searchable, with order totals, quantities, and fulfillment statuses. Previously, Recent Sales was embedded below the checkout panel and showed only five entries.
- **POS → Current order:** select **Walk-in / pickup** or **Delivery / bulk supply**. Delivery orders require both buyer/account and complete delivery address. Optional phone, target date, and notes are collected. Successful non-walk-in orders are automatically added to the Delivery Log.
- **Deliveries:** dedicated navigation page with search, status filter, summary counters, and editable delivery records. Delivery statuses: Pending, Scheduled, Out for delivery, Delivered and Cancelled. The Add delivery action also supports supply orders not originating in POS.

## Connected Supabase / production mode

1. Apply `supabase/migrations/20261107_deliveries.sql` in your existing Supabase project's SQL editor **before** recording any delivery orders. It expects your existing `public.sales(id uuid)` and `public.profiles(id uuid, active boolean)` tables. This migration adds a `deliveries` table with row-level security for active authenticated users.
2. Put real Supabase settings in `.env.local`:

   ```env
   VITE_SUPABASE_URL=https://YOUR-PROJECT.supabase.co
   VITE_SUPABASE_PUBLISHABLE_KEY=YOUR-PUBLISHABLE-ANON-KEY
   ```
3. **Remove the temporary demo mode:** delete `.env.development` or set `VITE_DEMO_MODE=false` there and restart Vite. Log in using a valid existing Supabase account. Never deploy with development server settings, and never put Supabase service-role keys in Vite environment variables.
4. Deploy using `npm run build`; the development-only login code is disabled in production.

**Note:** POS checkout uses your existing `complete_pos_sale` RPC to save the sale, then creates the linked delivery record with a separate database request. If delivery recording fails after a successful sale, the UI warns you **not to charge again** and stores the failed delivery details under browser storage key `wh-pending-delivery-recovery`. Review those details and create the missing delivery manually in the Delivery Log. For fully atomic checkout + delivery in production, extend the existing PostgreSQL RPC to insert a delivery in the same database transaction.

The original product, stock, sales and user Supabase tables and RPC functions must already exist. No database credentials or actual account records are included in the ZIP.

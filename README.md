# Wasatch Haul Co. website

Saturday-only junk removal in Davis County, Utah.

- **GitHub** stores the code.
- **Vercel** puts it on the internet and redeploys every time you push to GitHub.
- **Supabase** stores the quote requests (and photos) customers send from the form.

```
wasatch-haul-co/
├── index.html          the whole website
├── supabase/schema.sql database setup (run once in Supabase)
└── README.md           this file
```

## 1. GitHub: put the files in your repo

You already made a repo. Easiest way, no command line:

1. Open your repo on github.com → **Add file → Upload files**.
2. Drag in `index.html`, `README.md` and the `supabase` folder.
3. Write a message like "First version of site" → **Commit changes**.

Command-line way (if you have Git installed), from inside this folder:

```bash
git init
git add .
git commit -m "First version of site"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPO.git
git push -u origin main
```

## 2. Supabase: create the database

1. supabase.com → **New project**. Name it `wasatch-haul-co`, pick region **West US**, save the database password somewhere safe.
2. Left sidebar → **SQL Editor → New query**. Paste all of `supabase/schema.sql` → **Run**. You should see "Success. No rows returned."
3. Left sidebar → **Project Settings → API**. Copy two things:
   - **Project URL** (looks like `https://abcd1234.supabase.co`)
   - **anon public** key (long text starting `eyJ...`, or `sb_publishable_...` on newer projects)
4. Open `index.html`, search for `YOUR-PROJECT-ID`, and paste them in:

```js
var SUPABASE_URL = 'https://abcd1234.supabase.co';
var SUPABASE_ANON_KEY = 'eyJ...';
```

The anon key is meant to be public — the security comes from the rules in `schema.sql`, which let visitors *add* a quote but never *read* anyone's. **Never** paste the `service_role` / secret key into the website.

5. Commit that change to GitHub (edit the file on github.com with the pencil icon, or `git commit` + `git push`).

## 3. Vercel: put it online

1. vercel.com → **Sign up with GitHub**.
2. **Add New → Project** → pick your repo → **Import**.
3. Framework preset: **Other**. Leave build settings empty → **Deploy**.
4. In about 30 seconds you get a live address like `wasatch-haul-co.vercel.app`.

From now on, every change you push to GitHub goes live automatically.

## 4. Test it

1. Open your Vercel address, fill out the quote form with your own info, attach a photo → **Request my quote**.
2. You should see "Got it. We'll text you a price…".
3. In Supabase → **Table Editor → quotes**: your request is there. Photos are under **Storage → quote-photos**.

If you see the "copy this and text it" box instead, the form couldn't reach Supabase. Open the browser console (F12 → Console) for the error; usually it's a typo in the URL or key.

## Next steps (later)

- **Get a text/email for each new quote:** Supabase → Database → Webhooks, or an Edge Function that sends email. Until then, check the quotes table on Friday mornings.
- **Your own domain:** buy `wasatchhaul.com` (or similar) → Vercel project → Settings → Domains.
- **Before going public:** real phone number (replace `(801) 555-0142`), and remove "Licensed & insured" until you are.

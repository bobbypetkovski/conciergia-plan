# conciergia-plan

Outbound engine plan — Conciergia × Bobby.

A single-page collaborative plan for the Conciergia engagement. One HTML file,
no build step, no dependencies to install.

Two people sign in, edit the same document, tick tasks off, tag each other,
and see each other's changes live.

---

## Deploy

### 1. Git

```bash
cd conciergia-plan
git init
git add .
git commit -m "Outbound engine plan"
git branch -M main
git remote add origin git@github.com:bobbypetkovski/conciergia-plan.git
git push -u origin main
```

If the repo already has a commit (a README created on GitHub), pull it in
first so the push isn't rejected:

```bash
git pull --rebase origin main
git push -u origin main
```

Repo: https://github.com/bobbypetkovski/conciergia-plan

### 2. Vercel

Import the repo at [vercel.com/new](https://vercel.com/new).

- Framework preset: **Other**
- Build command: leave empty
- Output directory: leave empty
- Root directory: `./`

It's a static file, so there's nothing to build. Deploy takes a few seconds.

Every `git push` to `main` redeploys automatically.

### 3. Supabase

**a. Create the project** at [supabase.com](https://supabase.com). Any region
close to Europe.

**b. Create the two users.** Authentication → Users → Add user → *Create new
user*. Do this twice, once for each of you, and set a password for each.
Leave "auto confirm" on so no email confirmation is needed.

**c. Run the schema.** SQL Editor → New query → paste `supabase/schema.sql`
→ Run. Run it *after* the users exist.

**d. Get the keys.** Project Settings → API. You need:

- Project URL
- `anon` `public` key

### 4. Wire it up

Open `index.html` and fill in the block near the top of the `<script>`:

```js
const SUPABASE_URL  = 'https://xxxxx.supabase.co';
const SUPABASE_KEY  = 'eyJhbGci...';
const DOC_ID        = 'conciergia-plan';

const ACCOUNTS = {
  'm-bobby': 'bobby@yourdomain.com',
  'm-anna':  'anna@yourdomain.com',
};
```

The `ACCOUNTS` addresses must match the Supabase users exactly — that mapping
is what decides whose tasks are whose.

Commit and push. Vercel redeploys, and the login screen appears.

---

## How it behaves

**Before Supabase is configured** the page runs in local mode: no login, you
pick who you are, and everything saves to your own browser. Useful for editing
content before you deploy.

**After** it requires a session, loads the shared document, and syncs on a
600 ms debounce with realtime subscriptions both ways.

The footer shows which mode it's in — *Local only* or *Shared — live*.

---

## Notes

**The anon key is public.** It ships in the page source, which is fine — that's
what it's for. Row-level security is what protects the data, which is why
step 3c matters. Without RLS enabled, anyone with the URL can read the table
directly and the login screen is decoration.

**Both accounts have equal rights.** Either of you can edit anything. Per-person
write restrictions would need policies keyed to user id and a different table
shape.

**Backups.** *Export JSON* in the footer downloads the whole document. Worth
doing before any big restructure — there's no undo.

**Resetting.** *Reset to default* wipes back to the seeded plan. It does exactly
what it says.

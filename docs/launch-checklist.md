# CricHeros — Launch Checklist

Last audited: 2026-09-09. Backend is fully migrated to Supabase (Auth, Postgres, RLS, Realtime, Storage) and verified working end-to-end. What's below is what's left before this app can go live on the Play Store.

Each item has a priority, a status, and an owner slot — claim one by putting your name in the Owner column and opening a PR against it.

## 🔴 Blockers — cannot submit to Play Store without these

| # | Item | Status | Owner | Notes |
|---|------|--------|-------|-------|
| 1b | OAuth consent screen still in "Testing" status | **Not started, not urgent yet** | | Google caps apps in Testing status at 100 users for sensitive scopes (the app only requests `email`, which isn't sensitive, so this is a soft limit for now). Fine for internal testing; needs either explicit test users added or full Google verification before onboarding real users at any scale. |
| 3 | Final app icon | **Placeholder** | | `khelo/android/app/src/main/res/mipmap-*` — there's literally a file named `ic_app_logo_PLACEHOLDER_NOTICE.md` saying "temporary placeholder, replace before release." |
| 4 | Privacy policy hosting + in-app links | **Wrong URLs** | | A real privacy policy doc exists at `docs/privacy-policy.md`, but it isn't hosted anywhere public. `khelo/lib/ui/flow/profile/profile_screen.dart:35-39` still links to `khelo.canopas.com/privacy-policy`, `khelo.canopas.com/terms-and-condition`, and the old Khelo Play Store/App Store listings. Play Store **requires** a working privacy policy URL in the listing to submit at all. Needs: host the doc (GitHub Pages is the easy option), update those 4 links. |
| 5 | `google-services.json` committed to git | **Tracked** | | Client-safe to embed in the built app, but shouldn't sit in the repo — the store-prep commit intended to gitignore it but the rule is commented out in `.gitignore`. Low urgency but should stop tracking it going forward. |

## ✅ Unblocked (2026-09-09) — sign-up no longer needs an SMS provider

Phone OTP was the #1 blocker (Twilio trial mode can't SMS arbitrary numbers, and India's DLT registration adds friction on top of that). Decision: **ship with Google Sign-In + email/password for now**, phone OTP shelved. Real SMS is no longer launch-blocking — the "SMS Provider Choice" section below is kept for whenever phone sign-in comes back, not urgent anymore.

- `AuthService.signInWithGoogle` / `signUpWithEmail` / `signInWithEmail` added, all sharing the same post-auth bookkeeping `verifyOTP` already used.
- New sign-in/sign-up screens replace phone-login as the intro screen's destination. Phone-login code is untouched and still reachable at `/phone-login` — quick to bring back later.
- **Google Sign-In confirmed working end-to-end** on a real device: Android OAuth clients (debug + release SHA-1) created, Supabase Google provider updated, "Skip nonce checks" enabled, real sign-in tested and verified against the database (auth.users row + public.users profile both created correctly, email populated).
- **Android release signing done**: real upload keystore generated, `build.gradle` wired to use it (`key.properties` → env vars → debug fallback), verified with an actual signed release build (`apksigner` confirms the new certificate, not debug).

## 🟡 Should fix before launch, not a hard blocker

| # | Item | Status | Owner | Notes |
|---|------|--------|-------|-------|
| 6 | iOS rebrand | **Not started** | | Bundle ID is still `com.canopas.khelo` (`khelo/ios/Runner.xcodeproj/project.pbxproj`), no Firebase config for iOS. Fine to defer entirely if launching Android-first. |
| 7 | Zero automated tests | **None exist** | | No `test/` directories with real tests anywhere in `khelo/`, `data/`, or `style/`. Acceptable for a small-team v1 launch, but every regression is caught by hand until this changes. |
| 8 | Dead `cloud_firestore` import cleanup | **Cosmetic** | | `score_board_view_model.dart` and `match_detail_tab_view_model.dart` import `cloud_firestore` only for the `DocumentChangeType` enum (used to pattern-match `BallScoreChange.type`) — no actual Firestore calls remain, live scoring is fully on Supabase. Not a functional issue, just an unnecessary dependency; worth a small follow-up PR to replace that enum with a local one and eventually drop `cloud_firestore`/`firebase_auth` from `pubspec.yaml` once nothing else needs them. |
| 9 | `firestore.rules` cleanup | **Stale** | | Still has `allow read, write: if true` for matches/innings/ball_scores/tournaments/leaderboard collections from before those moved to Supabase — nothing in the app reads/writes them anymore, so it's dead configuration, not an active security hole. Safe to delete the whole file once #8 confirms nothing touches Firestore for app data anymore.

## ✅ Fixed already (2026-09-08)

- **Contact Support was completely broken** — it wrote to a Firestore collection that `firestore.rules` explicitly denies (the rules comment even claimed it was "no longer read/written via Firestore," which was false). Migrated `support_service.dart` to the Supabase `contact_support` table (schema + RLS already existed from the initial migration, just had no Dart service pointed at it).
- **Version file drift** — `khelo/VERSION` said `1.0.1`, `pubspec.yaml` said `1.0.0+1`. Nothing in the build actually reads `VERSION`; synced it to match `pubspec.yaml`.
- Full backend migration off Firebase onto Supabase (Auth/Postgres/RLS/Realtime/Storage), tournaments + leaderboard given real implementations, two live-scoring RPC bugs found and fixed via API testing, realtime wired up end-to-end and verified with a live websocket test. See closed issues #2–#6 on the repo for details.

---

## SMS/OTP Provider Choice

The app is India-focused (all testing/seed data uses +91 numbers). This matters because **Indian telecom regulation (TRAI DLT) requires any commercial/transactional SMS sender to be registered on the DLT platform, regardless of which provider you use** — an unregistered sender's messages to Indian numbers can get silently dropped even with a fully funded, non-trial account. This is the real reason India-focused apps tend to pick India-specific providers over Twilio.

| Provider | Approx. cost (India) | Supabase integration | DLT registration | Verdict |
|---|---|---|---|---|
| **Twilio (fund existing account)** | ~$0.008–0.02+/SMS | Already 90% wired up (dashboard dropdown, Messaging Service already created) | You register separately — extra paperwork/delay | Least engineering work since it's already configured, but pricier for India and you own the DLT compliance step yourself |
| **MSG91** | ~₹0.10–0.15/SMS (cheapest) | Not in Supabase's built-in dropdown — needs a custom "Send SMS Hook" (a small Edge Function that calls MSG91's API) | MSG91 provides pre-approved OTP templates/sender IDs, so **you skip DLT registration** for OTP-only use | Cheapest + least compliance hassle, but needs someone to write the hook |
| **TextLocal** | Comparable to MSG91, India-focused | **Is** in Supabase's built-in dropdown (no custom hook needed) | Provider-assisted DLT registration, similar to MSG91 | Best balance — cheap, India-appropriate, and zero extra integration code since Supabase supports it natively |
| **Vonage / MessageBird** | Similar to Twilio | Built into Supabase dropdown | You register separately | No real advantage over Twilio for this use case |
| **Firebase Phone Auth (reintroduce just for OTP)** | Free up to a generous quota | Would need a custom bridge (send OTP via Firebase, verify, then mint a Supabase session) | Google handles it | Cheapest of all, but reintroduces Firebase after the whole point of this migration was removing it — only worth it if cost is the overriding concern |

**Recommendation**: try **TextLocal** first — it's the only option here that's both India-cheap and zero extra engineering (native Supabase dropdown, same setup flow as Twilio). If pricing or deliverability disappoints, MSG91 is the cheaper fallback at the cost of someone building the custom SMS hook. Verify current pricing directly with each provider before committing — rates shift.

**Immediate unblock for demo/testing purposes** (already working, no cost): Supabase's **Test OTP** feature — register fixed phone+code pairs in Dashboard → Authentication → Providers → Phone → Test OTPs. Not usable for real end users, but fine for internal demos while a real provider is set up.

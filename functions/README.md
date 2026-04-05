# Firebase Cloud Functions (billing + moderation)

Callable and HTTP endpoints for **Stripe** subscriptions and **AI content moderation** (OpenAI Moderation API by default, adapter-ready for other providers). **No Google Secret Manager is required** — keys are read from **runtime environment variables** (set in Google Cloud Console for each function, or `.env` for the emulator).

**Source layout:** `src/index.ts` (Stripe webhooks + billing callables), `src/admin.ts` (admin + moderation ops callables), `src/moderation/` (types, OpenAI adapter, incidents, human review queue, `moderateContent`, `admin_review`), `src/external_letters.ts` (`claimExternalLetters`, `onLetterCreatedSendExternalInviteEmail`).

### External letters (no-account recipient)

| Variable | Required | Purpose |
|----------|----------|---------|
| `SENDGRID_API_KEY` | For invite email | [Twilio SendGrid](https://www.twilio.com/en-us/products/email-api/pricing) API key; if unset, the Firestore trigger logs a warning and skips send (claim still works). |
| `SENDGRID_FROM_EMAIL` | No | Verified sender address (default `noreply@openwhen.app`). |
| `SENDGRID_FROM_NAME` | No | Display name (default `OpenWhen`). |

Set the same variables on **`claimExternalLetters`** and **`onLetterCreatedSendExternalInviteEmail`** (or use project-wide env in Cloud Functions). Domain authentication (SPF/DKIM) should be configured in SendGrid for your from-domain.

```bash
cd functions
npm install
npm run build
```

## Environment variables (Cloud Functions / Cloud Run)

Set these on each deployed function (or use a shared `.env` with the emulator only):

| Variable | Required for Stripe | Purpose |
|----------|---------------------|---------|
| `STRIPE_SECRET_KEY` | Checkout, portal, webhooks | `sk_test_...` / `sk_live_...` |
| `STRIPE_WEBHOOK_SECRET` | Webhook verification only | `whsec_...` |
| `STRIPE_PRICE_PLUS` | Checkout | Price id for **Brisa** (`plus`) |
| `STRIPE_PRICE_PRO` | Checkout | Price id for **Horizonte** (`pro`) |
| `ADMIN_BOOTSTRAP_SECRET` | No (admin bootstrap) | Long random string; used **once** with callable `bootstrapAdminClaim` to set `admin: true` on the **signed-in** user’s custom claims |
| `OPENAI_API_KEY` | When `MODERATION_PROVIDER=openai` (default) | `sk-...` — used by **`moderateContent`** (Moderation API). If missing, the function applies **fallback** (see Moderation section) and writes an aggregated row to **`moderationIncidents`**. |
| `MODERATION_PROVIDER` | No | Default `openai` if unset. Other values are reserved for future adapters; until implemented, incidents are recorded and fallback applies. |

### Moderation / superadmin

- **`bootstrapAdminClaim`** (callable): body `{ "secret": "<same as ADMIN_BOOTSTRAP_SECRET>" }`. Caller must be authenticated. Sets Firebase Auth custom claim `admin: true` on that user. After calling, the client must refresh the ID token (`getIdToken(true)`) before `adminListPendingReports` and related callables succeed.
- **`moderateContent`** (callable, signed-in users): body `{ "text": "...", "contentType": "comment"|"letter"|"capsule"?, "locale"?: "...", "letterId"?: "..." }`. Reads **`systemConfig/app`**: `aiModerationEnabled`, `aiModerationFailClosed`, **`humanModerationQueueEnabled`**, **`moderationReviewScoreThreshold`** (optional number `> 0`; if omitted, only OpenAI `flagged` counts as an “indication”). When `aiModerationEnabled` is false, returns `{ allowed: true, source: "skipped" }` without calling OpenAI. When OpenAI fails or the key is missing, records **`moderationIncidents`** (deduped per kind + UTC hour) and either returns **`moderation_unavailable`** (**strict**, default when the field is omitted) or allows posting (**soft fallback**) when **`aiModerationFailClosed`** is explicitly **`false`** in Firestore. When **`humanModerationQueueEnabled`** is true and the model flags an indication on a **comment**, the function creates **`moderationReviews`** (pending) and a **`users/{uid}/notifications`** row, and returns `{ "allowed": false, "reason": "pending_moderation_review", "reviewId": "..." }` — **`letterId` is required** in that case. Otherwise, binary allow/block uses OpenAI `flagged` only.
- **`adminGetModerationInfo`**: returns `{ providerId, credentialsConfigured }` from runtime env (no secrets). Lets admins see which moderation backend is active (e.g. `openai`) and whether `OPENAI_API_KEY` is set on the Functions runtime.
- **`adminListPendingReports`**, **`adminResolveReport`**, **`adminListRecentFeedback`**, **`adminListModerationIncidents`**: require `admin: true` on the ID token. Implementação no app: **Configurações → Moderação (admin)** (visível só com claim). **Incidentes** list aggregated ops alerts (not user-submitted reports).
- **`adminListPendingModerationReviews`**: `{ "limit"?: number, "cursorId"?: string }` → `{ items, nextCursor }`. Pending human review queue.
- **`adminResolveModerationReview`**: `{ "reviewId", "decision": "approved"|"rejected", "userFeedback"?: string }`. **Rejected** requires non-empty **`userFeedback`**. **Approved** creates the **`comments`** doc, increments **`letters.commentCount`**, updates the review, and writes an inbox notification — all in one transaction. Idempotent if the review is no longer `pending`.

**Firestore:** `moderationIncidents` and **`moderationReviews`** are server-only (client rules deny read/write). User moderation outcomes are mirrored under **`users/{uid}/notifications`** (read/update `read` only for the owner). Inspect queues in Console or via admin callables. After rotating **`OPENAI_API_KEY`**, redeploy or update env vars; 401-style failures create **`auth_invalid`** incidents until fixed.

Rotate or remove `ADMIN_BOOTSTRAP_SECRET` after o primeiro admin estiver criado; novos admins podem ser promovidos por um script Admin SDK ou por uma Function futura que só admins possam chamar.

**Guia passo a passo (deploy, segredo, curl, Flutter):** ver [`planning/ADMIN_BOOTSTRAP.md`](../planning/ADMIN_BOOTSTRAP.md).

If `STRIPE_SECRET_KEY` is **unset**, `createCheckoutSession` and `createPortalSession` return `failed-precondition` (`billing_not_configured`), and `stripeWebhook` responds with **503**. You can still deploy and run **`migrateUserBillingDefaults`** without Stripe.

**Where to set:** Google Cloud Console → Cloud Functions → select function → **Edit** → **Runtime environment variables** (or use `gcloud functions deploy` with `--set-env-vars`).

## Webhook URL

After deploy, register the HTTPS URL in Stripe Dashboard → Webhooks:

`https://us-central1-<PROJECT_ID>.cloudfunctions.net/stripeWebhook`

Subscribe to at least: `checkout.session.completed`, `customer.subscription.created`, `customer.subscription.updated`, `customer.subscription.deleted`.

## Flutter

- **Region:** `cloud_functions` uses `us-central1` by default; override with `--dart-define=FUNCTIONS_REGION=...` (see `lib/core/billing/firebase_functions_region.dart`).
- **Billing:** `createCheckoutSession`, `createPortalSession`, `migrateUserBillingDefaults` — see `lib/core/billing/`. **Billing UI is off by default** (`BILLING_ENABLED=false`); enable with:

  ```bash
  flutter run --dart-define=BILLING_ENABLED=true
  ```

  When `BILLING_ENABLED` is false (default), the app uses `DisabledBillingProvider` (no checkout/portal calls); migration still runs when possible.
- **Moderation:** `moderateContent` — `lib/core/moderation/moderation_functions_service.dart` (pass **`letterId`** for comments when the human queue may apply). **Admin:** `AdminFunctionsService` in `lib/core/admin/admin_functions_service.dart` (`adminListPendingReports`, `adminResolveReport`, `adminListRecentFeedback`, `adminListModerationIncidents`, `adminGetModerationInfo`, **`adminListPendingModerationReviews`**, **`adminResolveModerationReview`**). Inbox: `lib/features/profile/presentation/screens/moderation_notifications_screen.dart`. Requires Firebase Auth custom claim `admin: true` on ID token for admin callables.
- **Remote flags:** `systemConfig/app` in Firestore (`aiModerationEnabled`, `aiModerationFailClosed`, **`humanModerationQueueEnabled`**, **`moderationReviewScoreThreshold`**, …) — read by `lib/core/config/system_config_provider.dart`; see [`planning/ARCHITECTURE.md`](../planning/ARCHITECTURE.md).

## Troubleshooting deploy (2nd Gen)

### `missing permission on the build service account`

That message is **not** normal for a successful deploy — the Cloud Build step that builds the container image failed (IAM), not your TypeScript.

1. **Open the Cloud Build log** linked in the error (Build history → failed build → step logs) and note the exact permission denied (e.g. Artifact Registry, Service Account User).

2. **Typical fixes** (as project **Owner** or **Editor** on `openwhen-923f5`):
   - **IAM & Admin** → find the **Cloud Build service account**  
     `PROJECT_NUMBER@cloudbuild.gserviceaccount.com`  
     Ensure it has at least:
     - `Cloud Build Service Account` (default) and roles needed to push images, often **Artifact Registry Writer** (`roles/artifactregistry.writer`) on the project or registry used by Functions.
   - Grant **Service Account User** (`roles/iam.serviceAccountUser`) on the **runtime** service account used by Cloud Functions (often `PROJECT_NUMBER-compute@developer.gserviceaccount.com`) **to** the Cloud Build SA — so the build can deploy as that identity.
   - If the project sits under an **organization**, an **org policy** may block default service accounts or key usage; an admin may need to adjust policy or use a dedicated build SA as in [Cloud Functions troubleshooting — build service account](https://cloud.google.com/functions/docs/troubleshooting#build-service-account).

3. After IAM changes, wait a few minutes and run `firebase deploy --only functions` again.

### Other messages in the same log

| Message | Meaning |
|--------|---------|
| Node.js 20 deprecated | This repo uses **`engines.node`: 22** in [`package.json`](package.json). Redeploy functions; confirm runtime in Cloud Console (see [Node.js runtime support](https://cloud.google.com/functions/docs/concepts/nodejs-runtime)). |
| `firebase-functions` outdated | Optional: `cd functions && npm install firebase-functions@latest` (test locally after). |
| APIs enabled automatically | Normal on first deploy (`run.googleapis.com`, `eventarc.googleapis.com`, etc.). |

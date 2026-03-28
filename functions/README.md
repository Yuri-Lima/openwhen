# Firebase Cloud Functions (billing)

Callable and HTTP endpoints for **Stripe** subscriptions. **No Google Secret Manager is required** — keys are read from **runtime environment variables** (set in Google Cloud Console for each function, or `.env` for the emulator).

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
| `ADMIN_BOOTSTRAP_SECRET` | No (moderation only) | Long random string; used **once** with callable `bootstrapAdminClaim` to set `admin: true` on the **signed-in** user’s custom claims |

### Moderation / superadmin

- **`bootstrapAdminClaim`** (callable): body `{ "secret": "<same as ADMIN_BOOTSTRAP_SECRET>" }`. Caller must be authenticated. Sets Firebase Auth custom claim `admin: true` on that user. After calling, the client must refresh the ID token (`getIdToken(true)`) before `adminListPendingReports` and related callables succeed.
- **`adminListPendingReports`**, **`adminResolveReport`**, **`adminListRecentFeedback`**: require `admin: true` on the ID token. Implementação no app: **Configurações → Moderação (admin)** (visível só com claim).

Rotate or remove `ADMIN_BOOTSTRAP_SECRET` after o primeiro admin estiver criado; novos admins podem ser promovidos por um script Admin SDK ou por uma Function futura que só admins possam chamar.

If `STRIPE_SECRET_KEY` is **unset**, `createCheckoutSession` and `createPortalSession` return `failed-precondition` (`billing_not_configured`), and `stripeWebhook` responds with **503**. You can still deploy and run **`migrateUserBillingDefaults`** without Stripe.

**Where to set:** Google Cloud Console → Cloud Functions → select function → **Edit** → **Runtime environment variables** (or use `gcloud functions deploy` with `--set-env-vars`).

## Webhook URL

After deploy, register the HTTPS URL in Stripe Dashboard → Webhooks:

`https://us-central1-<PROJECT_ID>.cloudfunctions.net/stripeWebhook`

Subscribe to at least: `checkout.session.completed`, `customer.subscription.created`, `customer.subscription.updated`, `customer.subscription.deleted`.

## Flutter

- Calls `createCheckoutSession`, `createPortalSession`, and `migrateUserBillingDefaults` via `cloud_functions` (region `us-central1` by default; override with `--dart-define=FUNCTIONS_REGION=...`).
- **Billing UI / Stripe checkout is off by default** so you can develop without Stripe. Enable with:

  ```bash
  flutter run --dart-define=BILLING_ENABLED=true
  ```

  When `BILLING_ENABLED` is false (default), the app uses `DisabledBillingProvider` (no checkout/portal calls); migration still runs when possible.

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
| Node.js 20 deprecated | Plan an upgrade to Node 22 before the decommission date (see Cloud Functions runtime support). |
| `firebase-functions` outdated | Optional: `cd functions && npm install firebase-functions@latest` (test locally after). |
| APIs enabled automatically | Normal on first deploy (`run.googleapis.com`, `eventarc.googleapis.com`, etc.). |

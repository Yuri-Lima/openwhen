import {initializeApp} from "firebase-admin/app";
import {FieldValue, getFirestore} from "firebase-admin/firestore";
import {HttpsError, onCall, onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import {setGlobalOptions} from "firebase-functions/v2/options";
import Stripe from "stripe";

export {
  adminListPendingReports,
  adminListRecentFeedback,
  adminResolveReport,
  bootstrapAdminClaim,
} from "./admin";

setGlobalOptions({region: "us-central1"});

initializeApp();
const db = getFirestore();

/** Uses process.env only — no Secret Manager required for deploy. Set in GCP or .env (emulator). */
function billingConfigured(): boolean {
  const k = process.env.STRIPE_SECRET_KEY;
  return !!(k && k.length > 0);
}

function getStripe(): Stripe | null {
  const key = process.env.STRIPE_SECRET_KEY;
  if (!key || key.length === 0) return null;
  return new Stripe(key);
}

function allowedRedirectUrl(url: string): boolean {
  const patterns = [
    /^https:\/\/localhost(:\d+)?\//,
    /^https:\/\/127\.0\.0\.1(:\d+)?\//,
    /^https:\/\/[\w-]+\.web\.app\//,
    /^https:\/\/[\w-]+\.firebaseapp\.com\//,
    /^openwhen:\/\//,
    /^https:\/\/openwhen\.app\//,
    /^https:\/\/example\.com\//,
  ];
  return patterns.some((re) => re.test(url));
}

function tierFromPriceId(priceId: string): "plus" | "pro" | null {
  const plus = process.env.STRIPE_PRICE_PLUS || "";
  const pro = process.env.STRIPE_PRICE_PRO || "";
  if (plus && priceId === plus) return "plus";
  if (pro && priceId === pro) return "pro";
  return null;
}

async function resolveFirebaseUid(
  stripe: Stripe,
  sub: Stripe.Subscription
): Promise<string | undefined> {
  if (sub.metadata?.firebaseUid) {
    return sub.metadata.firebaseUid;
  }
  const customerId =
    typeof sub.customer === "string" ? sub.customer : sub.customer?.id;
  if (!customerId) return undefined;
  const cust = await stripe.customers.retrieve(customerId);
  if (cust.deleted || !("metadata" in cust)) return undefined;
  return cust.metadata?.firebaseUid;
}

async function applySubscriptionToUser(
  stripe: Stripe,
  sub: Stripe.Subscription
): Promise<void> {
  const resolvedUid = await resolveFirebaseUid(stripe, sub);
  if (!resolvedUid) {
    logger.warn("Subscription without firebaseUid metadata", {id: sub.id});
    return;
  }

  const item = sub.items.data[0];
  const priceId = item?.price?.id;
  const tier = priceId ? tierFromPriceId(priceId) : null;
  const status = sub.status;
  const customerId =
    typeof sub.customer === "string" ? sub.customer : sub.customer?.id;

  const activeAccess =
    tier &&
    (status === "active" ||
      status === "trialing" ||
      status === "past_due");

  const ref = db.collection("users").doc(resolvedUid);
  if (
    status === "canceled" ||
    status === "unpaid" ||
    status === "incomplete_expired"
  ) {
    await ref.set(
      {
        subscriptionTier: "free",
        subscriptionStatus: status,
        stripeSubscriptionId: sub.id,
        ...(customerId ? {stripeCustomerId: customerId} : {}),
      },
      {merge: true}
    );
    return;
  }

  await ref.set(
    {
      subscriptionTier: activeAccess && tier ? tier : "free",
      subscriptionStatus: status,
      stripeSubscriptionId: sub.id,
      ...(customerId ? {stripeCustomerId: customerId} : {}),
    },
    {merge: true}
  );
}

export const createCheckoutSession = onCall(
  {
    cors: true,
  },
  async (request) => {
    if (!billingConfigured()) {
      throw new HttpsError(
        "failed-precondition",
        "billing_not_configured"
      );
    }
    const stripe = getStripe();
    if (!stripe) {
      throw new HttpsError("failed-precondition", "billing_not_configured");
    }

    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const uid = request.auth.uid;
    const email = request.auth.token.email;
    if (!email) {
      throw new HttpsError("failed-precondition", "User email required");
    }
    const planId = request.data?.planId as string;
    if (planId !== "plus" && planId !== "pro") {
      throw new HttpsError("invalid-argument", "Invalid planId");
    }
    const successUrl = request.data?.successUrl as string;
    const cancelUrl = request.data?.cancelUrl as string;
    if (!successUrl || !cancelUrl) {
      throw new HttpsError("invalid-argument", "successUrl and cancelUrl required");
    }
    if (!allowedRedirectUrl(successUrl) || !allowedRedirectUrl(cancelUrl)) {
      throw new HttpsError("invalid-argument", "Redirect URLs not allowed");
    }

    const priceId =
      planId === "plus"
        ? process.env.STRIPE_PRICE_PLUS || ""
        : process.env.STRIPE_PRICE_PRO || "";
    if (!priceId) {
      throw new HttpsError("failed-precondition", "Stripe price IDs not configured");
    }

    const session = await stripe.checkout.sessions.create({
      mode: "subscription",
      customer_email: email,
      line_items: [{price: priceId, quantity: 1}],
      success_url: successUrl,
      cancel_url: cancelUrl,
      client_reference_id: uid,
      metadata: {firebaseUid: uid},
      subscription_data: {
        metadata: {firebaseUid: uid},
      },
    });

    if (!session.url) {
      throw new HttpsError("internal", "No checkout URL");
    }
    return {url: session.url};
  }
);

export const createPortalSession = onCall(
  {
    cors: true,
  },
  async (request) => {
    if (!billingConfigured()) {
      throw new HttpsError(
        "failed-precondition",
        "billing_not_configured"
      );
    }
    const stripe = getStripe();
    if (!stripe) {
      throw new HttpsError("failed-precondition", "billing_not_configured");
    }

    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const uid = request.auth.uid;
    const returnUrl = request.data?.returnUrl as string;
    if (!returnUrl || !allowedRedirectUrl(returnUrl)) {
      throw new HttpsError("invalid-argument", "Valid returnUrl required");
    }

    const snap = await db.collection("users").doc(uid).get();
    const customerId = snap.data()?.stripeCustomerId as string | undefined;
    if (!customerId) {
      throw new HttpsError(
        "failed-precondition",
        "No Stripe customer — subscribe once in Checkout first"
      );
    }

    const portal = await stripe.billingPortal.sessions.create({
      customer: customerId,
      return_url: returnUrl,
    });
    return {url: portal.url};
  }
);

/** Sets subscriptionTier to free when missing (Admin SDK; bypasses client rules). */
export const migrateUserBillingDefaults = onCall(async (request) => {
  if (!request.auth?.uid) {
    throw new HttpsError("unauthenticated", "Sign in required");
  }
  const uid = request.auth.uid;
  const ref = db.collection("users").doc(uid);
  const snap = await ref.get();
  if (!snap.exists) {
    return {ok: false, reason: "no_user"};
  }
  const data = snap.data();
  if (data?.subscriptionTier != null && data.subscriptionTier !== "") {
    return {ok: true, skipped: true};
  }
  await ref.set({subscriptionTier: "free"}, {merge: true});
  return {ok: true, migrated: true};
});

export const stripeWebhook = onRequest(
  {
    cors: false,
  },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).send("Method Not Allowed");
      return;
    }

    if (!billingConfigured() || !process.env.STRIPE_WEBHOOK_SECRET) {
      logger.warn("stripeWebhook: Stripe env not configured; skipping");
      res.status(503).send("Stripe billing not configured");
      return;
    }

    const stripe = getStripe();
    if (!stripe) {
      res.status(503).send("Stripe billing not configured");
      return;
    }

    const sig = req.headers["stripe-signature"];
    if (!sig || typeof sig !== "string") {
      res.status(400).send("Missing stripe-signature");
      return;
    }

    let event: Stripe.Event;
    try {
      const raw = req.rawBody;
      if (!raw) {
        res.status(400).send("Missing raw body");
        return;
      }
      event = stripe.webhooks.constructEvent(
        raw,
        sig,
        process.env.STRIPE_WEBHOOK_SECRET
      );
    } catch (err) {
      logger.error("Webhook verify failed", err);
      res.status(400).send("Webhook verify failed");
      return;
    }

    try {
      switch (event.type) {
      case "checkout.session.completed": {
        const session = event.data.object as Stripe.Checkout.Session;
        const uid =
          session.metadata?.firebaseUid ||
          session.client_reference_id;
        if (uid && session.mode === "subscription") {
          const customerId = session.customer as string;
          if (customerId) {
            await db.collection("users").doc(uid).set(
              {stripeCustomerId: customerId},
              {merge: true}
            );
            await stripe.customers.update(customerId, {
              metadata: {firebaseUid: uid},
            });
          }
        }
        break;
      }
      case "customer.subscription.created":
      case "customer.subscription.updated": {
        const sub = event.data.object as Stripe.Subscription;
        await applySubscriptionToUser(stripe, sub);
        break;
      }
      case "customer.subscription.deleted": {
        const sub = event.data.object as Stripe.Subscription;
        const uid = sub.metadata?.firebaseUid;
        const customerId =
          typeof sub.customer === "string" ? sub.customer : sub.customer?.id;
        let resolved = uid;
        if (!resolved && customerId) {
          const cust = await stripe.customers.retrieve(customerId);
          if (!cust.deleted && "metadata" in cust) {
            resolved = cust.metadata?.firebaseUid;
          }
        }
        if (resolved) {
          await db.collection("users").doc(resolved).set(
            {
              subscriptionTier: "free",
              subscriptionStatus: "canceled",
              stripeSubscriptionId: FieldValue.delete(),
            },
            {merge: true}
          );
        }
        break;
      }
      default:
        break;
      }
    } catch (e) {
      logger.error("Webhook handler error", e);
      res.status(500).send("Handler error");
      return;
    }

    res.json({received: true});
  }
);

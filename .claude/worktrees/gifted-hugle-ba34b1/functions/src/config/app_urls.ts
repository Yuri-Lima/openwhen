/**
 * Single source of truth for all whenote.app URLs and contact emails
 * used across Cloud Functions.
 *
 * Every deep-link, legal page URL, or sender email that references the
 * `whenote.app` domain MUST come from this file so that a domain change
 * only requires editing one place.
 */

// ---------------------------------------------------------------------------
// Base
// ---------------------------------------------------------------------------
export const BASE_URL = "https://whenote.app";

// ---------------------------------------------------------------------------
// Deep links
// ---------------------------------------------------------------------------
export const letterUrl = (letterId: string): string =>
  `${BASE_URL}/letter/${letterId}`;

export const openUrl = (token: string): string =>
  `${BASE_URL}/open/${token}`;

// ---------------------------------------------------------------------------
// Legal / policy pages
// ---------------------------------------------------------------------------
export const PRIVACY_URL = `${BASE_URL}/privacy.html`;
export const TERMS_URL = `${BASE_URL}/terms.html`;

// ---------------------------------------------------------------------------
// Email defaults
// ---------------------------------------------------------------------------
export const DEFAULT_FROM_EMAIL =
  process.env.SENDGRID_FROM_EMAIL || "noreply@whenote.app";

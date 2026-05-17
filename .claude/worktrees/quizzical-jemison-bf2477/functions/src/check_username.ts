import {HttpsError, onCall} from "firebase-functions/v2/https";
import {getFirestore} from "firebase-admin/firestore";

/**
 * Checks whether a username is available.
 *
 * This callable does **not** require authentication so it can be invoked
 * from the registration screen before the user has an account.
 */
export const checkUsernameAvailable = onCall(
  {cors: true},
  async (request) => {
    const raw = request.data?.username;
    if (typeof raw !== "string" || raw.trim().length === 0) {
      throw new HttpsError("invalid-argument", "username is required");
    }

    const username = raw.trim().toLowerCase().replace(/@/g, "").replace(/ /g, "");

    // Format validation
    if (username.length < 3) {
      throw new HttpsError("invalid-argument", "username_too_short");
    }
    if (username.length > 20) {
      throw new HttpsError("invalid-argument", "username_too_long");
    }
    if (!/^[a-z0-9._]+$/.test(username)) {
      throw new HttpsError("invalid-argument", "username_invalid_chars");
    }
    if (/^[._]/.test(username) || /[._]$/.test(username)) {
      throw new HttpsError("invalid-argument", "username_invalid_edges");
    }
    if (/\.\./.test(username)) {
      throw new HttpsError("invalid-argument", "username_consecutive_dots");
    }

    const db = getFirestore();
    const snap = await db
      .collection("users")
      .where("username", "==", username)
      .limit(1)
      .get();

    return {available: snap.empty};
  }
);

// Building blocks of agent notifications. Each agent composes them in its own way.

import fs from "node:fs";
import { log } from "./log.js";
import { run } from "./run.js";

/** The existence of the file means the user don't want to send a notification. */
export function isNotificationDisabled() {
  const noNotifPath = process.env.AGENT_NO_NOTIF_PATH;
  return Boolean(noNotifPath && fs.existsSync(noNotifPath));
}

/** Send a desktop notification via notifm, with an optional subtitle. */
export async function notifyDesktop({ message, subtitle }) {
  const notifmArgs = subtitle ? ["-t", message, subtitle] : [message];
  await run("notifm", notifmArgs, { stdio: "ignore" });
}

/** Send a Discord notification, only when the webhook URL is set and the flag file exists. */
export async function notifyDiscord({ webhookUrl, flagPath, username, title, description }) {
  if (!webhookUrl || !fs.existsSync(flagPath)) return;

  const body = {
    username,
    embeds: [{ title, description, color: 14711343 }],
  };

  log(`send web notification: ${title}: "${description}"`);
  await fetch(webhookUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

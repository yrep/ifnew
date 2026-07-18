// src/lib/server/pocketbase.js
import PocketBase from "pocketbase";
import { config } from "$lib/common/config.js";

export const pb = new PocketBase(config.pocketbase.url);

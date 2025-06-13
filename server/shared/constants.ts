import { SHOP_PROVIDER } from "./types";

export const ANDROID_WEB_CLIENT_ID =
  "675848705064-ope52veb5ql854hdlkm044sk37j6lkt8.apps.googleusercontent.com";

export const IOS_WEB_CLIENT_ID =
  "675848705064-7q99pkk565e17ii3r5j2tssfengi7h32.apps.googleusercontent.com";

export const ONE_DAY_MILLISECONDS = 1000 * 60 * 60 * 24;

export const BASELINKER_API_URL = "https://api.baselinker.com/connector.php";
export const BASELINKER_API_TOKEN = process.env.BASELINKER_API_KEY;
export const STORAGE_IDS = ["shop_5016790"];

export const DEFAULT_ALL_SHOPS_OBJECT = {
  [SHOP_PROVIDER.PRESTASHOP]: {},
};

import { getCollection } from "astro:content";

export const sot = (await getCollection("sot"))[0].data;

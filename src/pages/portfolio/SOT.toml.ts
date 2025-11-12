import { getLastUpdated } from "@utils/updated-and-published-utils.ts";
import type { APIRoute } from "astro";
import sot from "../../content/sot/SOT.toml?raw";

export const GET: APIRoute = async () => {
	return new Response(sot, {
		headers: {
			"Content-Type": "text/plain; charset=utf-8",
			"X-Content-Type-Options": "nosniff",
			Date: new Date().toUTCString(),
			"Last-Modified": (
				await getLastUpdated("src/content/sot/SOT.toml")
			).toUTCString(),
			"Cache-Control": "no-cache, must-revalidate, max-age=0",
			"Content-Length": sot.length.toString(),
			ETag: Array.from(
				new Uint8Array(
					await crypto.subtle.digest("SHA-256", new TextEncoder().encode(sot)),
				),
			)
				.map((b) => b.toString(16).padStart(2, "0"))
				.join(""),
		},
	});
};

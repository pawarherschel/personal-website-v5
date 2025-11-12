import aiblocks from "@constants/aiblocks.txt?raw";
import type { APIRoute } from "astro";

const robotsTxt = `
User-agent: *
Disallow: /_astro/

${aiblocks}

Sitemap: ${new URL("sitemap-index.xml", import.meta.env.SITE).href}
`.trim();

export const GET: APIRoute = () => {
	return new Response(robotsTxt, {
		headers: {
			"Content-Type": "text/plain; charset=utf-8",
			"X-Content-Type-Options": "nosniff",
			Date: new Date().toUTCString(),
			"Cache-Control": `public, max-age=${24 * 60 * 60}`,
			"Content-Length": robotsTxt.length.toString(),
		},
	});
};

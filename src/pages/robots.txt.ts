import type { APIRoute } from "astro";
import aiblocks from "@constants/aiblocks.txt?raw"

const robotsTxt = `
User-agent: *
Disallow: /_astro/

${aiblocks}
Disallow: /

Sitemap: ${new URL("sitemap-index.xml", import.meta.env.SITE).href}
`.trim();

export const GET: APIRoute = () => {
	return new Response(robotsTxt, {
		headers: {
			"Content-Type": "text/plain; charset=utf-8",
		},
	});
};


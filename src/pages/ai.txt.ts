import type { APIRoute } from "astro";

// Taken from https://baccyflap.com/res/robots/#ai
const content = `
User-Agent: *
Disallow: /
Disallow: *
`.trim();

export const GET: APIRoute = () => {
	return new Response(content, {
		headers: {
			"Content-Type": "text/plain; charset=utf-8",
			"X-Content-Type-Options": "nosniff",
			Date: new Date().toUTCString(),
			"Cache-Control": `public, max-age=${24 * 60 * 60}`,
			"Content-Length": content.length.toString(),
		},
	});
};

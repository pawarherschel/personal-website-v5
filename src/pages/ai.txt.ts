import type { APIRoute } from "astro";

// Taken from https://baccyflap.com/res/robots/#ai
const content = `
User-Agent: *
Disallow: /
Disallow: *
`.trim()

export const GET: APIRoute = () => {
	return new Response(content, {
		headers: {
			"Content-Type": "text/plain; charset=utf-8",
		},
	});
};

import { getCollection } from "astro:content";
import { $typst } from "@myriaddreamin/typst.ts";

// TODO: convert to png using https://github.com/thx/resvg-js
export async function GET({ params }: { params: { slug: string } }) {
	const post = (await getCollection("posts")).find(
		(post) => post.slug === params.slug,
	);

	if (!post) {
		return new Response("Not Found", { status: 404 });
	}

	// Define your Typst template for the Open Graph image
	const typstTemplate = `${post.data.title}`;

	try {
		// Compile the Typst template to an SVG image
		const svgContent = await $typst.svg({
			mainContent: typstTemplate,
			data_selection: {
				body: true,
				defs: true,
				css: true,
				js: false,
			},
		});

		if (!svgContent) {
			return new Response("Error generating SVG image: Content is undefined", {
				status: 500,
			});
		}

		return new Response(svgContent, {
			headers: {
				"Content-Type": "image/svg+xml",
			},
		});
	} catch (error) {
		console.error("Error generating Open Graph image:", error);
		return new Response("Error generating image", { status: 500 });
	}
}

export async function getStaticPaths() {
	const posts = await getCollection("posts");
	return posts.map((post) => ({
		params: {
			slug: post.slug.replace(".svg/", ".svg"),
		},
	}));
}

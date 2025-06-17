import { getCollection } from "astro:content";
import { $typst } from "@myriaddreamin/typst.ts";
import type { SweetRenderOptions } from "@myriaddreamin/typst.ts/dist/esm/contrib/snippet.mjs";
import type { RenderSvgOptions } from "@myriaddreamin/typst.ts/dist/esm/options.render.mjs";
import { Resvg, type ResvgRenderOptions } from "@resvg/resvg-js";
import { getUpdatedAndPublishedForFilePath } from "@utils/updated-and-published-utils.ts";
import getReadingTime from "reading-time";
import template from "../../../public/template.typ?raw";

export async function GET({ params }: { params: { slug: string } }) {
	const post = (await getCollection("posts")).find(
		(post) => post.slug === params.slug,
	);

	if (!post) {
		return new Response("Not Found", { status: 404 });
	}

	// Define your Typst template for the Open Graph image
	const typstTemplate = template;

	const readingTime = getReadingTime(post.body ?? "");
	const time = Math.max(1, Math.round(readingTime.minutes));
	const words = readingTime.words;

	const { published, updated } = await getUpdatedAndPublishedForFilePath(
		// @ts-ignore
		post.filePath,
		post.data.updated,
		post.data.published,
	);

	// Compile the Typst template to an SVG image
	const o = {
		mainContent: typstTemplate,
		data_selection: {
			body: true,
			defs: true,
			css: false,
			js: false,
		},
		inputs: {
			data: JSON.stringify({
				data: post.data,
				payload: {
					time: time,
					words: words,
					updated: updated,
					published: published,
				},
			}),
		},
	} satisfies SweetRenderOptions & RenderSvgOptions;

	const svgContent = await $typst.svg(o);

	if (!svgContent) {
		return new Response("Error generating SVG image: Content is undefined", {
			status: 500,
		});
	}
	const opts = {
		fitTo: { mode: "width", value: 1500 },
		shapeRendering: 2,
		textRendering: 2,
		imageRendering: 0,
	} satisfies ResvgRenderOptions;
	const resvg = new Resvg(svgContent, opts);
	const pngData = resvg.render();
	const pngBuffer = pngData.asPng();
	return new Response(pngBuffer, {
		headers: { "Content-Type": "image/png" },
	});
}

export async function getStaticPaths() {
	const posts = await getCollection("posts");
	return posts.map((post) => ({
		params: {
			slug: post.slug.replace(".png/", ".png"),
		},
	}));
}

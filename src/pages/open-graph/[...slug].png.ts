import { getCollection } from "astro:content";
import {
	type CompileDocArgs,
	type NodeAddFontPaths,
	NodeCompiler,
	type NodeTypstDocument,
} from "@myriaddreamin/typst-ts-node-compiler";
import type { CompileArgs } from "@myriaddreamin/typst-ts-node-compiler/index-napi";
import { Resvg, type ResvgRenderOptions } from "@resvg/resvg-js";
import { failable } from "@utils/result-type.ts";
import { getUpdatedAndPublishedForFilePath } from "@utils/updated-and-published-utils.ts";
import getReadingTime from "reading-time";
import template from "../../../public/template.typ?raw";

const oklab = /=\s*"[^"]*?oklab\([\d.%,\s-]+\)[^"]*?"/; // sorry

export async function GET({ params }: { params: { slug: string } }) {
	const post = (await getCollection("posts")).find(
		(post) => post.slug === params.slug,
	);

	if (!post) {
		return new Response("Not Found", { status: 404 });
	}

	const readingTime = getReadingTime(post.body ?? "");
	const time = Math.max(1, Math.round(readingTime.minutes));
	const words = readingTime.words;

	const { published, updated } = await getUpdatedAndPublishedForFilePath(
		// @ts-ignore
		post.filePath,
		post.data.updated,
		post.data.published,
	);

	const compilerArg = {
		workspace: "./public",
		fontArgs: [{ fontPaths: ["./public/fonts"] } satisfies NodeAddFontPaths],
	} satisfies CompileArgs;

	const typstCompiler = NodeCompiler.create(compilerArg);

	const o = {
		mainFileContent: template,
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
	} satisfies NodeTypstDocument | CompileDocArgs;

	const svgContentResult = failable(() => typstCompiler.plainSvg(o));

	if (svgContentResult.tag === "err") {
		return new Response(
			`Error generating SVG image: Error: ${JSON.stringify(svgContentResult)}`,
			{
				status: 500,
			},
		);
	}

	const svgContent = svgContentResult.data;

	if (!svgContent) {
		return new Response("Error generating SVG image: Content is undefined", {
			status: 500,
		});
	}

	if (svgContent.match(oklab)) {
		throw new Error(
			// biome-ignore lint/style/useTemplate: <explanation>
			'The svg string includes something similar to `="oklab(l% a b)"`,\n' +
				"resvg doesn't support oklab colorspace (as of 2025-06-18),\n" +
				"see: https://github.com/linebender/resvg/issues/514\n" +
				"hint: check if you're using oklab colors anywhere in the typst template, " +
				"and convert them to rgb using `oklab-color.rgb()`\n" +
				`post.id: ${JSON.stringify(post.id, null, 2)}\n` +
				`post.filePath: ${JSON.stringify(post.filePath, null, 2)}\n` +
				`post.slug: ${JSON.stringify(post.slug, null, 2)}\n` +
				`post.data: ${JSON.stringify(post.data, null, 2)}\n`,
		);
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

import {getCollection} from "astro:content";
import {
	type CompileDocArgs,
	type NodeAddFontPaths,
	NodeCompiler,
	type NodeTypstDocument,
} from "@myriaddreamin/typst-ts-node-compiler";
import type {
	CompileArgs
} from "@myriaddreamin/typst-ts-node-compiler/index-napi";
import {failable} from "@utils/result-type.ts";
import {
	getUpdatedAndPublishedForFilePath
} from "@utils/updated-and-published-utils.ts";
import getReadingTime from "reading-time";
import postTemplateStr from "../../../public/template.typ?raw";
import otherTemplateStr
	from "../../../public/catchAllTemplate.typ?raw";
import _404TemplateStr from "../../../public/404Template.typ?raw";
import {LinkPreset} from "@/types/config.ts";
import assert from "node:assert";
import sharp, { type SharpOptions} from "sharp";


const postTemplate = {tag: "post", data: postTemplateStr}
const otherTemplate = {tag: "other", data: otherTemplateStr}
const _404Template = {tag: "404", data: _404TemplateStr}

const others = Object.values(LinkPreset)
	.filter((value): value is string => typeof value === 'string')
	.map((it) => it.toLowerCase())
	.map((it) => (it === "home" ? "" : it));

const oklab = /=\s*"[^"]*?oklab\([\d.%,\s-]+\)[^"]*?"/; // sorry

export async function GET({ params }: { params: { slug: string } }) {
	const post = (await getCollection("posts")).find(
		(post) => post.slug === params.slug,
	);

	let template = postTemplate

	if (!post) {
		template = otherTemplate
	}

	const {inputs, oklabCtx} = await (async (): Promise<{inputs: any, oklabCtx: string }> => {
		switch(template.tag){
			case "post": {
				assert(post !== undefined);

				const readingTime = getReadingTime(post.body ?? "");
				const time = Math.max(1, Math.round(readingTime.minutes));
				const words = readingTime.words;

				const {
					published,
					updated
				} = await getUpdatedAndPublishedForFilePath(
					// @ts-ignore
					post.filePath,
					post.data.updated,
					post.data.published,
				);

				const inputs = {
					tag: template.tag,
					data: post.data,
					payload: {
						time: time,
						words: words,
						updated: updated,
						published: published,
					},
				};

				const oklabCtx = `post.id: ${JSON.stringify(post.id, null, 2)}\n` +
						`post.filePath: ${JSON.stringify(post.filePath, null, 2)}\n` +
						`post.slug: ${JSON.stringify(post.slug, null, 2)}\n` +
						`post.data: ${JSON.stringify(post.data, null, 2)}\n`

				return {inputs: inputs, oklabCtx: oklabCtx}
			}
			case "other": {
				return {inputs: {tag: template.tag, data: params.slug}, oklabCtx: ""}
			}
			default: {
				return {inputs: {tag: template.tag}, oklabCtx: ""}
			}
		}
	})();



	const compilerArg = {
		workspace: "./public",
		fontArgs: [{ fontPaths: ["./public/fonts"] } satisfies NodeAddFontPaths],
	} satisfies CompileArgs;

	const typstCompiler = NodeCompiler.create(compilerArg);

	const o = {
		mainFileContent: template.data,
		inputs: {
			data: JSON.stringify(inputs),
		},
	} satisfies NodeTypstDocument | CompileDocArgs;

	const svgContentResult = failable(() => typstCompiler.plainSvg(o));

	if (svgContentResult.tag === "err") {
		return new Response(
			`Error generating SVG image: Error: ${JSON.stringify(svgContentResult)}\n${JSON.stringify(inputs, null, 3)}`,
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
			'The svg string includes something similar to `="oklab(l% a b)"`,\n' +
				"resvg doesn't support oklab colorspace (as of 2025-06-18),\n" +
				"see: https://github.com/linebender/resvg/issues/514\n" +
				"hint: check if you're using oklab colors anywhere in the typst template, " +
				"and convert them to rgb using `oklab-color.rgb()`\n" + oklabCtx
		);
	}

	const sharpInput:  sharp.SharpInput = Buffer.from(svgContent,"utf-8")
	const sharpOpts = {} satisfies SharpOptions;
	const jpegOpts = {
		mozjpeg:true,
	} satisfies sharp.JpegOptions;

	const jpegBuffer = await sharp(
		sharpInput,
		sharpOpts
	).jpeg(
		jpegOpts
	).toBuffer()

	// const opts = {
	// 	fitTo: { mode: "width", value: 1500 },
	// 	shapeRendering: 2,
	// 	textRendering: 2,
	// 	imageRendering: 0,
	// } satisfies ResvgRenderOptions;
	// const resvg = new Resvg(svgContent, opts);
	// const pngData = resvg.render();
	// const pngBuffer = pngData.asPng();
	return new Response(jpegBuffer, {
		headers: { "Content-Type": "image/jpeg" },
	});
}

export const getStaticPaths = async () =>
	[
		(await getCollection("posts"))
			.map((it) => ({
				data: it.slug,
			})),
		others
			.map((it) => it === "" ? "home" : it)
			.map((it) => ({data: it}))
	]
		.flat()
		.map(({ data }) => ({
			params: {
				slug: data,
			},
		}));

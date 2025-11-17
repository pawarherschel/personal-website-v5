import type {
	CompileDocArgs,
	NodeTypstDocument,
	RenderPdfOpts,
} from "@myriaddreamin/typst-ts-node-compiler";
import { getLastUpdated } from "@utils/updated-and-published-utils.ts";
import type { APIRoute } from "astro";
import { typstCompiler } from "@/typstCompiler.ts";

export const GET: APIRoute = async ({ request }) => {
	const lastUpdatedDate = await getLastUpdated("src/content/sot/SOT.toml");
	const viewMode = new URL(request.url).searchParams.get("view") === "true";

	const inputs = {
		full: true,
	};

	const o = {
		mainFilePath:"src/content/sot/resume.typ",
		inputs: {
			data: JSON.stringify(inputs),
		},
	} satisfies NodeTypstDocument | CompileDocArgs;

	const pdfOpts: RenderPdfOpts = {
		creationTimestamp: undefined,
		pdfStandard: undefined,
	};

	const maybePdf = typstCompiler.compile(o);
	if (maybePdf.hasError()) {
		maybePdf.printDiagnostics();
		maybePdf.printErrors();
		throw maybePdf.hasError();
	}

	const pdf = typstCompiler.pdf(maybePdf.result ?? o, pdfOpts);

	// @ts-expect-error
	return new Response(pdf, {
		headers: {
			"Content-Type": "application/pdf",
			"X-Content-Type-Options": "nosniff",
			Date: new Date().toUTCString(),
			"Last-Modified": lastUpdatedDate.toUTCString(),
			"Cache-Control": "no-cache, must-revalidate, max-age=0",
			"Content-Disposition": `${viewMode ? "inline" : "attachment"}; filename="${"Herschel Pravin Pawar".replaceAll(
				" ",
				"-",
			)}-Full-Resume-${lastUpdatedDate.getUTCFullYear()}-${(
				lastUpdatedDate.getUTCMonth() + 1
			)
				.toString()
				.padStart(2, "0")}-${lastUpdatedDate
				.getDate()
				.toString()
				.padStart(2, "0")}.pdf"`,
			"Content-Length": pdf.length.toString(),
			ETag: Array.from(
				new Uint8Array(
					await crypto.subtle.digest(
						"SHA-256",
						// @ts-expect-error
						pdf.buffer.slice(pdf.byteOffset, pdf.byteOffset + pdf.length),
					),
				),
			)
				.map((b) => b.toString(16).padStart(2, "0"))
				.join(""),
		},
	});
};

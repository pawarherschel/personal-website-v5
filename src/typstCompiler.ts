import {
	type NodeAddFontPaths,
	NodeCompiler,
} from "@myriaddreamin/typst-ts-node-compiler";
import type { CompileArgs } from "@myriaddreamin/typst-ts-node-compiler/index-napi";

const compilerArg = {
	workspace: ".",
	fontArgs: [{ fontPaths: ["./public/fonts"] } satisfies NodeAddFontPaths],
} satisfies CompileArgs;

export const typstCompiler = NodeCompiler.create(compilerArg);

import {
	type NodeAddFontPaths,
	NodeCompiler,
} from "@myriaddreamin/typst-ts-node-compiler";
import type { CompileArgs } from "@myriaddreamin/typst-ts-node-compiler/index-napi";

const compilerArg = {
	workspace: ".",
	fontArgs: [{ fontPaths: ["."] } satisfies NodeAddFontPaths],
} satisfies CompileArgs;

export const typstCompilerWith = (compileArgs: CompileArgs)=> {
	const args ={
		compilerArg,
		...compileArgs
	}
	return NodeCompiler.create(
		args
	)
}

export const typstCompiler = NodeCompiler.create(compilerArg);

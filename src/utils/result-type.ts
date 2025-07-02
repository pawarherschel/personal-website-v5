export type Result<T> =
	| {
			tag: "ok";
			data: T;
	  }
	| {
			tag: "err";
			data: unknown;
	  };

export function failable<T>(
	op: () => T,
	mapErr?: (error: unknown) => unknown,
): Result<T> {
	try {
		return {
			tag: "ok",
			data: op(),
		};
	} catch (e) {
		if (e === undefined) {
			return {
				tag: "err",
				data: "Caught error was undefined, maybe check the console?",
			};
		}

		return {
			tag: "err",
			data: mapErr ? mapErr(e) : e,
		};
	}
}

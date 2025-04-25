import type { Callback } from "./render";
import { register, unregister } from "./state";

export interface Options {
	date: Date | number;
	locale?: string;
	live?: boolean;
}

export function relativeTime(node: HTMLElement, options: Options) {
	// biome-ignore lint/suspicious/noAssignInExpressions: <explanation>
	const callback: Callback = ({ text }) => (node.textContent = text);

	function init(options: Options) {
		const date = options.date;
		const locale = options.locale || navigator.language;
		// biome-ignore lint/suspicious/noAssignInExpressions: <explanation>
		const live = (options.live = true);

		register(node, date, locale, live, callback);
	}

	init(options);

	return {
		update(options: Options) {
			init(options);
		},
		destroy() {
			unregister(node);
		},
	};
}

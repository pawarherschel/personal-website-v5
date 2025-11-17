/** @type {import('tailwindcss').Config} */
const defaultTheme = require("tailwindcss/defaultTheme");
module.exports = {
	content: [
		"./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue,mjs,typ}",
		"./public/*.typ",
	],
	darkMode: "class", // allows toggling dark mode manually
	theme: {
		extend: {
			fontFamily: {
				sans: [
					"Atkinson Hyperlegible Next Variable",
					"sans-serif",
					...defaultTheme.fontFamily.sans,
				],
			},
			keyframes: {
				'backdrop-blur': {
					'0%, 100%': { 'backdrop-filter': 'blur(12px)' },
					'50%': { 'backdrop-filter': 'blur(8px)' },
				}
			},
			animation: {
				'backdrop-blur': 'backdrop-blur 5s linear infinite'
			}
		},
	},
	plugins: [require("@tailwindcss/typography")],
};

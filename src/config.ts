import type {
	BlueskyConfig,
	ExpressiveCodeConfig,
	LicenseConfig,
	NavBarConfig,
	ProfileConfig,
	SiteConfig,
} from "./types/config";
import { LinkPreset } from "./types/config";

export const siteConfig: SiteConfig = {
	title: "Sakura Kat Systems",
	subtitle: "Herschel Pravin Pawar's Personal Site",
	lang: "en", // 'en', 'zh_CN', 'zh_TW', 'ja', 'ko', 'es', 'th'
	themeColor: {
		hue: 330, // Default hue for the theme color, from 0 to 360. e.g. red: 0, teal: 200, cyan: 250, pink: 345
		fixed: true, // Hide the theme color picker for visitors
	},
	banner: {
		enable: true,
		src: "https://r2.sakurakat.systems/website-banner.svg", // Relative to the /src directory. Relative to the /public directory if it starts with '/'
		position: "center", // Equivalent to object-position, defaults center
		credit: {
			enable: true, // Display the credit text of the banner image
			text: "z creative labs GmbH / haikei", // Credit text to be displayed
			url: "https://haikei.app/", // (Optional) URL link to the original artwork or artist's page
		},
	},
	toc: {
		enable: true, // Display the table of contents on the right side of the post
		depth: 3, // Maximum heading depth to show in the table, from 1 to 3
	},
	favicon: [
		// Leave this array empty to use the default favicon
		// {
		//   src: '/favicon/icon.png',    // Path of the favicon, relative to the /public directory
		//   theme: 'light',              // (Optional) Either 'light' or 'dark', set only if you have different favicons for light and dark mode
		//   sizes: '32x32',              // (Optional) Size of the favicon, set only if you have favicons of different sizes
		// }
		{
			src: "https://r2.sakurakat.systems/favicon.svg",
		},
	],
};

export const navBarConfig: NavBarConfig = {
	links: [
		LinkPreset.Home,
		LinkPreset.Archive,
		LinkPreset.About,
		LinkPreset.Portfolio,
		{
			name: "GitHub",
			url: "https://github.com/pawarherschel/personal-website-v5",
			external: true,
		},
	],
};

export const profileConfig: ProfileConfig = {
	avatar: "https://r2.sakurakat.systems/profile-picture.png", // Relative to the /src directory. Relative to the /public directory if it starts with '/'
	name: "Herschel Pravin Pawar",
	bio: "Enthusiastic learner, curious about everything. Looking forward to work on projects that make a difference.",
	links: [
		{
			name: "Email",
			icon: "fa6-solid:envelope",
			url: "mailto:pawarherschel@gmail.com",
		},
		{
			name: "BlueSky",
			icon: "fa6-brands:bluesky",
			url: "https://bsky.app/profile/sakurakat.systems",
		},
		{
			name: "Fediverse",
			icon: "ph:fediverse-logo-fill",
			url: "https://transfem.social/@katsakura",
		},
		{
			name: "LinkedIn",
			icon: "fa6-brands:linkedin",
			url: "https://www.linkedin.com/in/pawarherschel/",
		},
		{
			name: "GitHub",
			icon: "fa6-brands:github",
			url: "https://github.com/pawarherschel",
		},
		{
			name: "ORCID",
			icon: "fa6-brands:orcid",
			url: "https://orcid.org/0009-0003-3218-801X",
		},
	],
};

export const blueskyConfig: BlueskyConfig = {
	blueskyIdentifier: "sakurakat.systems",
};

export const licenseConfig: LicenseConfig = {
	enable: true,
	name: "CC BY-ND 4.0",
	url: "https://creativecommons.org/licenses/by-nd/4.0/",
};

export const expressiveCodeConfig: ExpressiveCodeConfig = {
	// Note: Some styles (such as background color) are being overridden, see the astro.config.mjs file.
	// Please select a dark theme, as this blog theme currently only supports dark background color
	theme: "github-dark",
};

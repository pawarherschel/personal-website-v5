import { defineCollection, z } from "astro:content";
import { authorFeedLoader } from "@ascorbic/bluesky-loader";
import { file, glob } from "astro/loaders";
import toml from "toml";
import { blueskyConfig } from "../config.ts";

const blogCollection = defineCollection({
	schema: z.object({
		title: z.string(),
		published: z.date().optional(),
		updated: z.date().optional(),
		draft: z.boolean().optional().default(false),
		description: z.string().optional().default(""),
		image: z.string().optional().default(""),
		tags: z.array(z.string()).optional().default([]),
		category: z.string().optional().nullable().default(""),
		lang: z.string().optional().default(""),

		/* For internal use */
		prevTitle: z.string().default(""),
		prevSlug: z.string().default(""),
		nextTitle: z.string().default(""),
		nextSlug: z.string().default(""),
		headings: z
			.array(
				z.object({
					text: z.string(),
					depth: z.number().int().min(1).max(6),
					slug: z.string().min(1),
				}),
			)
			.default([]),
		tilslut: z.array(
			z.object({
				title: z.string(),
				by: z.string(),
				type: z.string(),
				url: z.string().url(),
				comment: z.string(),
				links: z.array(z.object({
					link: z.string().url(),
					text: z.string(),
				})).default([]),
				imageLink: z.string().url().nullable(),
				imageAlt: z.string().nullable(),
			})
		).default([]),
	}),
});

// const bskyCollection = defineCollection({
// 	loader: authorFeedLoader({
// 		identifier: blueskyConfig.blueskyIdentifier,
// 	}),
// });

const specCollection = defineCollection({
	schema: z.object({}),
});

const friendsCollection = defineCollection({
	loader: file("src/content/friends/friends.toml", {
		parser: (it) => {
			try {
				toml.parse(it.toString());
			} catch (e) {
				console.error(
					`Parsing error on line ${e.line}, column ${e.column}: ${e.message}`,
				);
			}
			return toml.parse(it.toString());
		},
	}),
	schema: z.object({
		title: z.string(),
		desc: z.string(),
		url: z.string().url(),
		icon: z.string().url().optional(),
		button: z.string().url().optional(),
		bsky: z.string().optional(),
	}),
});

export const collections = {
	posts: blogCollection,
	// bsky: bskyCollection,
	spec: specCollection,
	friends: friendsCollection,
};

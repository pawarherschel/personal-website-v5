import { defineCollection, z } from "astro:content";
import { authorFeedLoader } from "@ascorbic/bluesky-loader";
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
	}),
});

const bskyCollection = defineCollection({
	loader: authorFeedLoader({
		identifier: blueskyConfig.blueskyIdentifier,
	}),
});

const specCollection = defineCollection({});

export const collections = {
	posts: blogCollection,
	bsky: bskyCollection,
	spec: specCollection,
};

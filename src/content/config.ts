import { defineCollection, z } from "astro:content";
import { authorFeedLoader } from "@ascorbic/bluesky-loader";
import { blueskyConfig } from "../config.ts";

const blogCollection = defineCollection({
	schema: z.object({
		title: z.string(),
		published: z.date(),
		updated: z.date().optional(),
		draft: z.boolean().optional().default(false),
		description: z.string().optional().default(""),
		image: z.string().optional().default(""),
		tags: z.array(z.string()).optional().default([]),
		category: z.string().optional().default(""),
		lang: z.string().optional().default(""),

		/* For internal use */
		prevTitle: z.string().default(""),
		prevSlug: z.string().default(""),
		nextTitle: z.string().default(""),
		nextSlug: z.string().default(""),
	}),
});

const bskyCollection = defineCollection({
	loader: authorFeedLoader({
		identifier: blueskyConfig.blueskyIdentifier,
	}),
});

export const collections = {
	posts: blogCollection,
	bsky: bskyCollection,
};

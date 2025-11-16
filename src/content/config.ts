import { defineCollection, z } from "astro:content";
import { authorFeedLoader } from "@ascorbic/bluesky-loader";
import {file, glob} from "astro/loaders";
import { blueskyConfig } from "../config.ts";

export const Tilslut = z.array(
	z.object({
		title: z.string(),
		by: z.string(),
		type: z.string(),
		url: z.string().url(),
		comment: z.string(),
		links: z
			.array(
				z.object({
					link: z.string().url(),
					text: z.string(),
				}),
			)
			.default([]),
		imageLink: z.string().url().nullable(),
		imageAlt: z.string().nullable(),
	}),
);

const blogCollection = defineCollection({
	loader: glob({pattern: "src/content/posts/*"}),
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
		tilslut: Tilslut.default([]),
	}),
});

const bskyCollection = defineCollection({
	loader: authorFeedLoader({
		identifier: blueskyConfig.blueskyIdentifier,
		filter: "posts_no_replies",
	}),
});

const specCollection = defineCollection({
	loader: glob({pattern: "src/content/spec/*"}),
	schema: z.object({}),
});

const friendsCollection = defineCollection({
	loader: file("./src/content/friends/friends.toml"),
	schema: z.object({
		title: z.string(),
		desc: z.string(),
		url: z.string().url(),
		icon: z.string().url().optional(),
		button: z.string().url().optional(),
		bsky: z.string().optional(),
	}),
});

const InfoSchema = z.object({
	email: z.string().email(),
	github: z.string(),
	homepage: z.string(),
	linkedin: z.string(),
	orcid: z.string(),
	phone: z.string(),
});

const CertificateSchema = z.object({
	date: z.string(),
	issuer: z.string(),
	location: z.string(),
	title: z.string(),
	url: z.string().url(),
});

const CVEntry = z.object({
	date: z.string(),
	description: z.array(z.string()),
	location: z.union([
		z.string(),
		z.object({
			github: z.string(),
		}),
	]),
	preview: z.string().url().optional(),
	society: z.string(),
	tags: z.array(z.string()).default([]),
	title: z.string(),
	visible: z.boolean().default(true),
	logo: z.string().optional(),
});

const PublicationSchema = z.object({
	bibPath: z.string(),
	keyList: z.array(z.string()),
	refStyle: z.string(),
});

const SkillSchema = z.object({
	info: z.array(z.string()),
	type: z.string(),
	visible: z.boolean(),
});

export const ResumeSchema = z.object({
	bio: z.string(),
	location: z.string(),
	location_line: z.string(),
	name: z.string(),
	photo_path: z.string(),
	show_photo: z.boolean(),
	info: InfoSchema,
	certificates: z.array(CertificateSchema),
	education: z.array(CVEntry),
	projects: z.array(CVEntry),
	others: z.array(CVEntry),
	publications: PublicationSchema,
	skills: z.array(SkillSchema),
});

const sotCollection = defineCollection({
	loader: glob({ pattern: '*.toml', base: './src/content/sot' }),
	schema: ResumeSchema,
});

export const collections = {
	posts: blogCollection,
	bsky: bskyCollection,
	spec: specCollection,
	friends: friendsCollection,
	sot: sotCollection,
};

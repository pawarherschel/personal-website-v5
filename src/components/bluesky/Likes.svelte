<script lang="ts">
import { onMount } from "svelte";
import { getLikes, getPost, getUserPosts } from "./utils";

const { uri, likesCount, likesData, user, url } = $props();

let postUri = $state(uri);
let postLikesCount = $state(likesCount);
// biome-ignore lint/suspicious/noExplicitAny: <explanation>
let postLikesData = $state(likesData.filter((like: any) => like.actor.avatar));

onMount(async () => {
	if (!uri && user) {
		let posts = await getUserPosts(user);

		// @ts-expect-error: weird type fuckery
		const post = posts.find((post) => post.post.embed?.external?.uri === url);

		if (post) {
			postUri = post.post.uri;
			postLikesCount = post.post.likeCount;

			postLikesData = (await getLikes(post.post.uri)).filter(
				(like) => like.actor.avatar,
			);
		}
	} else if (uri) {
		postLikesData = (await getLikes(uri)).filter((like) => like.actor.avatar);

		const post = await getPost(uri);

		if (post) {
			postUri = post.uri;
			postLikesCount = post.likeCount;
		}
	}
});
</script>

{#if postUri}
	<div class="not-prose">
		<div class="text-xl mb-1 dark:text-neutral-50 transition">
			{postLikesCount} like{postLikesCount === 1 ? "" : "s"}
		</div>

		<div class="isolate flex -space-x-2 overflow-hidden px-4 flex-wrap">
			{#each postLikesData as user, index}
				<a
						href={`https://bsky.app/profile/${user.actor.handle}`}
						class={[
			"relative inline-block size-12 rounded-full overflow-hidden ring-2 ring-base-50 dark:ring-base-900  bg-base-950",
			index === 0 ? "-ml-2" : ""
		  ]}
						target="_blank"
				>
					<img
							title={user.actor.handle}
							loading="lazy"
							src={user.actor.avatar.replace("avatar", "avatar_thumbnail")}
							alt={"liked by " + user.actor.displayName}
					/>
				</a>
			{/each}

			{#if postLikesData.length < postLikesCount}
				<div
						class="z-10 text-sm text-accent-700 dark:text-accent-300 size-12 rounded-full flex items-center justify-center bg-accent-100 dark:bg-accent-950 ring-2 ring-base-50 dark:ring-base-900 font-semibold mb-4"
				>
					+{postLikesCount - postLikesData.length}
				</div>
			{/if}
		</div>
	</div>
{/if}

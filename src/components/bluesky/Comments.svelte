<script lang="ts">
import { onMount } from "svelte";
import Comment from "./Comment.svelte";
import { getCommentCount, getComments, getUserPosts } from "./utils";

let { uri, user, comments, url } = $props();

let postUri = $state(uri);

onMount(async () => {
	if (!uri && user) {
		let posts = await getUserPosts(user);

		// @ts-expect-error: weird type fuckery
		const post = posts.find((post) => post.post.embed?.external?.uri === url);

		if (post) {
			postUri = post.post.uri;
			comments = await getComments(post.post.uri);
		}
	} else if (uri) {
		comments = await getComments(uri);
	}
});
</script>

<div class="not-prose mx-4">
  {#if comments.length > 0}
    <div class="text-xl mb-1 dark:text-neutral-50 transition">
      {getCommentCount(comments)} comments, sorted by newest first
    </div>
  {/if}

  {#if comments.length > 0}
    <div class="pt-4">
      {#each comments as comment}
        <Comment {comment} />
      {/each}
    </div>
  {/if}
</div>

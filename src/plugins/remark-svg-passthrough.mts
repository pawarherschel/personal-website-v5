// src/remark-plugins/svg-passthrough.js
import { visit } from 'unist-util-visit';

/**
 * A Remark plugin to prevent Astro's image optimization on remote SVG files
 * by converting Markdown image syntax for SVGs into raw HTML <img> tags.
 * This is crucial for avoiding issues with astro:assets attempting to process SVGs.
 */
function svgPassthrough() {
	return (tree) => {
		visit(tree, 'image', (node, index, parent) => {
			// Ensure it's a valid image node with a URL
			if (node.url) {
				// Check if the URL ends with '.svg' (case-insensitive)
				const isSvg = node.url.toLowerCase().endsWith('.svg');
				// Check if it's a remote URL (starts with http:// or https://)
				const isRemote = node.url.startsWith('http://') || node.url.startsWith('https://');

				// If it's a remote SVG, transform the node
				if (isSvg && isRemote) {
					// Create a new HTML node representing a plain <img> tag
					// The 'loading="lazy"' attribute is added for better performance,
					// and alt/title attributes are preserved from the Markdown.
					const htmlNode = {
						type: 'html',
						value: `<img src="${node.url}" alt="${node.alt || ''}"${node.title ? ` title="${node.title}"` : ''} loading="lazy" />`,
					};

					// Replace the current Markdown image node with the new HTML node in the AST
					// This tells Astro's rendering pipeline to treat it as raw HTML,
					// bypassing astro:assets optimization for this specific image.
					parent.children.splice(index, 1, htmlNode);
				}
			}
		});
	};
}

export default svgPassthrough;
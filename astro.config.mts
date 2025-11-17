import sitemap from "@astrojs/sitemap";
import svelte from "@astrojs/svelte";
import tailwind from "@astrojs/tailwind";
import { pluginCollapsibleSections } from "@expressive-code/plugin-collapsible-sections";
import { pluginLineNumbers } from "@expressive-code/plugin-line-numbers";
import swup from "@swup/astro";
import expressiveCode  from "astro-expressive-code";
import icon from "astro-icon";
import {typst} from "astro-typst";
import {defineConfig} from "astro/config";
import rehypeAutolinkHeadings from "rehype-autolink-headings";
import rehypeComponents from "rehype-components";
import rehypeKatex from "rehype-katex";
import rehypeSlug from "rehype-slug";
import remarkDirective from "remark-directive";
import remarkGithubAdmonitionsToDirectives from "remark-github-admonitions-to-directives";
import remarkMath from "remark-math";
import remarkSectionize from "remark-sectionize";
import { expressiveCodeConfig } from "./src/config.ts";
import { pluginLanguageBadge } from "./src/plugins/expressive-code/language-badge.ts";
import {
    AdmonitionComponent
} from "./src/plugins/rehype-component-admonition.mts";
import {
    GithubCardComponent
} from "./src/plugins/rehype-component-github-card.mts";
import {
    parseDirectiveNode
} from "./src/plugins/remark-directive-rehype.ts";
import {remarkExcerpt} from "./src/plugins/remark-excerpt.ts";
import {
    remarkReadingTime
} from "./src/plugins/remark-reading-time.mts";
import metaTags from "astro-meta-tags";
import pageInsight from "astro-page-insight";
import { pluginCustomCopyButton } from "./src/plugins/expressive-code/custom-copy-button.ts";

// https://astro.build/config
export default defineConfig({
    site: "https://sakurakat.systems/",
    base: "/",
    trailingSlash: "ignore",
    experimental: {
        // csp: true, // needs configuration
        // failOnPrerenderConflict: true,
    },
    image: {
        domains: ["r2.sakurakat.systems"],
        responsiveStyles: true,
        layout: "constrained",
        service: {
            entrypoint: 'astro/assets/services/sharp',
            config: {
                limitInputPixels: false,
            },
        },
    },
    integrations: [
        typst({
            options: {

            },
            body: true,
            target: "html",
        }),
    tailwind({
        nesting: true,
    }),
    swup({
        theme: false,
        animationClass: "transition-swup-", // see https://swup.js.org/options/#animationselector
        // the default value `transition-` cause transition delay
        // when the Tailwind class `transition-all` is used
        containers: ["main", "#toc"],
        smoothScrolling: true,
        cache: true,
        preload: {
            hover: true,
            visible: true,
        },
        accessibility: true,
        updateHead: true,
        updateBodyClass: false,
        globalInstance: true,
    }), icon({
        include: {
            "preprocess: vitePreprocess(),": ["*"],
            "fa6-brands": ["*"],
            "fa6-regular": ["*"],
            "fa6-solid": ["*"],
        },
    }),
    expressiveCode({
        // @ts-ignore
        themes: [expressiveCodeConfig.theme, expressiveCodeConfig.theme],
        plugins: [
            pluginCollapsibleSections(),
            pluginLineNumbers(),
            pluginLanguageBadge(),
            pluginCustomCopyButton()
        ],
        defaultProps: {
            wrap: true,
            overridesByLang: {
                'shellsession': {
                    showLineNumbers: false,
                },
            },
        },
        styleOverrides: {
            codeBackground: "var(--codeblock-bg)",
            borderRadius: "0.75rem",
            borderColor: "none",
            codeFontSize: "0.875rem",
            codeFontFamily: "'JetBrains Mono Variable', ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace",
            codeLineHeight: "1.5rem",
            frames: {
                editorBackground: "var(--codeblock-bg)",
                terminalBackground: "var(--codeblock-bg)",
                terminalTitlebarBackground: "var(--codeblock-topbar-bg)",
                editorTabBarBackground: "var(--codeblock-topbar-bg)",
                editorActiveTabBackground: "none",
                editorActiveTabIndicatorBottomColor: "var(--primary)",
                editorActiveTabIndicatorTopColor: "none",
                editorTabBarBorderBottomColor: "var(--codeblock-topbar-bg)",
                terminalTitlebarBorderBottomColor: "none"
            },
            textMarkers: {
                // @ts-ignore
                delHue: 0,
                // @ts-ignore
                insHue: 180,
                // @ts-ignore
                markHue: 250
            }
        },
        frames: {
            showCopyToClipboardButton: false,
        }
    }),
    svelte(),
    sitemap(),
    metaTags(),
    pageInsight()],
    markdown: {
        remarkPlugins: [
            remarkMath,
            remarkReadingTime,
            remarkExcerpt,
            remarkGithubAdmonitionsToDirectives,
            remarkDirective,
            remarkSectionize,
            parseDirectiveNode,
        ],
        rehypePlugins: [
            rehypeKatex,
            rehypeSlug,
            [
                rehypeComponents,
                {
                    components: {
                        github: GithubCardComponent,
                        note: (x: any, y: any) => AdmonitionComponent(x, y, "note"),
                        tip: (x: any, y: any) => AdmonitionComponent(x, y, "tip"),
                        important: (x: any, y: any) => AdmonitionComponent(x, y, "important"),
                        caution: (x: any, y: any) => AdmonitionComponent(x, y, "caution"),
                        warning: (x: any, y: any) => AdmonitionComponent(x, y, "warning"),
                    },
                },
            ],
            [
                rehypeAutolinkHeadings,
                {
                    behavior: "append",
                    properties: {
                        className: ["anchor"],
                    },
                    content: {
                        type: "element",
                        tagName: "span",
                        properties: {
                            className: ["anchor-icon"],
                            "data-pagefind-ignore": true,
                        },
                        children: [
                            {
                                type: "text",
                                value: "#",
                            },
                        ],
                    },
                },
            ],
        ],
    },
    vite: {
        ssr: {
            external: [
                "@myriaddreamin/typst-ts-node-compiler"
            ]
        },
        build: {
            sourcemap: true,
            rollupOptions: {
                onwarn(warning, warn) {
                    // temporarily suppress this warning
                    if (
                        warning.message.includes("is dynamically imported by") &&
                        warning.message.includes("but also statically imported by")
                    ) {
                        return;
                    }
                    warn(warning);
                },
            },
        },

        server: {
            allowedHosts: [".sakurakat.systems"],
        },
    },
});
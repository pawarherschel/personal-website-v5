import type {
  LicenseConfig,
  NavBarConfig,
  ProfileConfig,
  SiteConfig,
} from './types/config'
import { LinkPreset } from './types/config'

export const siteConfig: SiteConfig = {
  title: 'Sakura Kat Systems',
  subtitle: "Herschel Pravin Pawar's Personal Site",
  lang: 'en',         // 'en', 'zh_CN', 'zh_TW', 'ja'
  themeColor: {
    hue: 330,         // Default hue for the theme color, from 0 to 360. e.g. red: 0, teal: 200, cyan: 250, pink: 345
    fixed: false,     // Hide the theme color picker for visitors
  },
  banner: {
    enable: true,
    src: 'https://r2.sakurakat.systems/website-banner.svg',    // Relative to the /src directory. Relative to the /public directory if it starts with '/'
  },
  favicon: [    // Leave this array empty to use the default favicon
    {
      src: 'https://r2.sakurakat.systems/favicon.svg'
    }
    // {
    //   src: '/favicon/icon.png',    // Path of the favicon, relative to the /public directory
    //   theme: 'light',              // (Optional) Either 'light' or 'dark', set only if you have different favicons for light and dark mode
    //   sizes: '32x32',              // (Optional) Size of the favicon, set only if you have favicons of different sizes
    // }
  ]
}

export const navBarConfig: NavBarConfig = {
  links: [
    LinkPreset.Home,
    LinkPreset.Archive,
    LinkPreset.About,
    LinkPreset.CV,
    {
      name: 'GitHub',
      url: 'https://github.com/pawarherschel',
      external: true,
    },
  ],
};

export const profileConfig: ProfileConfig = {
  avatar: 'https://r2.sakurakat.systems/profile-picture.png',
  name: 'Herschel Pravin Pawar',
  bio: 'Enthusiastic learner, curious about everything. Looking forward to work on projects that make a difference.',
  links: [
    {
      name: 'Email',
      icon: 'fa6-solid:envelope',
      url: 'mailto:pawarherschel@sakurakat.systems',
    },
    {
      name: 'Phone',
      icon: 'fa6-solid:phone',
      url: 'tel:+918310783472',
    },
    {
      name: 'LinkedIn',
      icon: 'fa6-brands:linkedin',
      url: 'https://www.linkedin.com/in/pawarherschel/',
    },
    {
      name: 'GitHub',
      icon: 'fa6-brands:github',
      url: 'https://github.com/pawarherschel',
    },
    {
      name: 'ORCID',
      icon: 'fa6-brands:orcid',
      url: 'https://orcid.org/0009-0003-3218-801X',
    },
  ],
};

export const licenseConfig: LicenseConfig = {
  enable: true,
  name: 'CC BY 4.0',
  url: 'https://creativecommons.org/licenses/by/4.0/',
};

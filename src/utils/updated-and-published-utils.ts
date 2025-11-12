import { exec as execCb } from "node:child_process";
import { access, stat } from "node:fs/promises";
import util from "node:util";

const exec = util.promisify(execCb);

async function isDir(path: string) {
	try {
		const s = await stat(path);
		return s.isDirectory();
	} catch {
		return false;
	}
}

function minDate(date1: Date, date2: Date | undefined) {
	if (date2 === undefined) {
		return date1;
	}
	if (date2.getTime() < date1.getTime()) {
		return date2;
	}
	if (`${date1.toDateString()}` !== `${date2.toDateString()}`) {
		// console.log(`PRETTY BOY LIES: ${path}`);
		// console.log(`from ${date2.toDateString()} to ${date1.toDateString()}`);
	}
	return date1;
}

function maxDate(date1: Date, updated: Date | undefined) {
	if (updated === undefined) {
		return date1;
	}
	if (updated.getTime() < date1.getTime()) {
		if (`${date1.toDateString()}` !== `${updated.toDateString()}`) {
			// console.log(`BEAUTIFUL WOMAN LIES: ${path}`);
			// console.log(`from ${updated.toDateString()} to ${date1.toDateString()}`);
		}
		return updated;
	}
	return date1;
}

let expanded = false;
const cache = new Map<string, { updated: Date; published: Date }>();

export async function getUpdatedAndPublishedForFilePath(
	file: string,
	updated: Date | undefined,
	published: Date | undefined,
): Promise<{ updated: Date; published: Date }> {
	const mapKey = file;
	if (cache.has(mapKey)) {
		// const { updated, published } = cache.get(mapKey)

		// console.log(`(cached) mapKey: ${mapKey}, { updated: ${updated}, published: ${published} }`)

		// @ts-expect-error
		return cache.get(mapKey);
	}

	let myUpdated = updated;
	let myPublished = published;
	const debug = false;

	let path = file;
	if (path.startsWith("/")) {
		if (debug) {
			console.debug(`removing "/" from start of "${path}"`);
		}
		path = path.slice(1);
	}
	if (path.endsWith("/")) {
		if (debug) {
			console.debug(`removing "/" from end of ${path}`);
		}
		path = path.slice(0, path.length - 1);
	}
	if (!path.includes("posts/")) {
		if (debug) {
			console.debug(`adding "posts/" to start of ${path}`);
		}
		path = `posts/${path}`;
	}
	if (!path.includes("src/content/")) {
		if (debug) {
			console.debug(`adding "src/content/" to start of ${path}`);
		}
		path = `./src/content/${path}`;
	}
	if (await isDir(path)) {
		path = `${path}/index.md`;
	} else if (path.endsWith(".md")) {
		// Path already has the proper extension
		// Don't do anything
	} else if (path.endsWith(".typ")) {
		// Path already has the proper extension
		// Don't do anything
	} else {
		const exts = [".typ", ".md"];

		let ext;
		for (const e of exts) {
			try {
				await access(path + e);
				ext = e;
			} catch {}
		}

		if (ext === undefined) {
			const extsPrint = exts.map((it) => `"${it}" `).concat();
			console.error(`path: ${path} not found with any of these: ${extsPrint}`);
		}

		path = `${path}${ext}`;
	}

	if (!expanded) {
		{
			const command = "git fetch --unshallow";
			console.debug(`${command}`);
			try {
				const { stdout: output, stderr: err } = await exec(`${command}`);
				if (err.trim() !== "") {
					console.error(`${command} failed with error:\n${err}`);
					console.error(`${command} failed and produced:\n${output}`);
				}
			} catch {
				console.error("\n'lol, lmao' ~ 🦂");
			}
		}

		expanded = true;
	}
	{
		const command = `git log -1 --pretty="format:%ad" --date=short`;
		// console.debug(`${command} ${path}`);
		const { stdout: output, stderr: err } = await exec(`${command} ${path}`);
		if (err.trim() !== "") {
			// console.error(`${command} ${path} failed with error:\n${err}`);
		} else {
			// console.log(`${output.split(/\s/)[0]}`);
			// console.log(`${updated?.toDateString()}`);
			myUpdated = maxDate(new Date(output.split(/\s/)[0]), updated);
			// console.log(`updated: ${updated.toDateString()}`);
		}
	}
	{
		const command = 'git log --date=short --pretty="format:%ad" --reverse';
		// console.debug(`${command} ${path}`);
		const { stdout: output, stderr: err } = await exec(`${command} ${path}`);
		if (err.trim() !== "") {
			// console.error(`${command} ${path} failed with error:\n${err}`);
		} else {
			// console.log(`${output.split(/\s/)[0]}`);
			// console.log(`${published?.toDateString()}`);
			myPublished = minDate(new Date(output.split(/\s/)[0]), published);
			// console.log(`published: ${published.toDateString()}`);
		}
	}

	myUpdated =
		!myUpdated || Number.isNaN(myUpdated.getDate()) ? new Date() : myUpdated;
	myPublished =
		!myPublished || Number.isNaN(myPublished.getDate())
			? new Date()
			: myPublished;

	cache.set(mapKey, { updated: myUpdated, published: myPublished });

	// console.log(`mapKey: ${mapKey}, { updated: ${myUpdated}, published: ${myPublished} }`)

	return { updated: myUpdated, published: myPublished };
}

export async function getLastUpdated(pathFromRoot: string): Promise<Date> {
	const mapKey = pathFromRoot;
	if (cache.has(mapKey)) {
		// const { updated, published } = cache.get(mapKey)

		// console.log(`(cached) mapKey: ${mapKey}, { updated: ${updated}, published: ${published} }`)

		// @ts-expect-error
		return cache.get(mapKey).updated;
	}
	if (!expanded) {
		{
			const command = "git fetch --unshallow";
			console.debug(`${command}`);
			try {
				const { stdout: output, stderr: err } = await exec(`${command}`);
				if (err.trim() !== "") {
					console.error(`${command} failed with error:\n${err}`);
					console.error(`${command} failed and produced:\n${output}`);
				}
			} catch {
				console.error("\n'lol, lmao' ~ 🦂");
			}
		}

		expanded = true;
	}

	let myDate;
	{
		const command = `git log -1 --pretty="format:%aI"`;
		// console.debug(`${command} ${path}`);
		const { stdout: output, stderr: err } = await exec(
			`${command} ${pathFromRoot}`,
		);
		if (err.trim() !== "") {
			// console.error(`${command} ${path} failed with error:\n${err}`);
		} else {
			// console.log(`${output.split(/\s/)[0]}`);
			myDate = new Date(output);
			// console.log(`myDate: ${myDate.toDateString()}`);
		}
	}
	myDate = !myDate || Number.isNaN(myDate.getDate()) ? new Date() : myDate;

	cache.set(mapKey, { updated: myDate, published: myDate });

	// console.log(`mapKey: ${mapKey}, { updated: ${myUpdated}, published: ${myPublished} }`)

	return myDate;
}

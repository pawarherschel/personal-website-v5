export function formatDateToYYYYMMDD(date?: Date): string {
	return (() => {
		if (date === null || date === undefined || Number.isNaN(date.getTime())) {
			return new Date();
		}

		return date;
	})()
		.toISOString()
		.substring(0, 10);
}

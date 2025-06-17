export function formatDateToYYYYMMDD(date: Date): string {
	return (() => {
		if (date === null || date === undefined || isNaN(date.getTime())) {
			return new Date();
		} else {
			return date;
		}
	})().toISOString().substring(0, 10);
}

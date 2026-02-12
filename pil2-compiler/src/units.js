const KB = 1024;
const MB = 1024 * KB;
const GB = 1024 * MB;
const TB = 1024 * GB;

class Units {
    static getHumanSize(size) {
        if (size < MB) {
            return Math.trunc((size * 100) / KB)/100 + ' KB';
        }
        if (size < GB) {
            return Math.trunc((size * 100) / MB)/100 + ' MB';
        }
        if (size < TB) {
            return Math.trunc((size * 100) / GB)/100 + ' GB';
        }
        return Math.trunc((size * 100) / TB)/100 + ' TB';
    }
    static getHumanTime(ms, short = true) {
        if (ms < 1000) {
            return Math.trunc(ms * 100)/100 + (short ? 'ms':' ms');
        }
        if (ms < 60000) {
            const seconds = Math.trunc(ms / 1000);
            const _ms = Math.trunc(ms - seconds * 1000);
            return seconds + (short ? 's':' seconds') + (_ms > 0 ? ' ' + _ms + (short ? 'ms':' ms'):'');
        }
        if (ms < 3600000) {
            const minutes = Math.trunc(ms / 60000);
            const seconds = Math.round((ms - minutes * 60000)/1000);
            return minutes + (short ? 'm':' minutes') + (seconds > 0 ? ' ' + seconds + (short ? 's':' seconds'):'');
        }
        const hours = Math.trunc(ms / 3600000);
        const minutes = Math.round((ms - hours * 3600000)/60000);
        return hours +  (short ? 'h':' hours') + (minutes > 0 ? ' ' + minutes + (short ? 'm':' minutes'):'');
    }
    static getMB(m1,m2) {
        if (typeof m2 === 'undefined') {
            return Math.round(m1 / 1048576);
        }
        return Math.round((m2-m1) / 1048576);
    }
}

module.exports = Units;
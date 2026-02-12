const { performance } = require('perf_hooks');

class Chrono {
    constructor (enabled = true) {
        this.enabled = enabled;
        this.times = [];
        if (enabled) {
            this.start = this.#start;
            this.step = this.#step;
            this.end = this.#end;
        } else {
            this.start = () => {};
            this.step = () => {};
            this.end = () => {};
        }
    }
    #start() {
        this.last = performance.now();
        this.times.push(this.last);
    }
    #end(msg = '') {
        this.last = performance.now();
        const start = this.times.pop();
        console.log(msg + '(ms):', this.last - start);
    }
    #step(msg = '') {
        const plast = this.last;
        this.last = performance.now();
        console.log(msg +' (ms):', this.last - plast);
    }
}

module.exports = Chrono;
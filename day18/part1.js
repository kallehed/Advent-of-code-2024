const fs = require('fs');

const input = fs.readFileSync(0, 'utf-8');
const coordinates = input.split('\n').map(line => line.split(',').map(Number));
const first1024 = coordinates.slice(0, 1024);

const bestDist = Array(71).fill().map(() => Array(71).fill(Infinity));
const blocked = Array(71).fill().map(() => Array(71).fill(false));

first1024.forEach(([x, y]) => {
    blocked[y][x] = true;
});

class PriorityQueue {
    constructor() {
        this.items = [];
    }

    enqueue(x, y, distance) {
        this.items.push({ x, y, distance });
        this.items.sort((a, b) => a.distance - b.distance);
    }

    dequeue() {
        return this.items.shift();
    }

    isEmpty() {
        return this.items.length === 0;
    }
}

const queue = new PriorityQueue();
queue.enqueue(0, 0, 0);

while (!queue.isEmpty()) {
    const { x, y, distance } = queue.dequeue();

    if (x < 0 || y < 0 || x >= 71 || y >= 71) continue;
    if (blocked[y][x]) continue;
    if (distance >= bestDist[y][x]) continue;

    bestDist[y][x] = distance;

    queue.enqueue(x + 1, y, distance + 1);
    queue.enqueue(x - 1, y, distance + 1);
    queue.enqueue(x, y + 1, distance + 1);
    queue.enqueue(x, y - 1, distance + 1);
}

console.log("result:", bestDist[70][70]);

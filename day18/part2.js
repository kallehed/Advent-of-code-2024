const fs = require('fs');

const input = fs.readFileSync(0, 'utf-8');
const coordinates = input.split('\n').map(line => line.split(',').map(Number));

const blocked = Array(71).fill().map(() => Array(71).fill(false));

coordinates.slice(0, 1024).forEach(([x, y]) => {
    blocked[y][x] = true;
});

function findPath() {
    const visited = Array(71).fill().map(() => Array(71).fill(false));
    const queue = [[0, 0]];
    visited[0][0] = true;

    while (queue.length > 0) {
        const [x, y] = queue.shift();

        if (x === 70 && y === 70) return true;

        const directions = [[1, 0], [-1, 0], [0, 1], [0, -1]];
        for (const [dx, dy] of directions) {
            const nx = x + dx;
            const ny = y + dy;

            if (nx >= 0 && ny >= 0 && nx < 71 && ny < 71 &&
                !blocked[ny][nx] && !visited[ny][nx]) {
                visited[ny][nx] = true;
                queue.push([nx, ny]);
            }
        }
    }

    return false;
}

for (let i = 1024; i < coordinates.length; i++) {
    const [x, y] = coordinates[i];
    blocked[y][x] = true;
    console.log(i);

    if (!findPath()) {
        console.log(`${x},${y}`);
        break;
    }
}

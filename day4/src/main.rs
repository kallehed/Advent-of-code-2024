use std::{io::stdin, iter};
// super duper, tried my hardest to make it a stream solution
fn check_dir(matrix: &[Vec<u8>], check: &[u8], from: (usize, usize)) -> usize {
    [
        (1, 0),
        (0, 1),
        (-1, 0),
        (0, -1),
        (1, 1),
        (-1, -1),
        (1, -1),
        (-1, 1),
    ]
    .iter()
    .filter(|&d| {
        iter::successors(Some((from.0 as isize, from.1 as isize)), |x| {
            Some((x.0 + d.0, x.1 + d.1))
        })
        .map_while(|x| matrix.get(x.0 as usize).and_then(|y| y.get(x.1 as usize)))
        .chain(iter::repeat(&0u8))
        .zip(check.iter())
        .all(|(&x, &y)| x == y)
    })
    .count()
}

//stupid copy paste solution
fn check_cross(matrix: &[Vec<u8>], from: (usize, usize)) -> usize {
    if matrix[from.0][from.1] != b'A' {
        return 0;
    }

    if matrix[from.0 - 1][from.1 - 1] == b'S' {
        if matrix[from.0 + 1][from.1 + 1] != b'M' {
            return 0;
        }
    } else if matrix[from.0 - 1][from.1 - 1] == b'M' {
        if matrix[from.0 + 1][from.1 + 1] != b'S' {
            return 0;
        }
    } else {
        return 0;
    }

    if matrix[from.0 + 1][from.1 - 1] == b'S' {
        if matrix[from.0 - 1][from.1 + 1] != b'M' {
            return 0;
        }
    } else if matrix[from.0 + 1][from.1 - 1] == b'M' {
        if matrix[from.0 - 1][from.1 + 1] == b'S' {
        } else {
            return 0;
        }
    } else {
        return 0;
    }
    1
}
fn main() {
    let matrix: Vec<Vec<u8>> = stdin()
        .lines()
        .map(|x| x.unwrap().as_bytes().to_vec())
        .collect();
    let mut count: usize = 0;
    for i in 0..matrix.len() {
        for j in 0..matrix[i].len() {
            count += check_dir(&matrix, &[b'X', b'M', b'A', b'S'], (i, j));
        }
    }
    println!("p1 {}", count);

    let mut count2: usize = 0;

    for i in 1..(matrix.len() - 1) {
        for j in 1..(matrix[i].len() - 1) {
            count2 += check_cross(&matrix, (i, j));
        }
    }
    println!("p2 {}", count2);
}
